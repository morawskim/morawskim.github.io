# SSLKEYLOGFILE badanie ruchu SSL

Wsparcie dla `SSLKEYLOGFILE` może być włączone lub wyłączone podczas kompilacji.

## Przeglądarki

`SSLKEYLOGFILE=~/ssl.log chromium`

## curl

`SSLKEYLOGFILE='/home/marcin/ssl.log' curl -I 'https://google.com/qwe'`

## mitmproxy

`SSLKEYLOGFILE='/home/marcin/ssl.log' mitmproxy`

## Analiza w wireshark

Uruchamiamy program wireshark.
W opensuse musimy uruchomić program z uprawnieniami roota.
Ponieważ jest to oprogramowanie graficzne nie możemy wywołać programu przez sudo. Korzystamy z polecenia `xdg-su -c wireshark`.

Jeśli nie chcemy wywoływać programu wireshark z uprawnieniami root'a możemy odpowiednio skonfigurować wireshark do działania w trybie zwykłego użytkownika. W takim przypadku program będzie miał ograniczone uprawnienia root.
* https://wiki.wireshark.org/CaptureSetup/CapturePrivileges
* http://www.linuxandubuntu.com/home/how-to-use-wireshark-to-inspect-network-traffic
* https://codeghar.wordpress.com/2014/06/03/run-wireshark-in-opensuse-as-non-root-user/

Wybieramy z menu `Edit->Preferences->Protocols->TLS` i w polu `(Pre)-Master-Secret log filename` podajemy ścieżkę do pliku z logiem SSL.
Ustawiamy filtr `tcp.port==443 and (http or http2)`.
Wireshark rozszyfruje ruch SSL. Na dole, pojawi się zakładka `Decrypted SSL` po wybraniu ramki.

## PHP-FPM i SSLKEYLOGFILE

Uruchamiając prosty kod PHP (SAPI CLI) wykorzystujący rozszerzenie curl z ustawioną zmienną środowiskową `SSLKEYLOGFILE` byłem w stanie odszyfrować request i response w Wireshark.
Podobny kod nie działał jednak w PHP-FPM - [PHP-FPM and SSLKEYLOGFILE issue](https://stackoverflow.com/questions/66995564/php-fpm-and-sslkeylogfile-issue).

``` php
$url = 'https://tls-v1-2.badssl.com:1012/';
$curl = curl_init();
curl_setopt($curl, CURLOPT_URL, $url);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HEADER, false);
$data = curl_exec($curl);
curl_close($curl);
```

Wykorzystując slajd z [prezentacji PHP](https://github.com/php/presentations/blob/cf45b28c208d06c141c1ac4a7c15a3857a1aaf29/slides/mongodb/wireshark-ssl-keys.xml) postanowiłem sprawdzić te rozwiązanie z PHP-FPM.

Wykorzystując oficjalny obraz kontenera PHP-FPM (`php:8.1-fpm`) instalujemy dodatkowe pakiety (libssl-dev, wget i tcpdump), a także kompilujemy bibliotekę C z pobranego kodu.
```
RUN apt-get -y update && apt install -y libssl-dev wget tcpdump && wget https://git.lekensteyn.nl/peter/wireshark-notes/plain/src/sslkeylog.c && cc sslkeylog.c -shared -o libsslkeylog.so -fPIC -ldl
RUN  echo env[SSLKEYLOGFILE]=/tmp/ssl-key-logger >> /usr/local/etc/php-fpm.d/www.conf
```

W `docker-compose.yml` dodajemy zmienną środowiskową `LD_PRELOAD`.
Dzięki temu wczytana zostanie nowa biblioteka libsslkeylog przez php-fpm.

```
services:  
  php:
    # ...
    environment:
      LD_PRELOAD: /path/to/libsslkeylog.so
```

Po restarcie kontenera ponownie się do niego podłączamy i wywołujemy polecenie `ldd /usr/local/sbin/php-fpm`  zobaczymy, że biblioteka `libsslkeylog` została załadowana `/path/libsslkeylog.so (0x00007f1390c87000)`.
Uruchamiamy polecenie do zapisu ruchu sieciowego na porcie 1012 (strona https://tls-v1-2.badssl.com nasłucuje na niestandardowym porcie 1012) - `tcpdump -i any -s 0 -A 'tcp port 1012' -w app.cap`.
Następnie musimy skopiować z kontenera pliki `app.cap` i `/tmp/ssl-key-logger` i otworzyć je w Wireshark.

[Wireshark Tutorial: Decrypting HTTPS Traffic](https://unit42.paloaltonetworks.com/wireshark-tutorial-decrypting-https-traffic/)
[sslkeylog.c](https://git.lekensteyn.nl/peter/wireshark-notes/tree/src/sslkeylog.c)
[kopia sslkeylog.c](https://gist.github.com/morawskim/f319560013ee992c4c5d964e2b0e504a)
