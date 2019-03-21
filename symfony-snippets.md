# symfony snippets

## Ustawienie domyślnych wartości dla zmiennych środowiskowych

Domyślną wartość dla zmiennej środowiskowej ustawiamy w kluczu `parameters`.
Tworząc parametr `env(VARIABLE_NAME)` i przypisując wartość, utworzyliśmy domyślną wartość dla zmiennej środowiskowej `VARIABLE_NAME`. Jeśli zmienna środowiskowa będzie ustawiona, jej wartość nadpisze domyślną wartość.
