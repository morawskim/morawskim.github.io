# Mysql - only_full_group_by

Jeśli w zapytaniu sql, korzystamy z klauzuli `GROUP BY` to w zależności od ustawień `sql_mode` będziemy musieli podać wszystkie kolumny z klauzuli `SELECT`.
``` sql
SELECT `id`, `pages` FROM `bibliography` WHERE `pages` LIKE 'pa%' GROUP BY `pages`;

ERROR 1055 (42000): Expression #1 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'toh.bibliography.id' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by
```

Dla MariaDB 10.0.31-MariaDB (opensuse 42.2) sql_mode wygląda tak jak poniżej:
``` sql
SELECT @@sql_mode;
+--------------------------------------------+
| @@sql_mode                                 |
+--------------------------------------------+
| STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION |
+--------------------------------------------+
1 row in set (0.00 sec)
```

Dla mysql 5.7.20-0ubuntu0.16.04.1 sql_mode wygląda tak jak poniżej:
```
select @@sql_mode;
+-------------------------------------------------------------------------------------------------------------------------------------------+
| @@sql_mode                                                                                                                                |
+-------------------------------------------------------------------------------------------------------------------------------------------+
| ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION |
+-------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)
```
