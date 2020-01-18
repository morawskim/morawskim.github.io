# Postgres sequence

W projekcie korzystaliśmy z `Doctrine`, który generował strukturę tabeli i sekwencję.
Po jakimś czasie okazało się, że typ kolumny id to `int`, a sekwencja generowała liczby `bigint`.
Ta tabela przechowywała tylko przeliczone dane z ostatnich 7 dni, więc stare rekordy były cyklicznie kasowane.
Musiałem zmienić typ generowanych liczb przez sekwencję z `bigint` na `int`.

Wpierw pobieramy szczegóły sekwencji za pomocą zapytania SQL `SELECT * FROM pg_sequences WHERE sequencename  = '<nazwaSekwencji>';`

Dostaniemy wynik podobny do poniższego:

|schemaname  |sequencename  |sequenceowner  |data_type  |start_value  |min_value  |max_value  |increment_by  |cycle  |cache_size  |last_value|
|-|-|-|-|-|-|-|-|-|-|-|
|panel | <nazwaSekwencji>  |www  |bigint  |1  |1  |9223372036854775807  |1  |false  |1  |2147483651|

W wyniku widzimy że `data_type` to właśnie `bigint`, a także że ostatnio wygenerowana wartość to `2147483651`.
Typ `int` może przechowywać dane z zakresu `-2 147 483 648` do `2 147 483 647`.

Możemy zmodyfikować naszą sekwencję za pomocą polecenia `ALTER` - `ALTER SEQUENCE <nazwaSekwencji> AS integer RESTART WITH 1 CYCLE;`
Za pomocą tego polecenia zmieniamy typ sekwencji na `int` i włączamy resetowanie. W momencie osiągnięcia maksymalnej wartości sekwencja zacznie generowanie liczb od początku.

https://www.postgresqltutorial.com/postgresql-data-types/

https://www.postgresql.org/docs/10/sql-altersequence.html