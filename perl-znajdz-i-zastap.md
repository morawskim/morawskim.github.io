# perl - znajdź i zastąp

Często do znajdowania i zastępowania fraz używam programu sed. Niestety program sed nie obsługuje wyrażeń regularnych z języka perl. Język PHP posiada PCRE, który umożliwia korzystanie z składni wyrażeń regularnych perl.

Użycie perla do podstawienia jest proste. Wystarczy wywołać poniższe polecenie. Opcja `-i` mówi że perl będzie działać bezpośrednio na pliku (tworzy kopię zapasową, jeśli podano przyrostek). Podobnie jak to robi sed. Flaga `-p` tworzy pętle wyświetlania. Zaś `-e` umożliwia podanie skryptu perl jako parametr.

```
perl -i -pe 's/^([\w\-_]+):/$1: start-http-server/g' Makefile
```
