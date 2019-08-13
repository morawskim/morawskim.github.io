# Bazy danych - backup i restore

## postgres

### backup pojedyńczej tabeli

```
pg_dump --host 127.0.0.1 --port 5432 --username www --format plain  --verbose --file poi.backup --table panel.poi dbname
```

### przywrócenie tekstowego backupu

```
psql -h 127.0.0.1 -p 5432 -U postgres -d dbname -fpoi.backup
```

## MySQL

### backup całej bazy

Zamiast podawać hasło do konta jako parametr polecenia, możemy przekazać hasło w zmiennej środowiskowej `MYSQL_PWD`.

`MYSQL_PWD='<password>' mysqldump --databases <database> -u<user>`
