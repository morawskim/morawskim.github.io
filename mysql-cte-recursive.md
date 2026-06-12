# MySQL CTE RECURSIVE

`WITH RECURSIVE` służy do tworzenia rekurencyjnych zapytań SQL.

Składa się z dwóch części:

* initial
    - pierwsze zapytanie
    - tworzy pierwszy rekord/punkt startowy
* drugie zapytanie
    * odwołuje się do samego CTE
    * na podstawie poprzedniego wyniku tworzy kolejny rekord,
    * wykonuje się tak długo, aż warunek `WHERE` przestanie być spełniony

W moim przypadku wykorzystałem `WITH RECURSIVE` do generowania zakresów dat (tworzenie każdego dnia pomiędzy dwiema datami).

```
WITH RECURSIVE dates AS (
    SELECT '2026-01-01' as d
    UNION ALL
    SELECT d + INTERVAL 1 DAY FROM dates WHERE d < '2026-01-31'
)
SELECT * FROM dates;
```

Wynik:

```

+----------+
|d         |
+----------+
|2026-01-01|
|2026-01-02|
|2026-01-03|
|2026-01-04|
|2026-01-05|
.........
|2026-01-29|
|2026-01-30|
|2026-01-31|
+----------+
```
