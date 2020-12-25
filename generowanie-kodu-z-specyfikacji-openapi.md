# Generowanie kodu z specyfikacji OpenAPI

`jane` jest narzędziem do generowania kodu PHP na podstawie specyfikacji JsonSchema lub OpenAPI. Dla wersji 3 OpenAPI musimy zainstalować dwa pakiety `jane-php/open-api-3` i `jane-php/open-api-runtime`. Instalujemy je przez composer:

```
composer require --dev jane-php/open-api-3
composer require jane-php/open-api-runtime
```

Po zainstalowaniu tworzymy plik konfiguracyjny `.jane-openapi` o zawartości:

```
<?php

return [
    'openapi-file' => 'SCIEZKA_DO_PLIKU_ALBO_URL',
    'namespace' => 'Namespace\Dla\Wygenerowanego\Kodu',
    'directory' => __DIR__ . '/katalog/gdzie/jane/wygeneruje/pliki',
    'throw-unexpected-status-code' => true,
];
```
Opcja `throw-unexpected-status-code` rzuci wyjątkiem `UnexpectedStatusCodeException` kiedy kod odpowiedzi HTTP nie został opisany w specyfikacji OpenAPI. Domyślnie ta opcja jest wyłączona.

Następnie możemy wygenerować kod wywołując polecenie `php vendor/bin/jane-openapi generate`

W celu skorzystania z klienta potrzebujemy bibliotek PHP implementujących standard PSR-18 np. `symfony/http-client` i PSR-17  np. `http-interop/http-factory-guzzle`. W przypadku problemów możemy skorzystać z [dokumentacji](http://docs.php-http.org/en/latest/discovery.html#common-errors).

Następnie możemy już korzystać z klienta API. Importujemy klasę `Client` z przestrzeni nazw ustawionej w pliku konfiguracyjnym. W przypadku gdy, nasze API wykorzystuje autoryzację to musimy zarejestrować plugin `Jane\OpenApiRuntime\Client\Plugin\AuthenticationRegistry`. Robimy to przekazując tablicę pluginów jako drugi argument podczas wywołania metody `create` na klasie `Client`.
Wygenerowane przez `jane` mechanizmy autoryzacji będą dostępne w przestrzeni `Namespace\Dla\Wygenerowanego\Kodu\Authentication`. Musimy je przekazać jako argument konstruktora do pluginu `AuthenticationRegistry`.


[Dokumentacja](https://jane.readthedocs.io/en/latest/index.html)
