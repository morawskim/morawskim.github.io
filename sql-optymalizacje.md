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

### Indeksy

Indeks klastrowany (Clustered Index)

* Określa fizyczny porządek wierszy w tabeli.

* Może istnieć tylko jeden taki indeks na tabelę – dane mogą być fizycznie uporządkowane tylko w jeden sposób.

* Umożliwia wydajne zapytania zakresowe i skanowanie w ustalonej kolejności.

* Poprawia efektywność operacji wejścia/wyjścia (I/O), ponieważ powiązane dane znajdują się blisko siebie na dysku.

* Służy jako baza odwołań dla indeksów nieklastrowanych.


Indeks nieklastrowany (Non-Clustered Index)

* Jest to oddzielna struktura, zawierająca kopię jednej lub kilku kolumn oraz wskaźniki do rzeczywistych wierszy w tabeli.

* Nie wpływa na fizyczny sposób przechowywania danych.

* Może istnieć wiele indeksów nieklastrowanych w jednej tabeli.

* Stosowany do optymalizacji filtrowania, łączeń (JOIN) oraz agregacji na kolumnach innych niż klucz główny.

* Wymaga dodatkowych odczytów, aby pobrać pełne wiersze – chyba że indeks „pokrywa” zapytanie (ang. covering index).

#### Indeksy w bazach danych – porównanie typów

##### B+ Tree

Zalety:

* Oferują przewidywalną wydajność operacji odczytu i zapisu.

* Doskonale nadają się do zapytań zakresowych i filtrowania po dokładnych wartościach.

* Umożliwiają szybkie przeszukiwanie danych po posortowanych kolumnach indeksowanych.

* Idealne do filtrowania po kluczu głównym, datach, paginacji wyników.

Wady:

* Słaba wydajność przy kolumnach o niskiej selektywności (np. is_active, status), gdzie indeks i tak wskazuje na dużą część tabeli – silnik może wybrać pełne skanowanie tabeli.

* Wydajność wstawiania zależy od rozkładu kluczy – sekwencyjne ID (np. AUTO_INCREMENT) sprawdzają się dobrze, ale losowe wartości mogą powodować fragmentację i spowolnienie.

Zastosowania:

* Standardowy wybór dla większości baz danych.

* Sprawdzają się w aplikacjach wymagających sortowania i zakresów.

##### Hash Index

Zalety:

* Bardzo szybkie wyszukiwanie dokładnych wartości – wystarczy obliczyć hash.

* Efektywne wstawianie i usuwanie – również bazują na operacjach haszujących.

* Wydajność wyszukiwania utrzymuje się na stałym poziomie nawet przy wzroście danych (zakładając równomierne rozłożenie hashy).

Wady:

* Brak wsparcia dla porządku i zapytań zakresowych – przy takich zapytaniach silnik nie może wykorzystać indeksu.

* Nie zachowuje naturalnego porządku danych.

Zastosowania:

* Indeksy dla tabel w pamięci RAM, gdzie opóźnienia muszą być minimalne.

* Tymczasowe struktury danych o znanym schemacie dostępu.

* Zapytania o wysokiej kardynalności, np. po tokenach sesji, kluczach API.

* Partycjonowanie haszowe – równomierne rozkładanie danych po węzłach.

##### Bitmap Index

Zalety:

* Świetnie sprawdza się przy kolumnach o niskiej kardynalności (np. płeć, status, region).

* Idealny gdzie dane są głównie statyczne i skoncentrowane na odczycie (read-heavy).

* Umożliwia efektywne filtrowanie po wielu kolumnach jednocześnie.

Wady:

* Słaba wydajność w środowiskach z częstymi zapisami (INSERT, UPDATE, DELETE).

* Nie nadaje się dla kolumn o wysokiej kardynalności (np. user_id, email).

Zastosowania:

* Hurtownie danych, platformy analityczne (OLAP).

* Złożone zapytania filtrujące oparte o wiele kolumn.

* Środowiska o dużym współczynniku odczytów i niskiej liczbie zapisów.
