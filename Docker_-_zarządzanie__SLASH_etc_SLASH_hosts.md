Docker - zarządzanie /etc/hosts
===============================

Jeśli na lokalnym środowisku dev pracuję z certyfikatami SSL, często muszę weryfikować poprawność działania certyfikatów. Niestety przeglądarki buforują certyfikaty i ciągła ich zmiana powoduje problemy (jeśli nie zmienimy serial number). W takim przypadkach odpalam kontener docker z przeglądarką chrome. I tam zarządzam certyfikatami.

Musimy jednak wpierw dopisać do /etc/hosts kontenera naszą domenę i adres IP. Do tego wymagany jest docker w wersji 1.3.1 lub późniejszy.

``` bash
docker run -p 127.0.0.1:5901:5900 --add-host domena.dev:192.168.0.8 siomiz/chrome
```

Po uruchomieniu kontenera możemy się podłączyć przez vnc i zobaczyć naszą stroną www (domena.dev).

``` bash
vncviewer 127.0.0.1:5901
```

<http://jasani.org/2014/11/19/docker-now-supports-adding-host-mappings/>