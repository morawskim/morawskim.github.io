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

### Zrzut tylko definicji tabeli

```
pg_dump -U postgres -t <schema.table> --schema-only <database>
```

### CSV i SELECT

Jednemu z klientów musiałem dostarczyć plik CSV z wynikiem zapytania SQL. Osoba ta chciała otworzyć taki plik w Excelu i przeanalizować dane. Utworzyłem tunel SSH do podłączenia się z zdalną bazą. Następnie korzystając z lokalnie zainstalowanego `psql` podłączyłem się do bazy - `psql -h 127.0.0.1 -p 5433 -U <username> -d <databse>`. Następnie wywołałem polecenie `\copy (SELECT t.* FROM table WHERE seen BETWEEN '2019-10-20' AND '2020-02-20') To 'file.csv' With CSV`. W pliku `file.csv` znajdował się wynik zapytania w formacie CSV.

## MySQL

### backup całej bazy

Zamiast podawać hasło do konta jako parametr polecenia, możemy przekazać hasło w zmiennej środowiskowej `MYSQL_PWD`.

`MYSQL_PWD='<password>' mysqldump --databases <database> -u<user>`
