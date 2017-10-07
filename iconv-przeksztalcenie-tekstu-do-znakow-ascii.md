iconv - przekształcenie tekstu do znaków ASCII
==============================================

``` bash
iconv -f'UTF8//' -t 'ASCII//TRANSLIT//IGNORE' <(echo "Ąąśółqwe $!#8545 ^X323 ółązźćółÜü")
Aasolqwe 11379#8545 ^X323 olazzcolUu

```

UWAGA. Wymagane jest ustawienie odpowiedniej lokalizacji (utf8) inaczej polecenie może nie działać
``` bash
locale
LANG=pl_PL.UTF-8
LC_CTYPE="pl_PL.UTF-8"
LC_NUMERIC="pl_PL.UTF-8"
LC_TIME="pl_PL.UTF-8"
LC_COLLATE="pl_PL.UTF-8"
LC_MONETARY="pl_PL.UTF-8"
LC_MESSAGES="pl_PL.UTF-8"
LC_PAPER="pl_PL.UTF-8"
LC_NAME="pl_PL.UTF-8"
LC_ADDRESS="pl_PL.UTF-8"
LC_TELEPHONE="pl_PL.UTF-8"
LC_MEASUREMENT="pl_PL.UTF-8"
LC_IDENTIFICATION="pl_PL.UTF-8"
LC_ALL=
```

