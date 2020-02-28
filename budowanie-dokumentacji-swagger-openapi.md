# Budowanie dokumentacji Swagger/OpenAPI

Do dokumentowania restowego API w PHP możemy wykorzystać pakiet `zircote/swagger-php`. Pakiet ten dostarcza adnotacje. Powinniśmy zaimportować przestrzeń nazw - `use \OpenApi\Annotations as OA;` Wtedy zamiast korzystać z FQCN możemy użyć aliasu `OA`. Ze względu na brak natywnego wsparcia dla adnotacji w języku PHP, musimy je tworzyć w komentarzu PHPDOC. Parsowanie adnotacji odbywa się przez bibliotekę `doctrine/annotations`.

Mając już udokumentowane API przez adnotacje, możemy przejść do budowania dokumentu HTML.
Jednak zanim zbudujemy dokument HTML wpierw generujemy na podstawie naszych adnotacji dokument json zgodny z specyfikacją OpenAPI. Pakiet `zircote/swagger-php` dostarcza nam narzędzie konsolowe, które skanuje katalog(i), odczytuje adnotacje OpenAPI i tworzy plik JSON. Wywołujemy je w następujący sposób `./vendor/bin/openapi --bootstrap config/openApiConst.php -o public/openAPI.json ./src`. Parametr `--bootstrap` umożliwia nam zdefiniowanie stałych, z których możemy korzystać w adnotacjach. W katalogu `public` utworzony zostanie plik `openAPI.json`.

Do wygenerowania dokumentacji w formacie HTML, możemy skorzystać z pakietu npm `redoc-cli`.
Wywołaj `npx redoc-cli bundle -o public/documentation.html public/openAPI.json`.
Dzięki npx nie musimy dodawać do naszego projektu zależności. W przypadku braku pakietu, npx automatycznie go pobierze. W katalogu `public` zostanie utworzony plik `documentation.html`, który zawiera dokumentację naszego API.

Możemy także skorzystać z innego narzędzia do budowania dokumentacji - `swagger-api/swagger-ui`. Ten pakiet dostępny jest także dla PHP. Wystarczy wywołać polecenie - `composer require swagger-api/swagger-ui`. Po instalacji pakietu, musimy skopiować pliki z katalogu `vendor/swagger-api/swagger-ui/dist` do naszego publicznego katalogu (DOCUMENT_ROOT). Musimy zmodyfikować tylko plik `index.html`. Musimy zmodyfikować ścieżkę do pliku json z schematem naszego API. Domyślnie parametr `url` ma wartość `https://petstore.swagger.io/v2/swagger.json`. Dostosowujemy ten parametr do naszych potrzeb np. `/openAPI.json`.
