Resetowanie hasła roota MySQL
=============================

Najpierw zatrzymujemy serwer mysql.

``` bash
sudo systemctl stop mysql
```

Następnie wydajemy polecenie. Zostanie odpalony serwer MySQL, który umożliwi nam zalogowanie się na konto roota bez podawania hasła. Dodatkowo został zablokowany zdalny dostęp do serwera bd.

``` bash
sudo mysqld_safe --skip-grant-tables --skip-networking
```

W nowym oknie terminala logujemy się do serwera bd. Wybieramy bazę danych mysql.

``` bash
mysql -uroot mysql
```

Wykonujemy następujące polecenia SQL.

``` sql
update user set password=PASSWORD("newpassword") where User='root';
flush privileges;
```

Na serwerze może być wiele kont roota.

``` sql
select User, user.Host from user where User='root';
+------+-----------------+
| User | Host            |
+------+-----------------+
| root | 127.0.0.1       |
| root | ::1             |
| root | linux-nfuo.site |
| root | localhost       |
+------+-----------------+
```

Wychodzimy z klienta MySQL.

``` sql
exit
```

Bezpiecznie wyłączamy serwer MySQL, podając nowe hasło root'a.

``` bash
sudo mysqladmin -p shutdown
```

Uruchamiamy usługę MySQL.

``` bash
sudo systemctl start mysql
```