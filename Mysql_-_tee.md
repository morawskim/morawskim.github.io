Mysql - tee
===========

Często analizując zadanie korzystam z konsolowego klienta mysql. Wywoływane zapytania wraz z wynikami kopiuję i umieszczam w odpowiedzi. Jednak duże zapytania SQL lub takie co zwracają duże ilości danych mogą przekroczyć bufor konsoli i utracimy część danych. W takim przypadku można użyć polecenia tee.

Polecenie tee, podobnie jak jego odpowiednik w systemie Linux zapisuje wyjście do wskazanego pliku.

``` sql
tee /tmp/mysql-query.sql
Logging to file '/tmp/mysql-query.sql'
```

Jeśli teraz wywołamy zapytanie

``` sql
SELECT NOW();
```

To zawartość naszego pliku /tmp/mysql-query.sql będzie następująca

```
MariaDB [(none)]> SELECT NOW();
+---------------------+
| NOW()               |
+---------------------+
| 2017-06-15 11:14:06 |
+---------------------+
1 row in set (0.00 sec)
```