Określenie kiedy proces został uruchomiony
==========================================

Odpalamy nasz program np. vim. Sprawdzamy identyfikator procesu

``` bash
pgrep vim
```

Mając identyfikator procesu sprawdzamy, kiedy ostatni raz był modyfikowany katalog /proc/<PID>

``` bash
stat  /proc/23006
  Plik: „/proc/23006”
  rozmiar: 0            bloków: 0          bloki I/O: 1024   katalog
Urządzenie: 3h/3d       inody: 523433      dowiązań: 9
Dostęp: (0555/dr-xr-xr-x)  Uid: ( 1000/  marcin)   Gid: ( 1000/  marcin)
Dostęp:      2017-01-02 14:28:43.095352525 +0100
Modyfikacja: 2017-01-02 14:28:43.095352525 +0100
Zmiana:      2017-01-02 14:28:43.095352525 +0100
Utworzenie:  -
```