# MySQL - general_log i slow_query_log

## Logowanie wszystkich wykonywanych poleceń (general_log)

### MySQL

Kiedy chcemy dowiedzieć się jakie zapytania wysyła aplikacja do serwera MySQL to musimy włączyć logowanie wszystkich zapytań. Jest to czynność bardzo prosta. Do pliku konfiguracyjnego MySQL należy dodać dwie dyrektywy w sekcji mysqld.

```
[mysqld]
general_log = 1
general_log_file=/var/log/mysql/query.log
```

Przykładowy wpis wygenerowany przez aplikację Zabbix.

```
...
                    8 Query     insert into history (itemid,clock,ns,value) values (23302,1458758542,93545272,0.008415),(23303,1458758543,94715914,0.008415),(23664,1458758544,95197922,92.025288),(23304,1458758544,95687563,0.000000),(23305,1458758545,96931234,2.725896),(23665,1458758545,97006224,96.682152),(23306,1458758546,97980324,4.156500),(23666,1458758546,98061195,92.025288)

...
```

### Docker

W definicji kontenera mysql ustawiamy/modyfikujemy klucz `command` jak poniżej, aby włączyć general_log.

```
mysql:
  image: mysql:5.6
  command: |
    --general_log=1
    --general_log_file=/var/log/mysql/query.log
```

Wywołując zapytanie SQL `SHOW GLOBAL VARIABLES LIKE '%general_log%';` upewniamy się czy MySQL będzie logował każde polecenie do pliku `/var/log/mysql/query.log`.

```
+------------------+--------------------------+
| Variable_name    | Value                    |
+------------------+--------------------------+
| general_log      | ON                       |
| general_log_file | /var/log/mysql/query.log |
+------------------+--------------------------+
```

Na kontenerze mysql wywołujemy polecenie `tailf /var/log/mysql/query.log`, aby monitorować zmiany w pliku.
Możemy także wykorzystać docker-compose `docker-compose exec mysql tailf /var/log/mysql/query.log`
Gdy jakieś zapytanie zostanie wykonane w pliku pojawi się wpis podobny do poniższego:

```
220729 16:48:06    13 Query     SHOW GLOBAL VARIABLES LIKE '%general_log%'
```

## Logowanie powolnych zapytań (slow_query_log)

W definicji kontenera mysql ustawiamy/modyfikujemy klucz `command` jak poniżej, aby włączyć slow_query_log.

```
mysql:
  image: mysql:5.6
  command: |
    --slow_query_log=1
    --long_query_time=1
    --slow_query_log_file=/var/log/mysql/slow.log
    --log_queries_not_using_indexes=0
  # ...
```

Logujemy się do bazy i wywołujemy zapytanie `show variables like '%slow%';`, aby potwierdzić że MySQL będzie logował wolne zapytania SQL do pliku `/var/log/mysql/slow.log`.

```
+---------------------------+-------------------------+
| Variable_name             | Value                   |
+---------------------------+-------------------------+
| log_slow_admin_statements | OFF                     |
| log_slow_slave_statements | OFF                     |
| slow_launch_time          | 2                       |
| slow_query_log            | ON                      |
| slow_query_log_file       | /var/log/mysql/slow.log |
+---------------------------+-------------------------+
```

Na kontenerze mysql wywołujemy polecenie `tailf /var/log/mysql/slow.log`, aby monitorować zmiany w pliku.
Możemy także wykorzystać docker-compose `docker-compose exec mysql tailf /var/log/mysql/slow.log`
Gdy jakieś zapytanie przekroczy oczekiwany czas wykonywania w naszym logu pojawi się wpis podobny do poniższego:

```
# Time: 220729 16:19:06
# User@Host: root[root] @ localhost []  Id:     1
# Query_time: 3.000156  Lock_time: 0.000000 Rows_sent: 1  Rows_examined: 0
use ssorder;
SET timestamp=1659111546;
SELECT SLEEP(3);
```
