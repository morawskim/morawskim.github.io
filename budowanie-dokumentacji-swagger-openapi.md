# Budowanie dokumentacji Swagger/OpenAPI

Do dokumentowania restowego API w PHP możemy wykorzystać pakiet `zircote/swagger-php`. Pakiet ten dostarcza adnotacje. Powinniśmy zaimportować przestrzeń nazw - `use \OpenApi\Annotations as OA;` Wtedy zamiast korzystać z FQCN możemy użyć aliasu `OA`. Ze względu na brak natywnego wsparcia dla adnotacji w języku PHP, musimy je tworzyć w komentarzu PHPDOC. Parsowanie adnotacji odbywa się przez bibliotekę `doctrine/annotations`.

Mając już udokumentowane API przez adnotacje, możemy przejść do budowania dokumentu HTML.
Jednak zanim zbudujemy dokument HTML wpierw generujemy na podstawie naszych adnotacji dokument json zgodny z specyfikacją OpenAPI. Pakiet `zircote/swagger-php` dostarcza nam narzędzie konsolowe, które skanuje katalog(i), odczytuje adnotacje OpenAPI i tworzy plik JSON. Wywołujemy je w następujący sposób `./vendor/bin/openapi --bootstrap config/openApiConst.php -o public/openAPI.json ./src`. Parametr `--bootstrap` umożliwia nam zdefiniowanie stałych, z których możemy korzystać w adnotacjach (https://github.com/zircote/swagger-php/blob/3.0.3/docs/Getting-started.md#using-variables). W katalogu `public` utworzony zostanie plik `openAPI.json`.

Do wygenerowania dokumentacji w formacie HTML, możemy skorzystać z pakietu npm `redoc-cli`.
Wywołaj `npx redoc-cli bundle -o public/documentation.html public/openAPI.json`.
Dzięki npx nie musimy dodawać do naszego projektu zależności. W przypadku braku pakietu, npx automatycznie go pobierze. W katalogu `public` zostanie utworzony plik `documentation.html`, który zawiera dokumentację naszego API.

Możemy także skorzystać z innego narzędzia do budowania dokumentacji - `swagger-api/swagger-ui`. Ten pakiet dostępny jest także dla PHP. Wystarczy wywołać polecenie - `composer require swagger-api/swagger-ui`. Po instalacji pakietu, musimy skopiować pliki z katalogu `vendor/swagger-api/swagger-ui/dist` do naszego publicznego katalogu (DOCUMENT_ROOT). Musimy zmodyfikować tylko plik `index.html`. Musimy zmodyfikować ścieżkę do pliku json z schematem naszego API. Domyślnie parametr `url` ma wartość `https://petstore.swagger.io/v2/swagger.json`. Dostosowujemy ten parametr do naszych potrzeb np. `/openAPI.json`.

[Swagger Editor](https://editor.swagger.io/#/)

[Swagger 2.0 to OpenAPI 3.0.0 converter](https://openapi-converter.herokuapp.com/)

## Walidacja pliku definicji

Do weryfikacji poprawności definicji schematu openAPI używam pakietu npm `swagger-cli`.
Wystarczy go zainstalować i wywołać polecenie `npx swagger-cli validate </sciezka/do/pliku/definicji/openApi>`
W przypadku błędu/literówki dostaniemy błąd:

```
Swagger schema validation failed.
  Additional properties not allowed: descriptino at #/servers/0

JSON_OBJECT_VALIDATION_FAILE
```

## CORS

Jeśli nasze API i dokumentacja znajdują się na różnych domenach, wymagana będzie konfiguracja polityki `CORS`. Większość frameworków posiada wsparcie (middlewar) do konfigurowania polityki `CORS`. W przypadku frameworka `yii2` możemy skorzystać z filtru `\yii\filters\Cors`. W przypadku symfony mamy [NelmioCorsBundle](https://github.com/nelmio/NelmioCorsBundle). Korzystając z `curl` sprawdzamy nagłówki `CORS` - `curl -v -X OPTIONS   -H "Origin: https://developer.ssorder.snlb.pl"   -H 'Access-Control-Request-Method: GET'   https://ssorder.snlb.pl/v1/restaurants`

## Proxy

Prócz sprawdzania poprawności pliku definicji openAPI, warto upewnić się że nasz schemat jest aktualny i odzwierciedla nasze API. Do tego celu wykorzystujemy serwery proxy lub middleware, które sprawdzają poprawność odpowiedzi i żądań HTTP względem schematu openAPI.

[Node EXXETA/openapi-cop](https://github.com/EXXETA/openapi-cop)

[PHP thephpleague/openapi-psr7-validator](https://github.com/thephpleague/openapi-psr7-validator)

## Diff

`oasdiff` to narzędzie do porównania specyfikacji OpenAPI.

Porównanie specyfikacji między dwoma lokalnymi plikami z specyfikacją OpenAPI:
`docker run --rm -t -v $(pwd):/data:ro tufin/oasdiff -base /data/_doc-old.yaml -revision /data/_doc-new.yaml`

[oasdiff](https://github.com/Tufin/oasdiff)
