Docker - własny bazowy obraz
============================

Tworzymy katalog tymczasowy i przechodzimy do niego. Ja korzystam z aliasu cdtmp.

``` bash
cdtmp='cd $(mktemp -d $XDG_RUNTIME_DIR/cdtmp-XXXXXX)'
```

Instalujemy minimalną wersję systemu openSUSE

``` bash
sudo zypper --root `pwd` --plus-repo http://download.opensuse.org/distribution/leap/42.3/repo/oss/ --gpg-auto-import-keys \
    --non-interactive install --no-recommends patterns-openSUSE-minimal_base
```

Dodajemy podstawowe repozytorium

``` bash
sudo zypper --root `pwd` ar -f http://download.opensuse.org/distribution/leap/42.3/repo/oss/ openSUSE-Leap-42.3-Oss
```

Dodajmy plik do katalogu ./root/

``` bash
sudo vim ./root/foo
```

Przechodzimy jeden katalog w gore i tworzymy plik tar naszego obrazu

``` bash
cd ..
sudo tar -C ./KATALOG_GDZIE_INSTALOWALISMY_PAKIETY/ -cf openSUSE-42.3.tar .
```

Dodajemy obraz do docker'a

``` bash
docker import openSUSE-42.3.tar mmo/opensuse-42.3-test
4cd7d9bea6943c1958084fe4a77786b14b3e93fe9434d5a74ad274616f6cc63e
```

Sprawdzamy czy nowo dodany obraz jest dostępny

``` bash
docker images | grep mmo
mmo/opensuse-42.3-test             latest              4cd7d9bea694        32 seconds ago      178.6 MB
```

Uruchamiamy kontener z naszego utworzonego obrazu

``` bash
docker run -it --rm mmo/opensuse-42.3-test bash
2f1784487d1c:/ #
```

Wyświetlamy na kontenerze zawartość naszego dodanego pliku

``` bash
a1c7ffee6a17:/ # cat /root/foo
Hello!
```