MySQL - zdalne logowanie
========================

Ze względów bezpieczeństwa domyślnie do bazy MySQL nie zalogujemy się z zdalnego hosta. Musimy zmodyfikować plik konfiguracyjny serwera - /etc/mysql/my.cnf. Odszukujemy w nim sekcji \[mysqld\].

```
#komentujemy linie jesli istnieje
#skip-networking
bind-address    = <podajemy_adres_ip>
```

Musimy mieć także konto użytkownika MySQL, które ma uprawnienie do zdalnego logowania. Jeśli takiego nie mamy musimy utworzyć ustawiając wartość kolumny Host na adres IP/domenowy z którego będzie nawiązywane połączenie.

``` sql
SELECT User, Host FROM mysql.user WHERE Host <> 'localhost';
```