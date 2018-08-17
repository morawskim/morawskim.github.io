# Redis - debugging

## Obraz kontenera

Postanowiłem debugować redisa w kontenerze. Dlatego podczas jego tworzenia musiałem dodać pewnie dodatkowe uprawnienia.
```
docker run --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -it opensuse/leap:15.0 bash
```

Jeśli nie nadamy tych uprawnień to `gdb` wyświetli taki komunikat:
```
warning: Error disabling address space randomization: Operation not permitted
warning: Could not trace the inferior process.
Error:
warning: ptrace: Operation not permitted
```

W kontenerze zainstalowałem dodatkowe programy i włączyłem repozytoria debug i source.
```
zypper in git gdb strace ltrace vim binutils valgrind curl perf
zypper mr --enable repo-debug
zypper mr --enable repo-debug-non-oss
zypper mr --enable repo-debug-update
zypper mr --enable repo-debug-update-non-oss
zypper mr --enable repo-source
zypper ref
```

Postanowiłem zainstalować także pakiety wchodzące w skład wzorca `devel_rpm_build`.
```
zypper in -t pattern devel_rpm_build
```

Wyeksportowałem bazowy obraz do serwisu `hub.docker.com`.
Obraz znajduje się pod nazwą `morawskim/opensuse-debug:15.0`.

## Profilowanie

Przeglądając kod na githubie wytypowałem funkcję `geohashGetDistance` jako odpowiedzialną za obliczenie odległości między dwoma punktami geograficznymi.
Jednak chciałem się upewnić czy mam rację. Postanowiłem śledzić wywołane funkcje.

Zainstalowałem `redis` wraz z symbolami debugowania i kodem źródłowym.
```
zypper in redis redis-debuginfo redis-debugsource
```

Kopiujemy domyślny plik konfiguracyjny.
```
cp /etc/redis/default.conf.example /etc/redis/default.conf
```
W pliku konfiguracyjnym `/etc/redis/default.conf` klucz `daemonize` był domyślnie ustawiony na `false`.

Teraz możemy uruchomić serwer redis i monitorować wywołane funkcje
```
valgrind --tool=callgrind /usr/sbin/redis-server /etc/redis/default.conf
```
Dzięki temu wygenerowany zostanie plik z wywołanymi funkcjami. Musimy tylko podłączyć się przez klienta `redis-cli` i wykonać polecenia. Przykład tych poleceń jest zamieszczony dalej. Mając taki plik możemy go otworzyć w KcacheGrid. Mając pewne podejrzenia, jaką funkcja C, wywołuje redis do obliczenia odległości między dwoma punktami geograficznymi, możemy ją wyszukać. W tym przypadku chodzi o funkcję `geohashGetDistance`.


## Debugowanie

Podłączamy się do uruchomionego kontenera. I wywołujemy polecenie
`gdb /usr/sbin/redis-server`

W konsoli `gdb` wpisujemy poniższe polecenia:
```
b geohashGetDistance
r /etc/redis/default.conf
```

W innym oknie terminala podłączonym do kontenera tworzymy plik `redis-data` i wklejamy zawartość:
```
GEOADD TEST 52.5400381 19.6289084 "plock"
GEOADD TEST 52.2326063 20.7810086 "warszawa"
GEODIST TEST plock warszawa km
```

Wywołujemy polecenie
```
cat redis-data | redis-cli
```

Przy próbie obliczenia odległości w oknie z gdb, będziemy mogli debugować kod.
Serwer redis zatrzymał się na naszym breakpointcie
```
geohashGetDistance (lon1d=52.540035545825958, lat1d=19.628907272493009, lon2d=52.232606112957001,
lat2d=20.781009011605029) at geohash_helper.c:211
```

Pomimo że redis został skompilowany z optymalizacją, to możemy wyświetlić dane niektórych zmiennych.
```
p u
$10 = 0.010053814953103753
p v
$11 = -0.0026828246922473127
p EARTH_RADIUS_IN_METERS
$12 = 6372797.5608559996
```

Wynik odległości:
```
#0 addReplyDoubleDistance (c=c@entry=0x7ffff6f61340, d=132.10075440711097) at geo.c:179
```

## Kompilacja redis bez optymalizacji

Podczas sesji debugowania nie mogłem wyświetlić wartości wszystkich zmiennych.
Wynika to z optymalizacji kodu przez kompilator. Postanowiłem zbudować własny pakiet `redis` bez optymalizacji kodu.

Wpierw instalujemy pakiet źródłowy `redis` wraz z wszystkimi zależnościami do jego zbudowania.
```
zypper si redis
```
Plik spec, kod źródłowy i poprawki dostarczane przez openSuSE znajdują się w katalogu `/usr/src/packages/`

Zmodyfikowałem plik `redis.spec`.
Do polecenia make przekazywana była zmienna `CFLAGS`. Dopisałem wyłączenie optymalizacji kodu `-O0`.
Więc ta linia po zmianach wygląda tak:
```
make %{?_smp_mflags} CFLAGS="%{optflags} -O0" V=1
```

Po zbudowaniu i zainstalowaniu swojego pakietu `redis` mogłem już w gdb wyświetlać wszystkie zdefiniowane zmienne w kodzie.

```
p lat1r
$1 = 0.34258906047366278

p lon1r
$2 = 0.9169966093895191

p lat2r
$3 = 0.36269702913912027

p lon2r
$4 = 0.91163095356841684

p u
$6 = 0.010053814953103753

p v
$7 = -0.0026828246922473127
```
