MySQL - strefa czasowa
======================

``` bash
mysql -e 'SELECT @@global.time_zone, @@session.time_zone;'
+--------------------+---------------------+
| @@global.time_zone | @@session.time_zone |
+--------------------+---------------------+
| SYSTEM             | SYSTEM              |
+--------------------+---------------------+
```

Wartość "SYSTEM" wskazuje, że strefa czasowa powinna być taka sama, jak strefa czasowa systemu.

<https://dev.mysql.com/doc/refman/5.5/en/time-zone-support.html>