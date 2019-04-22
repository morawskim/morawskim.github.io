# mysql - ERROR 2006 (HY000): MySQL server has gone away

Podczas importu kopii bazy, klient mysql może zwrócić błąd `ERROR 2006 (HY000): MySQL server has gone away`.
Najczęściej jest to spowodowane bardzo dużą instrukcją INSERT.
Aby pozbyć się błędu musi zwiększyć wartość parametru `max_allowed_packet`.

Możemy to zrobić w konfiguracji serwera DB `my.cnf` - sekcja `mysqld`.
```
[mysqld]
max_allowed_packet=64M
```

Aktualną wartość możemy pobrać za pomocą jednego z poniższych zapytań SQL.
```
SELECT @@max_allowed_packet;
-- lub
SHOW VARIABLES LIKE 'max_allowed_packet';
```

Możemy także ustawić wartość tego parametru (1GB) do następnego restartu:
`SET GLOBAL max_allowed_packet=1073741824;`

Więcej informacji:

https://dev.mysql.com/doc/refman/5.5/en/packet-too-large.html
https://dev.mysql.com/doc/refman/5.5/en/server-system-variables.html#sysvar_max_allowed_packet
