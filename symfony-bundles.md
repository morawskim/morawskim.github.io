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
