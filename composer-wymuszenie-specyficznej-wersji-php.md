# composer - wymuszenie specyficznej wersji PHP

W celu zablokowania instalacji pakietu, który nie będzie kompatybilny z wersją PHP, definiujemy klucz `platform` w pliku `composer.json`. Dzięki temu composer, będzie blokował instalację pakietu przeznaczonej dla nowszej wersji PHP. Mając PHP 7.0, nie będzie instalował pakietu, który wymaga PHP 7.2. 


``` json
"config": {
    "platform": {
        "php": "7.2"
    }
},
```

Więcej informacji https://getcomposer.org/doc/06-config.md#platform
