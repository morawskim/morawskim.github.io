# Redis - debugging

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

W kontenerze zainstalowałem dodatkowe programy i włączyłem repozytoria debug dla opensuse.
```
zypper in git gdb strace ltrace vim binutils valgrind curl
zypper mr --enable repo-debug
zypper mr --enable repo-debug-non-oss
zypper mr --enable repo-debug-update
zypper mr --enable repo-debug-update-non-oss
zypper ref
```

Następnie instalujemy `redis` wraz z symbolami debugowania i kodem źródłowym.
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
valgrind --tool=callgrind  /usr/sbin/redis-server /etc/redis/default.conf
```
Dzięki temu wygenerowany zostanie plik z wywołanymi funkcjami. Musimy tylko podłączyć się przez klienta `redis-cli` i wykonać polecenia. Przykład tych poleceń jest zamieszczony dalej. Mając taki plik możemy go otworzyć w KcacheGrid. Mając pewne podejrzenia, jaką funkcja C, wywołuje redis do obliczenia odległości między dwoma punktami geograficznymi, możemy  ją wyszukać. W tym przypadku chodzi o funkcję `geohashGetDistance`.

Podłączamy się do uruchomionego kontenera w drugim oknie terminala. I wywołujemy polecenie
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
#0  addReplyDoubleDistance (c=c@entry=0x7ffff6f61340, d=132.10075440711097) at geo.c:179
```
