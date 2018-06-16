CUPS - dodawanie drukarki
=========================

Instalujemy niezbędne pakiety: cups i cups-client.

``` bash
apt-get -y update && apt-get -y upgrade && apt-get -y install cups cups-client
```

Opcjonalnie ściągamy sterownik do naszej drukarki. I przenosimy plik do katalogu "/etc/cups/ppd/"

``` bash
wget 'http://www.openprinting.org/ppd-o-matic.php?driver=gdi&printer=samsung-ml-2010&show=0' -O samsung-ml-2010-gdi.ppd
mv samsung-ml-2010-gdi.ppd /etc/cups/ppd/
```

Wyszukujemy podłączone drukarki.

``` bash
sudo /usr/sbin/lpinfo -v
network ipps
network lpd
network socket
network http
direct hp
network https
network ipp
network beh
direct usb://Samsung/ML-2010?serial=621BKDPA24185W.
network smb
direct hpfax
```

Dodajemy drukarkę.

``` bash
sudo /usr/sbin/lpadmin -p samsung2010ml -E -v usb://Samsung/ML-2010?serial=4621BKDPA24185W. -P /etc/cups/ppd/samsung-ml-2010-gdi.ppd
```

Konfigurujemy drukarkę.

``` bash
sudo /usr/sbin/cupsaccept samsung2010ml
sudo /usr/sbin/cupsenable samsung2010ml
sudo /usr/bin/lpoptions -d samsung2010ml
auth-info-required=none copies=1 device-uri=usb://Samsung/ML-2010?serial=4621BKDPA24185W. finishings=3 job-hold-until=no-hold job-priority=50 job-sheets=none,none marker-change-time=0 number-up=1 printer-commands=AutoConfigure,Clean,PrintSelfTestPage printer-info=samsung2010ml printer-is-accepting-jobs=true printer-is-shared=true printer-location printer-make-and-model='Samsung ML-2010 Foomatic/gdi' printer-state=3 printer-state-change-time=1436890121 printer-state-reasons=none printer-type=8392708 printer-uri-supported=ipp://localhost:631/printers/samsung2010ml

sudo /usr/sbin/cupsctl --share-printers
```

Możemy zacząć drukować dokumenty.

``` bash
echo "Print this simle text" | /usr/bin/lpr
```

Jeśli nie mamy pliku wykonywalnego `/usr/bin/lpr` to musimy zainstalować pakiet `cups-bsd`.

## 400 Bad Request

Po udostępnieniu drukarki, próbując wejść na stronę drukarki poprzez FQDN dostajemy błąd `400 Bad Request`.

Prawdopodobnie oznacza to, że nie ustawiliśmy alternatywnych nazw serwera CUPS.
Do pliku `/etc/cups/cupsd.conf` dodajemy alias z swoją nazwą FQDN np. "print.morawskim.pl".

```
ServerAlias print.morawskim.pl
```
