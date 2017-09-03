Vim - kolorowanie składni
=========================

[thumb](/Plik:Vim-no-set-syntax.png "wikilink") Vim ustawia kolorowanie składni bazując na rozszerzeniu pliku. W przypadku, kiedy edytujemy plik szablonu np. vhosta dla apache kolorowanie składni nie będzie działać.

Musimy wymusić kolorowanie składni, wywołując następujące polecenie:

```
:set syntax=apache
```

[thumb](/Plik:Vim-set-syntax.png "wikilink") Po tej operacji vim pokoloruje składnie pliku.

W przypadku systemu openSuSE, listę obsługiwanych typów plików można podejrzeć wywołując następujące polecenie:

``` bash
cat /usr/share/vim/vim74/filetype.vim | grep -E -o 'setf \w+' | sort | uniq
```