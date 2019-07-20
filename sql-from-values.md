# SQL - FROM VALUES

W sql możemy tworzyć tabele doraźne (ad-hoc) korzystając z operatora `UNION`.
Dzięki temu, możemy np. sprawdzić jak zachowa się funkcja agregująca `AVG` jeśli w jednym z wierszy pojawi się wartość `NULL`. Jeśli w każdym wierszu będzie wartość NULL, to otrzymamy błąd. W przeciwnym przypadku bd zignoruje wartości null. W poniższych przykładach dostaniemy cyfrę 4 jako wartość średnią.

``` sql
SELECT AVG(q.c) FROM (
                   SELECT 4 as c
                    UNION ALL
                    SELECT 4
                    UNION ALL
                    SELECT NULL
                    UNION ALL
                    SELECT 4
                       ) q
```

Jednak niektórzy producenci baz danych obsługują wygodniejszą składnię.

## MySQL/Postgres

``` sql
SELECT AVG(q.c) FROM (
    values (4), (4), (NULL), (4)
 )q (c)
```
