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

Wybieramy z menu `Edit->Preferences->Protocols->SSL` i w polu `(Pre)-Master-Secret log filename` podajemy ścieżkę do pliku z logiem SSL.
Ustawiamy filtr `tcp.port==443 and (http or http2)`.
Wireshark rozszyfruje ruch SSL. Na dole, pojawi się zakładka `Decrypted SSL` po wybraniu ramki.
