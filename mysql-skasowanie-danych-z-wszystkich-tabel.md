# mysql - skasowanie danych z wszystkich tabel

```
mysql -Nse 'show tables' DATABASE_NAME | while read table; do mysql -e "SET FOREIGN_KEY_CHECKS = 0; truncate table $table;" DATABASE_NAME; done
```

Jeśli nie mamy skonfigurowanego logowania do bazy danych w pliku `.my.cnf` to najpewniej musimy dodać parametry
`-u username` i `-p password` do opcji programu mysql.
