# NelmioApiDocBundle

Ten bundle generuje dokumentację w formacie OpenAPI dla REST API z adnotacji. Obecnie dostępna jest wersja beta, która obsługuje specyfikację OpenAPI w wersji 3. Aby ją zainstalować wydajemy polecenie `composer require nelmio/api-doc-bundle:^4.0`. Jeśli dostaniemy błąd podobny do poniższego:

` The requested package nelmio/api-doc-bundle ^4.0 is satisfiable by nelmio/api-doc-bundle[4.0.x-dev, v4.0.0-BETA1, v4.0.0-BETA2] but these conflict with your requirements or minimum-stability.`

Możemy wymusić zainstalowanie wersji beta wywołując polecenie `composer require nelmio/api-doc-bundle:^4.0-BETA2`.
Jeśli korzystamy z Symfony Flex to początkowa konfiguracja zostanie utworzona. Jednak dostęp do dokumentacji, może być blokowany przez konfigurację firewalla. W sekcji `firewalls` pliku `config/packages/security.yaml` wyłączamy mechanizm bezpieczeństwa dla ścieżek `/api/doc` i `/api/doc.json`.

```
apiDoc:
    pattern: ^/api/(doc|doc\.json)$
    security: false
```

W przypadku włączenia rutera do pliku JSON specyfikacji OpenAPI możemy wykluczyć tą końcówkę z dokumentacji. W pliku `config/packages/nelmio_api_doc.yaml` modyfikujemy wyrażenie regularne w kluczu `areas.path_patterns` z domyślnej wartości `^/api(?!/doc$)` na `^/api(?!/doc|/doc\.json$)`.

W pliku konfiguracyjnym `config/packages/nelmio_api_doc.yaml` dodajemy mechanizm autoryzacji (przykład dla tokenów JWT):

```
components:
    securitySchemes:
        Bearer:
            type: http
            description: 'Value: Bearer {jwt}'
            scheme: bearer
            bearerFormat: JWT
```

W kontrolerze możemy określić, że nasza końcówka wymaga autoryzacji korzystając z adnotacji `Nelmio\ApiDocBundle\Annotation\Security`. Jeśli zadeklarowaliśmy mechanizm bezpieczeństwa pod nazwą `Bearer` to naszą akcję kontrolera oznaczamy przez `@Security(name="Bearer")`. W celu nadania końcówce API podsumowanie i opis korzystamy z domyślnej konwencji PHPDocs. Pierwsza linia to krótkie podsumowanie. Następnie możemy podać dłuższy opis.

### Globalny nagłówek

W pliku konfiguracyjnym `config/packages/nelmio_api_doc.yaml` deklarujemy nowy parametr.

```
nelmio_api_doc:
    documentation:
        components:
            parameters:
                SalesChannel:
                    name: X-Sales-Channel
                    in: header
                    required: true
                    schema:
                        type: string
                        enum: [pl, us]
```

Następnie do każdej końcówki API musimy dodać referencję do zdefiniowanego parametru.

```
/**
 * .....
 * @OA\Parameter(
 *     ref="#/components/parameters/SalesChannel"
 * )
 * ....
```

## Endpoint zewnętrznej biblioteki

`lexik/jwt-authentication-bundle` to popularna biblioteka symfony, która oferuje autoryzację przez token JWT.
Dostarczana końcówka API przez tą bibliotekę nie znajduje się w wynikowym pliku schematu OpenAPI.
Rozwiązaniem jest jawne utworzenie dokumentacji dla tego endpointa w pliku konfiguracyjnym `config/packages/nelmio_api_doc.yaml`.

```
nelmio_api_doc:
    documentation:
        paths:
            /api/sessions:
                post:
                    requestBody:
                        description: 'Login'
                        content:
                            application/json:
                                schema:
                                    $ref: '#/components/schemas/LoginRequest'
                    responses:
                        401:
                            description: Invalid credentials
```

## HTTP auth basic

