Konwersja plików man do txt
===========================

Niektóre pliki man chcielibyśmy wydrukować. Niestety "surowe" dokumenty man zawierają znaczniki formatujące. Poniższe polecenie konwertuje stronę podręcznika man do pliku txt.

``` bash
man systemctl | col -b > systemctl.txt
```