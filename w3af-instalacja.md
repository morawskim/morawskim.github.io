# w3af - instalacja

W systemie openSuSE 15.0 chciałem zainstalować w3af.
Sklonowałem repozytorium git `https://github.com/andresriancho/w3af.git`.

Uruchomiłem `./w3af_console` i otrzymałem listę pakietów pythona do instalacji.

```
sudo pip install pyClamd==0.4.0 PyGithub==1.21.0 GitPython==2.1.3 pybloomfiltermmap==0.3.14 phply==0.9.1 nltk==3.0.1 tblib==0.2.0 pdfminer==20140328 pyOpenSSL==18.0.0 lxml==3.4.4 scapy==2.4.0 guess-language==0.2 cluster==1.1.1b3 msgpack==0.5.6 python-ntlm==1.0.1 halberd==0.2.4 darts.util.lru==0.5 vulndb==0.1.1 markdown==2.6.1 psutil==5.4.8 ds-store==1.1.2 termcolor==1.1.0 mitmproxy==0.13 ruamel.ordereddict==0.4.8 Flask==0.10.1 tldextract==1.7.2 pebble==4.3.8 acora==2.1 esmre==0.3.1 diff-match-patch==20121119 bravado-core==5.0.2 lz4==1.1.0 vulners==1.3.0 ipaddresses==0.0.2
```

Dodatkowo w3af wymaga pakietu npm retire.

Zależności postanowiłem instalować w izolowanym środowisku. Zamiast globalnie w systemie.
Utworzyłem więc izolowane środowisko pythona poleceniem `virtualenv-2.7 --system-site-packages .`

Aktywowałem te środowisko wywołując polecenie `source ./bin/active`.
Wywołałem polecenie do instalacji pakietów pythona. Tylko, że bez sudo.

```
pip install pyClamd==0.4.0 PyGithub==1.21.0 GitPython==2.1.3 pybloomfiltermmap==0.3.14 phply==0.9.1 nltk==3.0.1 tblib==0.2.0 pdfminer==20140328 pyOpenSSL==18.0.0 lxml==3.4.4 scapy==2.4.0 guess-language==0.2 cluster==1.1.1b3 msgpack==0.5.6 python-ntlm==1.0.1 halberd==0.2.4 darts.util.lru==0.5 vulndb==0.1.1 markdown==2.6.1 psutil==5.4.8 ds-store==1.1.2 termcolor==1.1.0 mitmproxy==0.13 ruamel.ordereddict==0.4.8 Flask==0.10.1 tldextract==1.7.2 pebble==4.3.8 acora==2.1 esmre==0.3.1 diff-match-patch==20121119 bravado-core==5.0.2 lz4==1.1.0 vulners==1.3.0 ipaddresses==0.0.2
```

Pojawił się błąd z instalacją, niektórych pakietów pythona.
Zainstalowałem przez zyppera dodatkowe pakiety devel `sudo zypper install libxslt-devel libxml2-devel`

Ciągle jednak był problem z `pip install pybloomfiltermmap==0.3.14`.
Otrzymywałem błąd:

```
gcc: error trying to exec 'cc1plus': execvp: Nie ma takiego pliku ani katalogu
error: command 'gcc' failed with exit status 1
```

Z pomocą google doszedłem do wniosku, że muszę zainstalować inny kompilator c++.
Wywołałem, więc polecenie `sudo zypper install gcc-c++` i wybrałem jedno z rozwiązań konfliktu.

Po tym wszystkie pakiety pythona były już zainstalowane.


Zainstalowałem pakiet npm poleceniem `npm install retire`.
Teraz mogłem już uruchomić `w3af_console`. Musiałem jednak ustawić zmienną środowiskową `PATH`, aby w3af widział polecenie `retire` - `PATH="./node_modules/.bin/:$PATH" ./w3af_console`

Niestety w openSUSE 15.0 nie ma już biblioteki gtkwebkit i dlatego nie można uruchomić GUI w3af.
Z tego też powodu, podczas tworzenia izolowanego środowiska pythona, nie musimy korzystać z flagi `--system-site-packages`.
