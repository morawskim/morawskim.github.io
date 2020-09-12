# Import danych z pliku CSV do bazy danych

Przy przenoszeniu danych między WooCommerce, a nowym systemem musiałem znormalizować jedno z pól metadanych. W panelu administracyjnym wygenerowałem raport w formacie CSV. Przez API pobrałem dane i dokonałem normalizacji wartości tego pola. Jednak zamiast przeglądać parę tysięcy wartości postanowiłem porównać wartość tego pola między systemami. Narzędzie `textql` pozwala mi zaimportować plik do bazy sqllite i wykonać zapytanie SQL na jej zawartości. Wywołałem polecenie `docker run --rm -it -v $(pwd):/tmp textql:2020-06-08 -header -sql 'SELECT col1, col2 ORDER BY col1 ASC' ./file.csv` i na stdout otrzymałem wynik zapytania. Zapytanie SQL może zawierać klauzulę `ORDER BY` czy też `GROUP BY`.

## csvkit

`csvkit` to zbiór narzędzi do konwersji i pracy z plikami CSV. Jedno z narzędzi `csvsql` umożliwia nam zaimportowanie pliku CSV do bazy danych. Zaletą tego narzędzia w porównaniu do `textql` jest obsługa innych niż `SQLite` baz danych.

```
docker run --rm -it --network host python:3.7 bash
pip install PyMySQL psycopg2 csvkit
csvsql --db 'mysql+pymysql://username:password@HOST:PORT/DB_NAME' --insert ./file.csv
```

Możemy także skorzystać z gotowego obrazu dockera `morawskim/csvsql-mysql:1.0.5`. W takim przypadku, aby zaimportować dane do bazy danych, która znajduje się w sieci dockera korzystamy z polecenia `docker run --rm -it --network=DOCKER_COMPOSE_NETWORK -v $PWD:/app morawskim/csvsql-mysql:1.0.5 --db 'mysql+pymysql://USERNAME:PASSWORD@DB_HOST:3306/DB_NAME' --insert /app/filename.csv`.

W pliku `docker-compose.yaml` możemy dodać definicję nowego kontenera.

```
csvkit:
    image: morawskim/csvsql-mysql:1.0.5
    volumes:
        - ./:/app
```

Wywołując polecenie `docker-compose run csvkit --db 'mysql+pymysql://<DB_USER>:<DB_PASSWORD>@<DB_HOST>:3306/<DB_NAME>' --insert /app/<CSV_FILE>` zaimportujemy plik CSV do bazy danych.
