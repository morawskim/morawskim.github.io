MySQL - query log
=================

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

## Docker

Gdy korzystamy z obrazu `mysql` w kontenerze Dockera, możemy się do niego zalogować - `docker-compose exec mysql bash`, a następnie podłączyć się do bazy danych `mysql -uroot -p`. W konsoli mysql wywyołujemy polecenie SQL - `SET GLOBAL general_log = 'ON';`. A następnie wykonujemy polecenie `SHOW GLOBAL VARIABLES LIKE 'general_log_file';` aby wyświetlić plik do którego mysql loguje zapytania. W moim przypadku jest to `/var/lib/mysql/a2a1ddee2187.log`.
Następnie możemy wyjść z powłoki mysql i zacząć obserwować plik z logiem `tail -f /var/lib/mysql/a2a1ddee2187.log`. Zapytania SQL będą się pojawiać.

W przypadku problemów z logowaniem warto podejrzeć wartości niektórych zmiennych:

```
SHOW GLOBAL VARIABLES LIKE 'general_log'
SHOW GLOBAL VARIABLES LIKE 'log_output'
SHOW GLOBAL VARIABLES LIKE 'general_log_file'
```

Żeby wyłączyć logowanie zapytań SQL po ponownym podłączeniu do konsoli mysql wywołujemy polecenie `SET GLOBAL general_log = 'OFF';`.
