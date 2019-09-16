# composer - wymuszenie specyficznej wersji PHP (rozszerzeń)

W celu zablokowania instalacji pakietu, który nie będzie kompatybilny z wersją PHP, definiujemy klucz `platform` w pliku `composer.json`. Dzięki temu composer, będzie blokował instalację pakietu przeznaczonej dla nowszej wersji PHP. Mając PHP 7.0, nie będzie instalował pakietu, który wymaga PHP 7.2.


``` json
"config": {
    "platform": {
        "php": "7.2"
    }
},
```

Więcej informacji https://getcomposer.org/doc/06-config.md#platform

Ta opcja konfiguracji pozwala nam oszukać composera (emulować środowisko produkcyjne). Composer będzie myślał, że na naszym serwerze zainstalowany jest PHP 7.2. Dodatkowo możemy także podać jakie rozszerzenia PHP znajdują się na produkcji. Jest to przydatne kiedy uruchamiamy `composer` na kontenerze CLI, gdzie nie mamy zainstalowanych wszystkich rozszerzeń PHP.

``` json
"config": {
    "platform": {
        "php": "7.3",
        "ext-gmp": "1.0.0"
    }
},
```

W `ext-gmp` nie możemy podać jako wersji `*` - composer się burzy: `Invalid version string "*"`.
Musimy jeszcze tylko zmodyfikować plik `composer.lock` poleceniem `composer update --lock`.
Dzięki temu na moim kontenerze CLI, composer już nie wyświetla błędu z brakującym rozszerzeniem i jestem w stanie zainstalować wszystkie pakiety:
```
- Installation request for mdanter/ecc v0.4.3 -> satisfiable by mdanter/ecc[v0.4.3].
- mdanter/ecc v0.4.3 requires ext-gmp * -> the requested PHP extension gmp is missing from your system.
 ```
