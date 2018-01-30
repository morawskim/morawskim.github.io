Less - przydatne argumenty
==========================

### Podświetlanie frazy apache (obsługa kolorów).

``` bash
ps -ef | grep -i apache --color=always | less -R
```

### Numerowanie linii

``` bash
ps -ef | grep -i apache --color=always | less -N
```

### Ignorowanie wielkości liter podczas wyszukiwania.

``` bash
less -I
```

### Nie łamanie linii

``` bash
less -S
```

### Tmux i czyszczenie ekranu przez less
Wyłącza wysyłanie sekwencji inicjalizacji i deinicjalizacji terminala  z  termcap.
Jest  to  czasami pożądane, jeżeli łańcuch deinicjalizacyjny  robi  coś  niepotrzebnego,
jak   czyszczenie ekranu.

```
# w panelu tmux
less -X /path/to/file
```