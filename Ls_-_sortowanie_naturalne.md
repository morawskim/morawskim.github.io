Ls - sortowanie naturalne
=========================

Domyślnie ls sortuje pliki po nazwie. Nie używa jednak algorytmu naturalnego sortowania. Możemy więc otrzymać wynik podobny do poniższego.

``` bash
ls -la
razem 404
drwx------    2 marcin marcin   4096 05-20 10:59 .
drwxrwxrwt 1769 root   root   405504 05-20 10:59 ..
-rw-r--r--    1 marcin marcin      0 05-20 10:59 1
-rw-r--r--    1 marcin marcin      0 05-20 10:59 10
-rw-r--r--    1 marcin marcin      0 05-20 10:59 11
-rw-r--r--    1 marcin marcin      0 05-20 10:59 12
-rw-r--r--    1 marcin marcin      0 05-20 10:59 13
-rw-r--r--    1 marcin marcin      0 05-20 10:59 14
-rw-r--r--    1 marcin marcin      0 05-20 10:59 15
-rw-r--r--    1 marcin marcin      0 05-20 10:59 16
-rw-r--r--    1 marcin marcin      0 05-20 10:59 17
-rw-r--r--    1 marcin marcin      0 05-20 10:59 18
-rw-r--r--    1 marcin marcin      0 05-20 10:59 19
-rw-r--r--    1 marcin marcin      0 05-20 10:59 2
-rw-r--r--    1 marcin marcin      0 05-20 10:59 20
-rw-r--r--    1 marcin marcin      0 05-20 10:59 3
-rw-r--r--    1 marcin marcin      0 05-20 10:59 4
-rw-r--r--    1 marcin marcin      0 05-20 10:59 5
-rw-r--r--    1 marcin marcin      0 05-20 10:59 6
-rw-r--r--    1 marcin marcin      0 05-20 10:59 7
-rw-r--r--    1 marcin marcin      0 05-20 10:59 8
-rw-r--r--    1 marcin marcin      0 05-20 10:59 9
```

Aby poprawnie sortować pliki zawierające cyfry trzeba włączyć sortowanie naturalne.

```
-v     natural sort of (version) numbers within text
```

Wtedy otrzymamy poprawnie posortowane pliki.

``` bash
ls -lav
razem 404
drwx------    2 marcin marcin   4096 05-20 10:59 .
drwxrwxrwt 1769 root   root   405504 05-20 10:59 ..
-rw-r--r--    1 marcin marcin      0 05-20 10:59 1
-rw-r--r--    1 marcin marcin      0 05-20 10:59 2
-rw-r--r--    1 marcin marcin      0 05-20 10:59 3
-rw-r--r--    1 marcin marcin      0 05-20 10:59 4
-rw-r--r--    1 marcin marcin      0 05-20 10:59 5
-rw-r--r--    1 marcin marcin      0 05-20 10:59 6
-rw-r--r--    1 marcin marcin      0 05-20 10:59 7
-rw-r--r--    1 marcin marcin      0 05-20 10:59 8
-rw-r--r--    1 marcin marcin      0 05-20 10:59 9
-rw-r--r--    1 marcin marcin      0 05-20 10:59 10
-rw-r--r--    1 marcin marcin      0 05-20 10:59 11
-rw-r--r--    1 marcin marcin      0 05-20 10:59 12
-rw-r--r--    1 marcin marcin      0 05-20 10:59 13
-rw-r--r--    1 marcin marcin      0 05-20 10:59 14
-rw-r--r--    1 marcin marcin      0 05-20 10:59 15
-rw-r--r--    1 marcin marcin      0 05-20 10:59 16
-rw-r--r--    1 marcin marcin      0 05-20 10:59 17
-rw-r--r--    1 marcin marcin      0 05-20 10:59 18
-rw-r--r--    1 marcin marcin      0 05-20 10:59 19
-rw-r--r--    1 marcin marcin      0 05-20 10:59 20
```