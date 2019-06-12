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
