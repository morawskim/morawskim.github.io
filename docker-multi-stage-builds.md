# docker multi-stage builds

Multi-stage builds pozwala nam osiągnąć mniejsze obrazy. Finalny obraz nie zawiera bibliotek/narzędzi, które są nam niezbędne do zbudowania artefaktu, ale niepotrzebne w działającym kontenerze. Dzięki temu skrócony zostanie także czas  pobierania i wczytywania obrazu.

W celu skorzystania z multi-stage musimy skorzystać z instrukcji `FROM` więcej niż raz. Każda instrukcja `FROM` oznacza początek nowego etapu (stage). Możemy go nazwać za pomocą słowa `AS`.

Jeśli nasz `Dockerfile`, wytwarza wiele artefaktów, które musimy skopiować do finalnego obrazu, ale nie jesteśmy świadomi wszystkich zmodyfikowanych lub utworzonych plików polecenie `docker container diff` będzie pomocne.

Budując obraz aplikacji PHP, potrzebujemy doinstalowania dodatkowych rozszerzeń PHP.
Musimy jednak wiedzieć gdzie polecenia takie jak `docker-php-ext-install` instalują swoje artefakty.
Do tego służy polecenie `docker container diff`. Za pomocą tego polecenia zbadany zmiany wprowadzone do plików lub katalogów w systemie plików kontenera.

Uruchamiamy w kontenerze powłokę bash - `docker run --rm -it php:7.3-apache bash`
To w niej będziemy instalować niezbędne pakiety i rozszerzenia PHP.

W nowym oknie terminala uruchamiamy polecenie `docker ps`, aby poznać identyfikator uruchomionego kontenera z PHP.
W moim przypadku jest to `cea79cb5c351`.

Na kontenerze wywołuje polecenia, które wprowadzają zmiany w systemie plików.
W moim przypadku jest to instalacja kilku pakietów dev i instalacja rozszerzeń PHP.

```
apt-get update && \
    apt-get -y install \
            libicu-dev \
            libgmp-dev \
        --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/local/include/

docker-php-ext-install \
        pdo_mysql \
        intl \
        gmp

echo -e "no\nno\nno\n" | pecl install redis-5.2.1 && \
    echo "extension=redis.so" | tee /usr/local/etc/php/conf.d/redis.ini
```

Po wykonaniu tych kroków mogę wywołać polecenie `docker container diff <ID_KONTENERA>`.
Zobaczymy listę zmian w systemie plików.
W pierwszej kolumnie zobaczymy `A`, `C` lub `D`. Symbol `A` oznacza plik lub katalog został dodany. Symbol `D` oznacza plik lub katalog został skasowany. Zaś symbol `C` oznacza plik lub katalog został zmieniony.

Przeglądając wynik zobaczymy nasze pliki z rozszerzeniami PHP i konfiguracją.
```
....
A /usr/local/lib/php/extensions/no-debug-non-zts-20180731/gmp.so
A /usr/local/lib/php/extensions/no-debug-non-zts-20180731/intl.so
A /usr/local/lib/php/extensions/no-debug-non-zts-20180731/pdo_mysql.so
A /usr/local/lib/php/extensions/no-debug-non-zts-20180731/redis.so
....
A /usr/local/etc/php/conf.d/redis.ini
A /usr/local/etc/php/conf.d/docker-php-ext-gmp.ini
A /usr/local/etc/php/conf.d/docker-php-ext-intl.ini
A /usr/local/etc/php/conf.d/docker-php-ext-pdo_mysql.ini
...
```

Jednak rozszerzenia PHP do poprawnego działania potrzebują także bibliotek współdzielonych C.
Możemy to zweryfikować wywołując polecenie ldd - `ldd /usr/local/lib/php/extensions/no-debug-non-zts-20180731/gmp.so`
```
linux-vdso.so.1 (0x00007fff4078a000)
libgmp.so.10 => /usr/lib/x86_64-linux-gnu/libgmp.so.10 (0x00007f328f7c8000)
libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f328f607000)
/lib64/ld-linux-x86-64.so.2 (0x00007f328f865000)
```
Jak widać rozszerzenie PHP `gmp` korzysta z biblioteki `/usr/lib/x86_64-linux-gnu/libgmp.so.10`
Do wyszukiwania ścieżek bibliotek możemy użyć frazy `.so`.
```
...
A /usr/lib/x86_64-linux-gnu/libgmpxx.so.4.5.2
C /usr/lib/x86_64-linux-gnu/libicui18n.so.63
A /usr/lib/x86_64-linux-gnu/libicuio.so
C /usr/lib/x86_64-linux-gnu/libicui18n.so.63.1
C /usr/lib/x86_64-linux-gnu/libicutest.so.63
A /usr/lib/x86_64-linux-gnu/libgmpxx.so.4
A /usr/lib/x86_64-linux-gnu/libicui18n.so
C /usr/lib/x86_64-linux-gnu/libicuio.so.63
A /usr/lib/x86_64-linux-gnu/libicutest.so
A /usr/lib/x86_64-linux-gnu/libicutu.so
A /usr/lib/x86_64-linux-gnu/libicuuc.so
A /usr/lib/x86_64-linux-gnu/libgmpxx.so
C /usr/lib/x86_64-linux-gnu/libicutest.so.63.1
C /usr/lib/x86_64-linux-gnu/libicuuc.so.63
C /usr/lib/x86_64-linux-gnu/libicuuc.so.63.1
C /usr/lib/x86_64-linux-gnu/libicudata.so.63.1
C /usr/lib/x86_64-linux-gnu/libicudata.so.63
A /usr/lib/x86_64-linux-gnu/libgmp.so
C /usr/lib/x86_64-linux-gnu/libicuio.so.63.1
C /usr/lib/x86_64-linux-gnu/libicutu.so.63.1
C /usr/lib/x86_64-linux-gnu/libicutu.so.63
A /usr/lib/x86_64-linux-gnu/libicudata.so
...
```

Mając już zbudowane artefakty możemy przejść do drugiego etapu.
Instalujemy pakiety `libicu63` i `libgmp10`.

Docker obecnie nie pozwala na połączeniu wielu instrukcji `COPY` w jedną warstwę. (https://github.com/moby/moby/issues/33551). Aby skorzystać z tej funkcji musimy włączyć [tryb eksperymentalny](https://github.com/moby/buildkit/blob/dc792e75b9adab05f16fcbdd274b9eaf639348c3/frontend/dockerfile/docs/experimental.md).

>If you are using Docker v18.06 or later, BuildKit mode can be enabled by setting export DOCKER_BUILDKIT=1 on the client side. Docker v18.06 also requires the daemon to be running in experimental mode.

[Przykład z włączonym BuildKit](https://devops.stackexchange.com/a/6089)

Jeśli nie możemy włączyć BuildKit to musimy skorzystać z wielu instrukcji `COPY`, albo z jednej instrukcji `COPY` i instrukcji `RUN`, która przekopiuje nam artefakty.


```
#etap1
#...
RUN mkdir -p /artifacts \
    && cp -r --parents /usr/local/lib/php/extensions/no-debug-non-zts-20180731/ /artifacts/ \
    && cp -r --parents /usr/local/etc/php/conf.d/ /artifacts/
#...

#etap2
#....
COPY --from=build /artifacts/ /artifacts
RUN cp -rv /artifacts/* /
#....
```
