# MySQL - 1114 The table 'refresh_tokens' is full

Baza danych MySQL umożliwia nam przechowywanie danych w pamięci RAM, [jednak ma także sporo ograniczeń.](https://dev.mysql.com/doc/refman/8.0/en/memory-storage-engine.html)

W jednym z projektów pojawił się błąd podczas testów wydajnościowych `SQLSTATE[HY000]: General error: 1114 The table 'refresh_tokens' is full"`. Jak się okazało domyślnie MySQL umożliwia przechowywanie w tabeli MEMORY tylko 16M danych.
Możemy to potwierdzić wywołując zapytanie SQL - `SELECT @@max_heap_table_size, @@tmp_table_size;`.
Dlatego mając tabele przechowywaną w MEMORY warto zoptymalizować jej schemat - nie korzystać z kodowania `utf8mb4`. Możemy także zwiększyć ten limity tabeli. W przypadku obrazu dockera:
```
mysql:
    image: mysql:5.7
    # ...
    command: --tmp_table_size=32M --max_heap_table_size=32M

```

Możemy także skonfigurować w nowym pliku (z rozszerzeniem `cnf`) umieszczonym w katalogu `/etc/mysql/conf.d/`
```
[mysqld]
tmp_table_size=32M
max_heap_table_size=32M
```
