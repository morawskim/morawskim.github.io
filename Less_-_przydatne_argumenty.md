Less - przydatne argumenty
==========================

Podświetlanie frazy apache (obsługa kolorów).

``` bash
ps -ef | grep -i apache --color=always | less -R
```

Numerowanie linii

``` bash
ps -ef | grep -i apache --color=always | less -N
```

Ignorowanie wielkości liter podczas wyszukiwania.

``` bash
less -I
```

Nie łamanie linii

``` bash
less -S
```