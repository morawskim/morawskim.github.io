Lprm - czyszczenie kolejki wydruku
==================================

Wyświetlamy zadania w kolejce wydruku.

``` bash
lpq
samsung2010ml is ready and printing
Rank    Owner   Job     File(s)                         Total Size
active  (null)  6       untitled                        9216 bytes
1st     (null)  7       untitled                        9216 bytes
2nd     (null)  8       untitled                        9216 bytes
3rd     (null)  9       untitled                        9216 bytes
4th     (null)  10      untitled                        9216 bytes
5th     (null)  11      untitled                        9216 bytes
6th     (null)  12      untitled                        9216 bytes
```

Kasujemy zadania 6, 7 i 8.

``` bash
sudo lprm 6 7 8
```

Tak prezentuje się kolejka po skasowaniu wybranych zadań.

``` bash
lpq
samsung2010ml is ready and printing
Rank    Owner   Job     File(s)                         Total Size
active  (null)  9       untitled                        9216 bytes
1st     (null)  10      untitled                        9216 bytes
2nd     (null)  11      untitled                        9216 bytes
3rd     (null)  12      untitled                        9216 bytes
```

Kasujemy wszystkie pozostałe zadania.

``` bash
sudo lprm -
```

Kolejka jest pusta.

``` bash
lpq
samsung2010ml is ready
no entries
```