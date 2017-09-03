Xterm-256color
==============

Większość terminali na Linuxie potrafi wyświetlić 256 kolorów. Wpier sprawdzamy typ terminala i ile kolorów potrafi obsłużyć.

``` bash
echo $TERM
xterm
```

``` bash
tput colors
8
```

Następnie wyszukujemy pliki konfiguracyjne terminala, które mają w nazwie "256". Jeśli nic nie znajdujemy, albo nie ma w nim xterm-256color musimy zainstalować jakiś pakiet. W moim przypadku byłby to pakiet terminfo-base.

``` bash
find /usr/share/terminfo/ -name '*256*'
/usr/share/terminfo/v/vte-256color
/usr/share/terminfo/x/xnuppc-256x96
/usr/share/terminfo/x/xnuppc+256x96
/usr/share/terminfo/x/xterm-256color
/usr/share/terminfo/x/xnuppc-256x96-m
/usr/share/terminfo/x/xterm+256color
/usr/share/terminfo/E/Eterm-256color
/usr/share/terminfo/n/nsterm-256color
/usr/share/terminfo/s/screen-256color-bce
/usr/share/terminfo/s/screen-256color-s
/usr/share/terminfo/s/screen-256color
/usr/share/terminfo/s/st-256color
/usr/share/terminfo/s/screen-256color-bce-s
/usr/share/terminfo/p/putty-256color
/usr/share/terminfo/k/konsole-256color
/usr/share/terminfo/m/mlterm-256color
/usr/share/terminfo/m/mrxvt-256color
```

Ustawiamy zmienną środowiskową.

``` bash
TERM='xterm-256color'
```

Sprawdzamy ilość obsługiwanych kolorów.

``` bash
tput colors
256
```

Na stronie <http://www.commandlinefu.com/commands/view/5879/show-numerical-values-for-each-of-the-256-colors-in-bash> możemy znaleźć proste skrypty bash do testowania kolorów.

``` bash
for i in {0..255}; do echo -e "\e[38;05;${i}m${i}"; done | column -c 80 -s ' '; echo -e "\e[m"
```

[Plik:bash256colors.png](/Plik:bash256colors.png "wikilink")