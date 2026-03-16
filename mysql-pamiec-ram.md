# MySQL - pamięć RAM

Uruchomienie pustej bazy danych MySQL 8.4 w kontenerze z domyślnymi ustawieniami (przykładowy docker-compose poniżej) zajmowało, według polecenia `docker compose stats`, około 500 MiB RAM.
Jak na pustą bazę danych, która nie zawiera żadnych rekordów, jest to dużo.

```
services:
  db:
    image: mysql:8.4
    environment:
        MYSQL_DATABASE: mydb
        MYSQL_USER: mydb
        MYSQL_ROOT_PASSWORD: secret
        MYSQL_PASSWORD: mydb
    ports:
      - 3306:3306
```

Po ustawieniu poniższych parametrów:

```
services:
  db:
    #...
    command: >
      --innodb-buffer-pool-size=32M
      --innodb-buffer-pool-chunk-size=32M
      --key-buffer-size=1M
      --performance-schema=OFF
```

udało mi się zmniejszyć zużycie pamięci RAM do około 220 MiB.

[MySQL Memory Calculator](https://www.mysqlcalculator.com/)

### innodb_buffer_pool_size

Uruchamiając bazę danych MySQL, nie możemy dowolnie ustawić zmiennej
`innodb_buffer_pool_size`.
Wartość tego parametru musi być wielokrotnością `innodb_buffer_pool_chunk_size`.
Jeżeli tak nie jest, wartość `innodb_buffer_pool_size` zostanie zaokrąglona w górę do najbliższej wielokrotności `innodb_buffer_pool_chunk_size`.


Aktualne wartości `innodb_buffer_pool_size` oraz
`innodb_buffer_pool_chunk_size` możemy wyświetlić zapytaniem SQL:

```
SELECT   @@innodb_buffer_pool_size / 1024 / 1024 AS buffer_pool_mb, @@innodb_buffer_pool_chunk_size / 1024/ 1024 as chunk_size_mb;
```

Możemy także wyświetlić pozostałe zmienne InnoDB: `SHOW VARIABLES LIKE 'innodb_buffer_pool%';`

Na zużycie pamięci mogą wpływać również m.in. poniższe zmienne:

```
SHOW VARIABLES WHERE Variable_name IN (
  'innodb_buffer_pool_size',
  'max_connections',
  'tmp_table_size',
  'sort_buffer_size',
  'performance_schema'
);

```

### Monitorowanie zużycia pamięci

Aktualne zużycie pamięci można sprawdzić w widoku `sys.x$memory_global_by_current_bytes`

```
SELECT SUBSTRING_INDEX(event_name,'/',2) AS code_area,
  FORMAT_BYTES(SUM(current_alloc)) AS current_alloc
FROM sys.x$memory_global_by_current_bytes
GROUP BY SUBSTRING_INDEX(event_name,'/',2)
ORDER BY SUM(current_alloc) DESC;

+---------------------------+---------------+
| code_area                 | current_alloc |
+---------------------------+---------------+
| memory/innodb             | 63.60 GiB     |
| memory/performance_schema | 276.55 MiB    |
| memory/sql                | 167.37 MiB    |
| memory/temptable          | 42.00 MiB     |
| memory/memory             | 5.95 MiB      |
| memory/mysys              | 5.07 MiB      |
| memory/mysqld_openssl     | 534.43 KiB    |
| memory/mysqlx             | 3.25 KiB      |
| memory/component_sys_vars | 1.25 KiB      |
| memory/myisam             |  728 bytes    |
| memory/csv                |  120 bytes    |
| memory/blackhole          |  120 bytes    |
| memory/vio                |   80 bytes    |
+---------------------------+---------------+
```

[Monitoring MySQL Memory Usage](https://dev.mysql.com/doc/refman/8.4/en/monitor-mysql-memory-use.html)

### Binlogi

Jeśli nie potrzebujemy długiej retencji binlogów, możemy ustawić zmienną
`binlog_expire_logs_seconds` na mniejszą wartość, np. 12 godzin.
Po wprowadzeniu zmian możemy to sprawdzić poleceniem: `SHOW VARIABLES LIKE 'binlog_expire%';`
