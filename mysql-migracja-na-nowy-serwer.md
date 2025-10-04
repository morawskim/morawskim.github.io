# MySQL – migracja na nowy serwer

Wydajność dotychczasowego środowiska testowego okazała się niewystarczająca do obsługi rosnącej liczby instancji.
Konieczna była migracja bazy danych MySQL na nowy, większy serwer.

MySQL mieliśmy zainstalowanego z dedykowanego repozytorium RPM.
Na nowym serwerze zainstalowałem więc dokładnie tę samą wersję MySQL 8.0+, aby uniknąć problemów z kompatybilnością.

W przypadku dystrybucji korzystających z pakietów RPM polecenie `rpm -V PAKIET` pozwala sprawdzić, które pliki zostały zmodyfikowane.
Dzięki temu można łatwo zidentyfikować zmiany w konfiguracji i upewnić się, że zostaną przeniesione na nowy serwer.

Potwierdzamy lokalizację katalogu z danymi: `SELECT @@datadir;`

Na obu serwerach zatrzymujemy proces mysqld: `systemctl stop mysql`.

Następnie sprawdziłem, czy usługa została poprawnie zatrzymana: `systemctl status mysql`.

Na nowym serwerze tworzymy katalog dla danych "starego mysql" - `mkdir /var/lib/mysql-old`.

Ze starego serwera uruchamiamy transfer danych za pomocą rsync: `rsync -chavzP --stats  /var/lib/mysql/ username@IP_OR_DOMAIN_NAME:/var/lib/mysql-old/`.

Po skopiowaniu danych ustawiamy właściciela (na nowym serwerze) `chown -R mysql:mysql /var/lib/mysql-old`.

Aktualny katalog z danymi zachowujemy jako kopię zapasową `mv /var/lib/mysql /var/lib/mysql-orig`.

Nowo skopiowane dane przenosimy w miejsce oryginalnego katalogu: `mv /var/lib/mysql-old /var/lib/mysql`.

Uruchamiamy usługę MySQL na nowym serwerze:  `systemctl start mysql`.

W moim przypadku baza danych wystartowała bez problemów, a dane zostały poprawnie przeniesione.

Przykład zmiany konfiguracji mysqld:

```
[mysqld]
disable_log_bin

# memory
innodb_buffer_pool_size=80G

# slow log
slow-query-log=1
slow-query-log-file=/var/lib/mysql/mysql-slow.log
long_query_time=10
# ....
```
