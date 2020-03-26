# SQL - window function

W ramach projektu musiałem pobrać liczbę wizyt w sklepach na dzień per miasto i posortować wynik po miastach z największą sumaryczną liczbą wizyt. Do rozwiązania tego problemu skorzystałem z funkcji okna `SUM`.

W zapytaniu poniżej pobieram miasto, liczbę wizyt, datę, a także łączną liczbę wizyt w danym mieście (`SUM(a.cnt) OVER (PARTITION BY a.city) totalByCity`). W tym przykładzie korzystam także z CTE do pobrania danych.

``` sql
SELECT a.city, a.cnt, a.seen, SUM(a.cnt) OVER (PARTITION BY a.city) totalByCity
 FROM (
    SELECT city, SUM(cnt)::INTEGER cnt, seen FROM DATA_CTE
    INNER JOIN poi p ON p.id = DATA_CTE.poi_id
    WHERE p.city IS NOT NULL
    GROUP BY city, seen
    ORDER BY seen
) a
ORDER BY totalByCity DESC, a.seen
```
