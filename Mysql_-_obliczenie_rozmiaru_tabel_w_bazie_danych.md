Mysql - obliczenie rozmiaru tabel w bazie danych
================================================

Aby określić rozmiar tabel w bazie danych "database_name" i posortować je od największej do najmniejszej, wywołujemy następujące zapytanie:

``` sql
SELECT table_name AS "Table",
ROUND(((data_length + index_length) / 1024 / 1024), 2) AS "Size (MB)"
FROM information_schema.TABLES
WHERE table_schema = "database_name"
ORDER BY (data_length + index_length) DESC;
```

SQL pobrana z [<https://stackoverflow.com/a/14570029>](https://stackoverflow.com/a/14570029)