Środowiska testowe często są zabezpieczane przez mechanizm Auth Basic. Specyfikacja OpenAPi nie umożliwia nam w sekcji servers osadzić loginu i hasła (https://swagger.io/specification/#server-object). Musimy zdefiniować security scheme i ustawić go globalnie.

```
nelmio_api_doc:
    documentation:
        components:
            securitySchemes:
                basicAuth:
                    type: http
                    scheme: basic
    security:
        - basicAuth: []
```

## Upload pliku (multipart/form-data)

Za pomocą specyfikacji OpenAPI możemy opisać końcówkę do przesyłania plików. Wyświetlając wygenerowaną dokumentację w przeglądarce, będziemy w tanie przesłać wybrany plik.
Wpierw definiujemy schemat dla żądania HTTP i podłączamy go do obiektu `RequestBody` ustawiając poprawną wartość dla mediaType.

[OpenAPI file-upload](https://swagger.io/docs/specification/describing-request-body/file-upload/)

```
FileUpload:
    type: object
    properties:
        upload_image_form[file]:
            type: string
            format: binary
```

```
/**
 * ...
 * @OA\RequestBody(
 *     description="Upload a file",
 *     @OA\MediaType(
 *           mediaType="multipart/form-data",
 *           @OA\Schema(ref="#/components/schemas/FileUpload")
 *     )
 * )
 * ...
 */
```

## Dziedziczenie i polimorfizm

W API możemy mieć modele, które współdzielą wspólne właściwości. OpenAPI umożliwia nam opisanie takich modeli w formie kompozycji zamiast powtarzać tą samą definicję. Wystarczy skorzystać z `allOf`

[Inheritance and Polymorphism](https://swagger.io/docs/specification/data-models/inheritance-and-polymorphism/)

W przykładzie poniżej definiujemy typ `OfferBaseType`, a także `OfferProductType`. Ten drugi zawiera wszystkie właściwości typu `OfferBaseType` a także definiuje swoje właściwości między innymi `price`.

```
nelmio_api_doc:
    documentation:
        components:
            schemas:
                # ....
                OfferBaseType:
                    required:
                        - title
                        # .....
                    properties:
                        title:
                            type: string
                        # .......
                    type: object
                OfferProductType:
                    allOf:
                        - $ref: '#/components/schemas/OfferBaseType'
                        - type: object
                          required:
                            - price
                            # ....
                          properties:
                            price:
                                $ref: '#/components/schemas/MoneyType'
                            # ....
```

W interfejsie API będziemy mieć końcówki, które przyjmują dane z różnych schematów np. różne typy produktów.
OpenAPI umożliwia nam opisać żądania i odpowiedzi API za pomocą kilku alternatywnych schematów. Wykorzystujemy do tego `oneOf`.

W przykładzie poniżej definiujemy schemat `OfferData`, który może być ogłoszeniem: o pracę, usługi lub produktu.
Następnie przy opisie końcówki możemy skorzystać z adnotacji `RequestBody` i określić, że body żądania musi być jednym z typów ogłoszenia (`OfferData`).

```
nelmio_api_doc:
    documentation:
        components:
            schemas:
                OfferData:
                    description: Offer
                    oneOf:
                        - ref: "#/components/schemas/OfferJobType"
                        - ref: "#/components/schemas/OfferServiceType"
                        - ref: "#/components/schemas/OfferProductType"
                CreateOfferRequest:
                    type: object
                    required:
                        - type
                        - offer
                    properties:
                        type:
                            type: string
                            enum:
                                - service
                                - product
                                - job_offer
                        offer:
                            $ref: '#/components/schemas/OfferData'
```

```
/**
 * ...
 * @OA\RequestBody(
 *     description="Create offer",
 *     @OA\JsonContent(ref="#/components/schemas/CreateOfferRequest")
 * )
 * ...
 */
```

## Alternative Names

Alternatywne nazwy mogą się przydać w momencie wykorzystywania klas zewnętrznej biblioteki. `misd/phone-number-bundle` dostarcza typ `PhoneNumberType`, dla którego wygenerowana dokumentacja OpenAPI to obiekt bez żadnej właściwości. Możemy dokumentować pola formularza [Symfony Form types](https://github.com/nelmio/NelmioApiDocBundle/blob/master/Resources/doc/index.rst#symfony-form-types) albo skorzystać właśnie z [Alternative Names](https://github.com/nelmio/NelmioApiDocBundle/blob/master/Resources/doc/alternative_names.rst).

Przykład poniżej definiuje alias `PhoneNumberType`, a następnie dokumentujemy ten typ danych.
```
nelmio_api_doc:
    models:
        names:
            - { alias: PhoneNumberType, type: Misd\PhoneNumberBundle\Form\Type\PhoneNumberType }
    documentation:
        components:
            schemas:
                PhoneNumberType:
                    description: Phone number
                    type: string
                    example: "+48888666111"
```

## Klasy

`Nelmio\ApiDocBundle\Routing\FilteredRouteCollectionBuilder` - Filtruje końcówki, które będą wyświetlane w dokumentacji OpenAPI. Końcówka musi pasować do przynajmniej jednego matchera.

`Nelmio\ApiDocBundle\ApiDocGenerator` - Klasa odpowiada za wygenerowanie pliku schematu OpenAPI
