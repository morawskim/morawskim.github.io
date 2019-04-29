MySQL - zmiana atrybutu DEFINER widoku
======================================

Podczas importu bazy danych z backupu widoki mogą mieć przypisane inne konto MySQL, które nie istnieje u nas. Taki widok będzie zwracał błąd.
``` sql
mysql> SELECT * FROM vNAME;
ERROR 1449 (HY000): The user specified as a definer ('XXXXX_prod'@'127.0.0.1') does not exist
```

Musimy zmodyfikować atrybut DEFINER widoku.
``` sql
mysql> ALTER DEFINER = 'UZYTKOWNIK'@'localhost' VIEW vNAME AS SELECT .......;
```

Aby pobrać definicję widoku, wywołujemy polecenie
``` sql
SHOW CREATE VIEW vNAME;
```

Jeśli widoków jest dużo możemy zmienić definera w pliku SQL z zrzutem bazy danych.

Jednak w przypadku bardzo dużych baz danych możemy spróbować zrobić dump definicji widoków.
Narzędzie `mysqldump` nie umożliwia zrobienia backupu tylko widoków. Możemy jednak skorzystać z poniższego polecenia:
``` bash
mysql -uroot -p INFORMATION_SCHEMA --skip-column-names -e "select table_name from tables where table_type = 'VIEW' and table_schema = 'BAZA_DANYCH'" | xargs mysqldump -u root -p BAZA_DANYCH > views.sql
```
