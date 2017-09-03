Tworzenie pakietu dpkg
======================

Ttworzymy strukturę katalogów dla pakietu debiana.

``` bash
mkdir -p speedtest/{DEBIAN,usr/local/bin,usr/lib/arm-linux-gnueabihf}
```

W katalogu DEBIAN tworzymy plik control. Jest on wymagany.

```
Package: speedtest
Version: 0.1.0-1+deb8u2
Architecture: armhf
Maintainer: Marcin Morawski <marcin@morawskim.pl>
Depends: libcurl3 (>= 7.26), libxml2 (>= 2.8), libssl1.0.0 (>= 1.0)
Installed-Size: 68320
Section: web
Priority: optional
Multi-Arch: foreign
Homepage: http://morawskim.pl
Description: Speed Test (test prędkości łącza) to narzędzie, dzięki któremu sprawdzisz prędkość pobierania
 i wysyłania danych pomiędzy swoim komputerem a Internetem.
```

Dodatkowo jeśli chcemy nadać odpowiednie uprawnienia i/lub właściciela pliku to tworzymy plik postinst. Plik ten, to po prostu skrypt powłoki.

``` bash
#!/bin/sh

BIN_PATH='/usr/local/bin/speedtest'
LIB_PATH='/usr/lib/arm-linux-gnueabihf/libspeedtest.so'

if [ -f $BIN_PATH ]; then
  chown root:root $BIN_PATH
  chmod 0755 $BIN_PATH
fi

if [ -f $LIB_PATH ]; then
  chown root:root $LIB_PATH
  chmod 0644 $LIB_PATH
fi
```

Kopiujemy pliki binarne programu wykonalnego i biblioteki odpowiednio do katalogu usr/local/bin i usr/lib/arm-linux-gnueabihf. Ścieżka mówi nam, gdzie dane pliki zostaną zainstalowane na docelowym systemie. W tym przypadku do /usr/local/bin i /usr/lib/arm-linux-gnueabihf.

``` bash
dpkg-deb --build speedtest/
```

Wywołanie powyższego polecenia spowoduje utworzenie pakietu dpkg. Taki pakiet można zainstalować poprzez polecenie

``` bash
dpkg -i speedtest.dpkg
```