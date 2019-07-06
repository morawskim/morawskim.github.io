# Postgres snippets

## case insensitive searching

`SELECT 'aFOOb' ~* 'foo';`

`SELECT 'aFOOb' !~* 'foo';`

| Operator | Description | Example |
|----------|-------------|---------|
| ~ 	| Matches regular expression, case sensitive | 'thomas' ~ '.*thomas.*' |
| ~* | Matches regular expression, case insensitive | 'thomas' ~* '.*Thomas.*' |
| !~ | Does not match regular expression, case sensitive | 'thomas' !~ '.*Thomas.*' |
| !~* | Does not match regular expression, case insensitive | 'thomas' !~* '.*vadim.*' |

https://www.postgresql.org/docs/9.3/functions-matching.html#FUNCTIONS-POSIX-REGEXP

## Aktualizacja jednego pola w kolumnie json

```
UPDATE poi
    SET tags = jsonb_set(to_jsonb(coalesce(tags, '{}')), '{networks}', '[54212, 235841]')::json
    WHERE id = 45;
```

## Cluster number

``` sql
SELECT q.clst_id, COUNT(*) FROM (SELECT ST_ClusterDBSCAN(
    ST_SetSRID(ST_MakePoint(a.lon, a.lat), 4326),
                                        200/111111.0,
    1
    ) OVER () AS clst_id
FROM (
    SELECT 10.0001 as lat, 10.00001 as lon
    UNION ALL
    SELECT 10.0002 as lat, 10.00002 as lon
    UNION ALL
    SELECT 55.0002 as lat, 24.00002 as lon
         ) a
) q
GROUP BY q.clst_id
```

## Window functions

[Window function](https://www.postgresql.org/docs/9.6/tutorial-window.html) - wykonuje obliczenia dla całego zestawu wierszy, które są w jakiś sposób powiązane z bieżącym wierszem.

``` sql
SELECT depname, empno, salary, avg(salary) OVER (PARTITION BY depname) FROM empsalary;
```

## Wersja postgres

``` sql
SELECT version();
```

Przykładowy wynik:
`PostgreSQL 11.3 (Ubuntu 11.3-1.pgdg18.04+1) on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 7.4.0-1ubuntu1~18.04) 7.4.0, 64-bit`
