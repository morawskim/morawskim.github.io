# SQL Optymalizacje

## COUNT i LIMIT

W bazie danych MongoDB możemy przestać zliczać dokumenty w kolekcji po przekroczeniu pewnego limitu.
Podobny efekt chciałem osiągnąć dla MySQL.
Do spełnienia tego wymogu potrzebujemy użyć funkcji COUNT i klauzula LIMIT - `SELECT COUNT(*) cnt FROM (SELECT DISTINCT id FROM table WHERE foo = 'bar' LIMIT 500) q`

Dodatkowo utworzyłem skrypt K6 do sprawdzenia wydajności zapytania z limitem i bez.
Wpierw musimy zbudować K6 z rozszerzeniem SQL i sterownikiem dla MySQL - `docker run --rm -it -u "$(id -u):$(id -g)" -v "${PWD}:/xk6" grafana/xk6 build --with github.com/grafana/xk6-sql@latest --with github.com/grafana/xk6-sql-driver-mysql`

Tworzymy nowy plik `test.js`, który zawiera skrypt K6.
```
import sql from "k6/x/sql";
import driver from "k6/x/sql/driver/mysql";
import { check } from 'k6';

// The second argument is a MySQL connection string, e.g.
// myuser:mypass@tcp(127.0.0.1:3306)/mydb
const db = sql.open(driver, __ENV.CONNECTION_STRING);

export function setup() {
  //db.exec(``);
}

export function teardown() {
  db.close();
}

export default function () {
  const limit = __ENV.LIMIT || 500;
  let rows = db.query(`SELECT COUNT(*) cnt FROM (SELECT DISTINCT id FROM table WHERE foo = 'bar' LIMIT ${limit}) q`);
  check(rows, {
    'is length 1': (r) => r.length === 1,
    `is count ${limit}`: (r) => r[0].cnt <= limit,
  });
}

```

Uruchamiamy test K6 poleceniem `CONNECTION_STRING='dbuser:dbpassword@tcp(1.1.2.2:3306)/dbname' LIMIT=500 ./k6 run -d 30s -i 50 test.js`

### Wymuszenie użycia indeksu

W większości przypadków optymalizator zapytań w systemach baz danych sam decyduje, czy i jaki indeks zastosować dla konkretnego zapytania. Jednak nie zawsze jego wybór jest optymalny – może się zdarzyć, że:

```
SELECT * FROM table USE INDEX (idx_customer_id) WHERE customer_id = 123
SELECT * FROM Table WITH(INDEX(Index_Name))
```
