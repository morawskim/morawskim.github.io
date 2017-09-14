Vim - brak obsługi schowka w opensuse leap 42.3
=================================================

Po aktualizacji systemu do opensuse 42.3 zauważyłem, że w edytorze vim nie mogę skopiować tekstu do schowka. Coś takiego działało w opensuse 13.2.

Wywołałem polecenie
``` bash
vim --version | grep clipboard
-clipboard       +iconv           +path_extra      -toolbar
+eval            +mouse_dec       +startuptime     -xterm_clipboard
```

W opensuse 42.3 vim nie zaweira obsługi schowka.
Postanowiłem sprawdzić wynik tej komendy w opensuse 13.2.
``` bash
vim --version | grep clipboard
+clipboard       +iconv           +path_extra      -toolbar
+eval            +mouse_dec       +startuptime     +xterm_clipboard
```

Na liście dyskusyjnej i bugzilli opensuse znalazłem informacje na ten temat:
* https://lists.opensuse.org/opensuse-bugs/2016-08/msg01382.html
* https://bugzilla.opensuse.org/show_bug.cgi?id=853072
* https://lists.opensuse.org/opensuse-bugs/2016-07/msg00241.html
* https://bugzilla.opensuse.org/show_bug.cgi?id=987515

Ponieważ opensuse 42.3 bazuje na SLE nie zanosi się, aby domyślnie miał właczoną obsługę clipboard. Jednak zgodnie z komentarzem https://bugzilla.opensuse.org/show_bug.cgi?id=987515#c4 możemy obejść ten problem tworząc alias:
``` bash
alias vim="gvim -v"
```
Dzięki temu możemy kopiować dane z vim do schowka.
