Xdg - domyślny program do otwierania plików cachegrind
======================================================

Pliki tworzone przez ruby-prof dla raportu call_tree mają format 'profile.callgrind.out.\*' Nie mogłem ich otworzyć przez kliknięcie w programie kcachegrind. Postanowiłem sprawdzić jakie rozszerzenie musi miec plik, aby plik był otwierany domyślnie w kcachegrind.

Sprawdziłem jakie pliki są zawarte w pakiecie kcachegrind. Moją uwagę skupił plik kcachegrind.desktop

``` bash
rpm -ql kcachegrind
......
/usr/share/applications/kde4/kcachegrind.desktop
.....
```

Otworzyłem ten plik i zobaczyłem taki klucz. Zgodnie z specyfikacją (https://standards.freedesktop.org/desktop-entry-spec/latest/ar01s05.html) jest to lista obsługiwanych typów mime przez aplikację.

```
less /usr/share/applications/kde4/kcachegrind.desktop
...
MimeType=application/x-kcachegrind;
...
```

Postanowiłem wyszukać takiego mimetype w katalogu /usr/share/mime/ Program ag to ulepszona wersja grep'a.

``` bash
ag 'application/x-kcachegrind' /usr/share/mime/
/usr/share/mime/application/x-kcachegrind.xml
2:<mime-type ns="http://www.freedesktop.org/standards/shared-mime-info" type="application/x-kcachegrind">

/usr/share/mime/types
289:application/x-kcachegrind

/usr/share/mime/globs2
787:50:application/x-kcachegrind:cachegrind.out*
788:50:application/x-kcachegrind:cachegrind.out*
919:50:application/x-kcachegrind:callgrind.out*
920:50:application/x-kcachegrind:callgrind.out*

/usr/share/mime/globs
786:application/x-kcachegrind:cachegrind.out*
787:application/x-kcachegrind:cachegrind.out*
917:application/x-kcachegrind:callgrind.out*
918:application/x-kcachegrind:callgrind.out*

/usr/share/mime/packages/kde.xml
3042:  <mime-type type="application/x-kcachegrind">

/usr/share/mime/packages/kde5.xml
2887:  <mime-type type="application/x-kcachegrind">
```

Od razu na wyjściu zauważyłem format nazwy pliku. Po zmianie nazwy pliku zgodnie z szablonem callgrind.out\* mogłem go automatycznie otworzyć w KCachegrind.