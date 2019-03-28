# apache2 - 403 Forbidden jeśli user agent nie jest "na białej liście"

Posiadam serwer HTTP do hostowania swoich pakietów RPM. W pewnym momencie zacząłem dostawać komunikaty `403 Forbidden`. Próba wejścia przez przeglądarkę internetową kończyła się sukcesem - kodem odpowiedzi 200.

Fragment access loga apache:
```
8.154.XXX.XXX - - [26/Mar/2019:19:57:21 +0100] "HEAD /openSUSE_Leap_15.0/repodata/repomd.xml HTTP/1.1" 403 126 "-" "ZYpp 17.7.2 (curl 7.60.0)"
78.154.XXX.XXX - - [26/Mar/2019:19:58:06 +0100] "GET /openSUSE_Leap_15.0/repodata/repomd.xml HTTP/1.1" 200 995 "-" "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0"
```

Obstawiałem problem z `User-agent`, który jest ustawiany przez program `zypper`.
Sprawdziłem to podłączając `zypper` pod serwer proxy poleceniem `http_proxy=127.0.0.1:8080 zypper ref`.
Moje przypuszczenia okazały się trafne. Zypper ustawiał `ZYpp 17.7.2 (curl 7.60.0)` jako wartośc dla nagłówka `User-Agent`. Zgodnie z kodem źródłowym - https://github.com/openSUSE/libzypp/blob/d7a54d50bd7bf9825e67b191ae768386b59caf12/zypp/media/MediaCurl.cc#L535


Do pliku `.htaccess` dodałem:
```
Allow from all
Satisfy any
```

Po tej zmianie mogłem już pobierać pakiety RPM, a polecenie `curl -v -A 'ZYpp 17.7.2 (curl 7.60.0)' 'http://rpm.morawskim.pl/openSUSE_Leap_15.0/repodata/repomd.xml'` zwracało zawartość pliku `repomd.xml`.
