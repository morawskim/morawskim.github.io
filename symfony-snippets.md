# symfony snippets

## Ustawienie domyślnych wartości dla zmiennych środowiskowych

Domyślną wartość dla zmiennej środowiskowej ustawiamy w kluczu `parameters`.
Tworząc parametr `env(VARIABLE_NAME)` i przypisując wartość, utworzyliśmy domyślną wartość dla zmiennej środowiskowej `VARIABLE_NAME`. Jeśli zmienna środowiskowa będzie ustawiona, jej wartość nadpisze domyślną wartość.

## entrypoints.json vs manifest.json

Encore tworzy dwa pliki: `entrypoints.json` i `manifest.json`. Oba pliki są podobne - zawierają powiązanie do wersjonowanej wersji pliku.

Plik `entrypoints.json` jest wykorzystywany przez funkcje Twiga: `encore_entry_script_tags` i `encore_entry_link_tags`. Dzięki tym funkcjom zostaną wygenerowane znaczniki HTML dla plików CSS i JavaScript.

Plik `manifest.json` jest potrzebny tylko do pobrania  nazwy pliku innych zasobów np. obrazki lub czcionki.
