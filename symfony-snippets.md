# symfony snippets

## Ustawienie domyślnych wartości dla zmiennych środowiskowych

Domyślną wartość dla zmiennej środowiskowej ustawiamy w kluczu `parameters`.
Tworząc parametr `env(VARIABLE_NAME)` i przypisując wartość, utworzyliśmy domyślną wartość dla zmiennej środowiskowej `VARIABLE_NAME`. Jeśli zmienna środowiskowa będzie ustawiona, jej wartość nadpisze domyślną wartość.

## entrypoints.json vs manifest.json

Encore tworzy dwa pliki: `entrypoints.json` i `manifest.json`. Oba pliki są podobne - zawierają powiązanie do wersjonowanej wersji pliku.

Plik `entrypoints.json` jest wykorzystywany przez funkcje Twiga: `encore_entry_script_tags` i `encore_entry_link_tags`. Dzięki tym funkcjom zostaną wygenerowane znaczniki HTML dla plików CSS i JavaScript.

Plik `manifest.json` jest potrzebny tylko do pobrania  nazwy pliku innych zasobów np. obrazki lub czcionki.

## symfony encore i runtime.js

Plik `runtime.js` jest generowany jeśli w konfiguracji encore jawnie wywołamy metodę `enableSingleRuntimeChunk`.

Jeśli w konfiguracji encore wywołaliśmy metodę `enableSingleRuntimeChunk` i mamy wiele plików "wejściowych" (entry files), które wczytują ten sam moduł (np. jquery) to nasze pliki js dostaną ten sam obiekt.

Jeśli wywołamy metodę `disableSingleRuntimeChunk` to nasze pliki js dostaną różne obiekty wczytywanego modułu.

W przypadku aplikacji, które nie są tzw. "single-page app", to najpewniej będziemy chcieli korzystać z `runtime.js`.


## Domyślna wartość dla pola w Doctrine2

``` php
/**
 * @ORM\Column(type="decimal", precision=10, scale=4, options={"default" : 0})
 */
private $avg30;
```
