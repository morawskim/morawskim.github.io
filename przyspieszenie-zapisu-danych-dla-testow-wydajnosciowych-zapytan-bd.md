# Przyśpieszenie zapisu danych dla testów wydajnościowych zapytań bd

W jednym z projektów zastanawialiśmy się nad wyborem bazy danych do przechowywania danych JSON.
Mieliśmy trzech kandydatów `MySQL`, `PostgreSQL` i `MongoDB`. Jednak nie wiedzieliśmy, jaka jest różnica w wydajności pomiędzy tymi bazami.

Utworzyłem benchmark (https://github.com/morawskim/php-examples/tree/master/benchmark-json-db) dla porównania szybkości zapytań w przypadku przechowywania 1 mln rekordów.

Do generowania danych testowych wykorzystałem bibliotekę `fzaninotto/faker` (https://github.com/fzaninotto/Faker).
Za jej pomocą generowałem strukturę `Person` i zapisywałem ją do bazy danych.

Jak się okazało baza PostgreSQL wykonywała zapytanie na kolumnie JSON dwa razy szybciej niż MySQL.

Zapisanie 1 mln rekordów w bazie `PostgreSQL` zajęło mi prawie 60minut. Postanowiłem zoptymalizować proces zapisywania danych. Bazy danych były tworzone w kontenerach docker, więc mogłem łatwo zmodyfikować ustawienia baz danych. Najwolniejsze są operacje IO, więc wyłączyłem synchronizowanie buforów z dyskiem.


## PostgreSQL
Dla bazy PostgreSQL przy konfiguracji kontenera dodałem `command: ["postgres", "-c", "fsync=off"]`.

Z włączoną synchronizacją dodanie 10K rekordów zajmowało 30s.
```
root@98af2e1556e4:/app# time php ./seed.php
 10000/10000 [============================] 100%
real    0m30.382s
user    0m4.702s
sys     0m1.056s
```

Po wyłączeniu synchronizacji dodanie 10K rekordów zajmowało tylko 7s.
```
root@98af2e1556e4:/app# time php ./seed.php
 10000/10000 [============================] 100%
real    0m7.251s
user    0m3.789s
sys     0m0.739s
```

## MySQL
Dla bazy MySQL przy konfiguracji kontenera dodałem `command: ['mysqld',  '--innodb-flush-method=nosync']`.

Z włączoną synchronizacją dodanie 10K rekordów zajmowało ponad 100s.
```
root@98af2e1556e4:/app# time php ./seed.php
 10000/10000 [============================] 100%
real    1m43.674s
user    0m4.622s
sys     0m0.625s
```

Po wyłączeniu synchronizacji dodanie 10K rekordów zajmowało niecałe 7s.
```
root@98af2e1556e4:/app# time php ./seed.php
 10000/10000 [============================] 100%
real    0m6.464s
user    0m3.545s
sys     0m0.390s
```

W przypadku bazy mongodb dodanie 10K bez żadnej optymalizacji trwało 3s.
```
root@7a1718b16bd2:/app# time php ./seed.php
 10000/10000 [============================] 100%
real    0m3.044s
user    0m2.095s
sys     0m0.166s
```
