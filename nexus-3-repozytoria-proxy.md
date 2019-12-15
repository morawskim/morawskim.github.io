# Nexus 3 - repozytoria proxy

Oprogramowanie ma określoną datę EOL (End-of-life), po której wsparcie się kończy.
[Strona endoflife zawiera linki do sprawdzania dat EOL różnych narzędzi i technologii.](https://endoflife.date/)
Nawet pięcioletnie wsparcie dla Ubuntu LTS to często zbyt mało. Po wyłączeniu repozytorium, nie jesteśmy w stanie odtworzyć środowisk. Czy to produkcyjnych czy deweloperskich.
Aby zaradzić tym problemom musimy posiadać oprogramowanie Software repository, np. Nexus. Software repository pełni rolę pośrednika. Wszystkie dystrybucje, kod korzysta z tego pośrednika do pobierania pakietów/zależności. W naszej sieci przechowywane są tylko te pakiety, które są faktycznie wykorzystywane, co jest znacznie bardziej efektywne.

## proxy apt

Chcemy utworzyć pośrednik dla repozytorium `ppa:ondrej/php`.
W dystrybucji Ubuntu wywołalibyśmy polecenie `add-apt-repository ppa:ondrej/php`, aby dodać te repozytorium. Jednak nie chcemy korzystać z oryginalnego repo, a z naszej kopii.
Musimy więc zdobyć URL do tego repozytorium.

Wchodzimy więc na stronę https://launchpad.net/~ondrej
Następnie wybieramy projekt `***** The main PPA for supported PHP versions with many PECL extensions *****`
Klikamy na `Technical details about this PPA`
Możemy wybrać dla której wersji dystrybucji chcemy zobaczyć adresy URL.
W naszym przypadku dla Bionic 18.04 dostajemy:
```
deb http://ppa.launchpad.net/ondrej/php/ubuntu bionic main
deb-src http://ppa.launchpad.net/ondrej/php/ubuntu bionic main
```

Przechodzimy do Nexus i dodajemy nowe repozytorium `apt (proxy)` podając uzyskane dane - https://help.sonatype.com/repomanager3/formats/apt-repositories#AptRepositories-ProxyingAptRepositories

Otrzymamy adres HTTP do naszego repozytorium np. `nexus.192.168.15.28.xip.io/repository/php74.proxy/`

Teraz musimy skonfigurować Ubuntu i dodać do niego nasze lokalne repozytorium zamiast zdalnego ppa.
Możemy korzystać z własnych gotowych obrazów Ubuntu lub wykorzystać provisioning. W tym przypadku jednak zrobimy to ręcznie w najprostszy sposób.

Będąc zalogowanym do naszego Ubuntu, dodajemy repozytorium wywołując polecenie `echo 'deb http://<nexus_username>:<nexus_password>@nexus.192.168.15.28.xip.io/repository/php74.proxy/ bionic main' >> /etc/apt/sources.list.d/php.list`

Musimy dodać klucz publiczny GPG, który służył do podpisania pakietów deb. W kroku gdzie uzyskaliśmy adres URL repozytorium znajduje się także identyfikator klucza - `14AA40EC0831756756D7F66C4F4EA0AAE5267A6C`.

Wywołujemy polecenie do pobrania publicznego klucza GPG - `apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 14AA40EC0831756756D7F66C4F4EA0AAE5267A6C`

Jeśli podczas importu klucza GPG dostaliśmy błąd `E: gnupg, gnupg2 and gnupg1 do not seem to be installed, but one of them is required for this operation`, to musimy zainstalować pakiet `gnupg`.

Ostatecznie możemy wywołać polecenie `apt-get update` do pobrania metadanych repozytoriów.
Na wyjściu powinniśmy dostać ostrzeżenie, docelowo nie powinniśmy przechowywać danych autoryzacyjnych w pliku `sources.list`:
```
Usage of apt_auth.conf(5) should be preferred over embedding login information directly in the sources.list(5) entry for 'http://nexus.192.168.15.28.xip.io/repository/php74.proxy'
```

Jeśli podczas aktualizowania metadanych repozytoriów otrzymaliśmy błąd `The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 4F4EA0AAE5267A6C`, to nie zaimportowaliśmy klucza GPG.

Możemy wywołać polecenie `apt-get install -y php7.4`. Niezbędne pakiety PHP zostaną zainstalowane, a w panelu Nexus zobaczymy, że nasze proxy repo zawiera tylko ściągnięte pakiety PHP.
Dla pełnego sukcesu powinniśmy jednak korzystać z proxy dla wszystkich repozytoriów, a nie tylko wybranych.

```
Get:30 http://nexus.192.168.15.28.xip.io/repository/php74.proxy bionic/main amd64 libxml2 amd64 2.9.9+dfsg-1+ubuntu18.04.1+deb.sury.org+2 [720 kB]
Get:31 http://nexus.192.168.15.28.xip.io/repository/php74.proxy bionic/main amd64 php-common all 2:70+ubuntu18.04.1+deb.sury.org+6 [15.2 kB]
Get:32 http://nexus.192.168.15.28.xip.io/repository/php74.proxy bionic/main amd64 php7.4-common amd64 7.4.0-1+ubuntu18.04.1+deb.sury.org+1 [976 kB]
Get:33 http://nexus.192.168.15.28.xip.io/repository/php74.proxy bionic/main amd64 php7.4-json amd64 7.4.0-1+ubuntu18.04.1+deb.sury.org+1 [18.6 kB]
Get:34 http://nexus.192.168.15.28.xip.io/repository/php74.proxy bionic/main amd64 php7.4-opcache amd64 7.4.0-1+ubuntu18.04.1+deb.sury.org+1 [195 kB]
Get:35 http://nexus.192.168.15.28.xip.io/repository/php74.proxy bionic/main amd64 php7.4-readline amd64 7.4.0-1+ubuntu18.04.1+deb.sury.org+1 [12.2 kB]
Get:36 http://nexus.192.168.15.28.xip.io/repository/php74.proxy bionic/main amd64 libpcre2-8-0 amd64 10.33-1+ubuntu18.04.1+deb.sury.org+1 [191 kB]
Get:37 http://nexus.192.168.15.28.xip.io/repository/php74.proxy bionic/main amd64 libsodium23 amd64 1.0.18-1+ubuntu18.04.1+deb.sury.org+1 [150 kB]
Get:38 http://nexus.192.168.15.28.xip.io/repository/php74.proxy bionic/main amd64 php7.4-cli amd64 7.4.0-1+ubuntu18.04.1+deb.sury.org+1 [1392 kB]
Get:39 http://nexus.192.168.15.28.xip.io/repository/php74.proxy bionic/main amd64 libapache2-mod-php7.4 amd64 7.4.0-1+ubuntu18.04.1+deb.sury.org+1 [1336 kB]
Get:40 http://nexus.192.168.15.28.xip.io/repository/php74.proxy bionic/main amd64 openssl amd64 1.1.1d-1+ubuntu18.04.1+deb.sury.org+2 [827 kB]
Get:41 http://nexus.192.168.15.28.xip.io/repository/php74.proxy bionic/main amd64 php7.4 all 7.4.0-1+ubuntu18.04.1+deb.sury.org+1 [21.0 kB]
```
