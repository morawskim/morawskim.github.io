Tr - zastępowanie sekwencji powtórzonych znaków
===============================================

Polecenie tr umożliwia nam zastępowanie sekwencji powtórzonych znaków. W poniższym przykładzie zastępujemy powtórzone znaki spacji jednym wystąpieniem.

``` bash
echo 'slowa  odzielone   kilkoma znakami    spacji' | tr -s ' '
```