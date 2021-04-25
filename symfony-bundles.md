# symfony bundles

## Doctrine extensions

Do biblioteki doctrine istnieje zestaw rozszerzeń [gedmo/doctrine-extensions](https://github.com/Atlantic18/DoctrineExtensions/). Możemy je zintegrować z [frameworkiem symfony](https://github.com/Atlantic18/DoctrineExtensions/blob/v2.4.x/doc/symfony4.md). Jednak lepiej jest skorzystać z bundle dla Symfony `stof/doctrine-extensions-bundle`. Za jego pomocą nie musimy konfigurować listenerów.

1. W pliku `config/packages/stof_doctrine_extensions.yaml`, który powinien pojawić się jeśli korzystamy z Symfony flex włączamy obsługę wybranych rozszerzeń doctrine dla wybranych [instancji EM](https://symfony.com/doc/master/bundles/StofDoctrineExtensionsBundle/configuration.html#configure-the-entity-managers).

1. W pliku `config/packages/doctrine.yaml` dodajemy konfigurację dla wybranego/wybranych rozszerzeń. W przypadku rozszerzenia `loggable` dodajemy
```
gedmo_loggable:
    type: annotation
    prefix: Gedmo\Loggable\Entity
    dir: "%kernel.project_dir%/vendor/gedmo/doctrine-extensions/lib/Gedmo/Loggable/Entity"
    alias: GedmoLoggable # (optional) it will default to the name set for the mapping
    is_bundle: false
```

[Mapping DoctrineExtension](https://github.com/Atlantic18/DoctrineExtensions/blob/v2.4.x/doc/symfony4.md#mapping)

[Dokumentacja StofDoctrineExtensionsBundle](https://symfony.com/doc/master/bundles/StofDoctrineExtensionsBundle/configuration.html#add-the-extensions-to-your-mapping)

### Loggable

1. Generujemy migrację i ją wywołujem - `./bin/console make:migration`. Utworzona zostanie tabela w bd do przechowywania zmian w naszych encjach.
1. W encji importujemy adnotacje - `use Gedmo\Mapping\Annotation as Gedmo;`
1. Korzystamy z adnotacji `@Gedmo\Loggable()` (na poziomie klasy), aby oznaczyć włączyć rozszerzenie loggable dla encji.
1. Jeśli przy aktualizacji chcemy logować, które pola zostały zmienione musimy je oznaczyć adnotacją `@Gedmo\Versioned()`. W przeciwnym przypadku nic nie zostanie zalogowane.

## happyr/entity-exists-validation-constraint

Ten bundle dostarcza walidator do sprawdzenia, czy encja istnieje w bazie danych. W pliku `config/services.yaml` rejestrujemy usługę `Happyr\Validator\Constraint\EntityExistValidator`:

```
Happyr\Validator\Constraint\EntityExistValidator:
    arguments: ['@doctrine.orm.entity_manager']
    tags: [ 'validator.constraint_validator' ]
```

Następnie możemy korzystać z adnotacji `\Happyr\Validator\Constraint\EntityExist` przy encjach/DTO -  `@EntityExist(entity="App\Entity\Foo", property="bar_id")`.

## LogBridgeBundle

Bundle `LogBridgeBundle` umożliwia logowanie żądań i odpowiedzi HTTP za pomocą biblioteki monolog. Bundle ten nie jest automatycznie konfigurowany podczas instalacji pakietu - `composer require m6web/log-bridge-bundle`. Musimy więc ręcznie dodać bundle i utworzyć plik konfiguracyjny. Plik [README opisuje niezbędne kroki](https://github.com/M6Web/LogBridgeBundle/blob/master/README.md). Dodatkowo nie jest wspierana wersja 5 Symfony.

Możemy ignorować nagłówki HTTP. Najczęściej ignorujemy nagłówki zawierające wrażliwe dane taki jak np. `Authorization`. W konfiguracji `config/packages/m6_web_log_bridge.yaml` w kluczu `ignore_headers` ustawiamy ignorowane nagłówki.

Warto skonfigurować dla monolog dodatkowy kanał `api`. Komunikaty z tego kanału powiniśmy logować do oddzielnego pliku. W konfiguracji `m6_web_log_bridge` ustawiamy parametr `channel`, aby dane byłby przesyłane do kanału `api`.

```
monolog:
  channels: ['api']
  handlers:
    apilog:
      type: rotating_file
      path: "%kernel.logs_dir%/api.log"
      level: debug
      channels: [api]
      max_files: 70

```

## NelmioApiDocBundle

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

### Endpoint zewnętrznej biblioteki

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

### HTTP auth basic

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

### Upload pliku (multipart/form-data)

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

### Dziedziczenie i polimorfizm

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

### Alternative Names

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

### Klasy

`Nelmio\ApiDocBundle\Routing\FilteredRouteCollectionBuilder` - Filtruje końcówki, które będą wyświetlane w dokumentacji OpenAPI. Końcówka musi pasować do przynajmniej jednego matchera.

`Nelmio\ApiDocBundle\ApiDocGenerator` - Klasa odpowiada za wygenerowanie pliku schematu OpenAPI

## lexik/jwt-authentication-bundle

Mikrousługi często oferują API REST zabezpieczone tokenem JWT. Taki token może być tworzony przez inną usługę. Domyślnie bundle `lexik/jwt-authentication-bundle` skonfigurowany jest do podpisywania i weryfikowania tokenów przez parę kluczy. Jeśli nie korzystamy z tego rozwiązania musimy odpowiednio skonfigurować bundle pod HMAC. Zamiast ustawiać klucze `public_key`, `secret_key` i `pass_phrase` ustawiamy tylko tajny współdzielony klucz w `secret_key`. Dodatkowo musimy ustawić z jakiego algorytmu podpisywania chcemy skorzystać. W moim przypadku `HS256`. Taką wartość podajemy w kluczu `signature_algorithm` elementu konfiguracji `encoder`.

```
lexik_jwt_authentication:
    secret_key: '%env(resolve:JWT_KEY)%'
    encoder:
        # encryption algorithm used by the encoder service
        signature_algorithm: HS256
```

Tokeny JWT mogą przechowywać claim z identyfikatorem użytkownika w innym polu niż encja użytkownika. W claim możemy przechowywać login, a naszym identyfikatorem użytkownika będzie kolumna `id`. W takim przypadku musimy skonfigurować parametry `user_identity_field` i `user_id_claim`. Pierwszy przechowuje nazwę pole w naszej encji, zaś drugi nazwę pola w tokenie JWT. W moim przypadku encja użytkownika wykorzystuje pole `id` do identyfikacji. Zaś w tokenie identyfikator użytkownika jest przechowywany w claim `uid`.

```
lexik_jwt_authentication:
    user_identity_field: id
    user_id_claim: uid
```

## zenstruck/foundry

Pakiet `zenstruck/foundry` pozwala tworzyć fixtures w Symfony wykorzystując Doctrine.
Modelując logikę domenową niektóre kolumny w encji mogą być ukryte i nie mają setterów. W takim przypadku nie możemy ustawić wartości. Często są to pola związane z datą, które są automatycznie ustawiane w przypadku zmiany statusu,
Rozwiązaniem jest skonfigurowanie [instantiation](https://github.com/zenstruck/foundry#instantiation), który ustawi wartości z wykorzystaniem Reflection API.

```
JobFactory::new([
    // ...
])->instantiateWith((new Instantiator())->alwaysForceProperties(['expiredAt']))->create();
```

W przypadku relacji 1 do 1 jak na przykład osoba i adres, możemy wykorzystać metodę `initialize` klasy `Factory` do utworzenia nowego adresu i przypisaniu go do konta.

```
protected function initialize(): self
{
    // see https://github.com/zenstruck/foundry#initialization
    return $this
         ->afterInstantiate(function (Person $person) {
             $person->setAddress(AddressFactory::new()->withoutPersisting()->create()->object());
             $person->setPassword($this->userPasswordEncoder->encodePassword($person, $person->getPassword()));
         })
    ;
}
```
