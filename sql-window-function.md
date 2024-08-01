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

## IN i dopasowanie wszystkich wartości listy

Korzystając z operator IN natrafimy na problem jak dopasować wszystkie wartości listy.
Istnieje kilka rozwiązań, a jednym z nich jest zastosowanie funkcji okna `COUNT(DISTINCT product_id) OVER (PARTITION BY company_id) unique_products`.
Następnie mając tak wyliczoną kolumnę, możemy po niej filtrować, ale nie możemy tego robić bezpośrednio.

[Inne rozwiązania](https://stackoverflow.com/questions/15977126/select-group-of-rows-that-match-all-items-in-a-list)
