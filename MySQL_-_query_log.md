MySQL - query log
=================

Kiedy chcemy dowiedzieć się jakie zapytania wysyła aplikacja do serwera MySQL to musimy włączyć logowanie wszystkich zapytań. Jest to czynność bardzo prosta. Do pliku konfiguracyjnego MySQL należy dodać dwie dyrektywy w sekcji mysqld.

``` ini
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