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

Zdefiniowany handler domyślnie korzysta z formatera `monolog.formatter.line`. Nasz wpis w logu będzie więc nieczytelny, ponieważ znaki nowych linii zostaną zastąpione znakiem spacji (`\Monolog\Formatter\LineFormatter::replaceNewlines`). Warto zdefiniować oddzielny formater monolog. W pliku `config/services.yaml` definiujemy nową usługę `monolog.formatter.multiline`:

```
monolog.formatter.multiline:
    class: Monolog\Formatter\LineFormatter
    arguments:
        $allowInlineLineBreaks: true
```

Następnie do naszego handlera `apilog` dodajemy klucz `formatter` z identyfikatorem usługi formatter monolog - `monolog.formatter.multiline`.

```
apilog:
  type: rotating_file
  path: "%kernel.logs_dir%/api.log"
  level: debug
  channels: [api]
  max_files: 70
  formatter: monolog.formatter.multiline # ustawienie formatera
```

## lexik/jwt-authentication-bundle

Mikrousługi często oferują API REST zabezpieczone tokenem JWT. Taki token może być tworzony przez inną usługę. Domyślnie bundle `lexik/jwt-authentication-bundle` skonfigurowany jest do podpisywania i weryfikowania tokenów przez parę kluczy. Jeśli nie korzystamy z tego rozwiązania musimy odpowiednio skonfigurować bundle pod HMAC. Zamiast ustawiać klucze `public_key`, `secret_key` i `pass_phrase` ustawiamy tylko tajny współdzielony klucz w `secret_key`. Dodatkowo musimy ustawić z jakiego algorytmu podpisywania chcemy skorzystać. W moim przypadku `HS256`. Taką wartość podajemy w kluczu `signature_algorithm` elementu konfiguracji `encoder`. Klucz `token_ttl` pozwala nam ograniczyć ważność tokenu JWT do 30 min (1800 sekund).

```
lexik_jwt_authentication:
    secret_key: '%env(resolve:JWT_KEY)%'
    token_ttl: 1800
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

## gesdinet/jwt-refresh-token-bundle

Pakiet ten umożliwia nam odświeżanie tokenu JWT z informacji przesłanych w ciasteczku HTTP. Dzięki temu, żaden złośliwy kod JavaScript nie może pobrać ani tokenu JWT, ani refresh tokenu.  Niestety ta funkcjonalność ciągle czeka na scalenie i wypuszczenie w nowej wersji ([Support for refresh token in cookie](https://github.com/markitosgv/JWTRefreshTokenBundle/pull/199)).

Przykładowa konfiguracja bundle z cookie:

```
gesdinet_jwt_refresh_token:
  ttl: 2592000
  user_identity_field: username
  user_provider: security.user.provider.concrete.<your_user_provider_name_in_security_yaml><>
  cookie:
    sameSite: lax
    path: /api/
    domain: null
    httpOnly: true
    secure: true
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

## nelmio/cors-bundle

Bundle `NelmioCorsBundle` dodaje obsługę nagłówków CORS. Instalując ten pakiet przez `symfony/flex` utworzony zostanie plik z przykładową konfiguracją. W przypadku końcówki, której zadaniem jest odświeżanie tokenu JWT musimy dodać klucz `allow_credentials` jak w przykładzie poniżej.

```
nelmio_cors:
    defaults:
        origin_regex: false
        allow_origin: []
        allow_methods: []
        allow_headers: []
        expose_headers: []
        max_age: 3600
    paths:
        '^/api/sessions/refresh':
            allow_origin: [ '%env(CORS_ALLOW_ORIGIN)%' ]
            allow_headers: [ 'Content-Type', 'Accept', 'Cookie' ]
            allow_methods: [ 'POST', 'OPTIONS' ]
            allow_credentials: true
        # ....
        '^/': null

```

## friendsofsymfony/rest-bundle

Zadaniem tego bundle jest dostarczenie niezbędnych narzędzi pomocnych do zbudowania REST API w Symfony.
Ciekawym rozwiązaniem jest dostarczenie nowej implementacji interfejsu `\Sensio\Bundle\FrameworkExtraBundle\Request\ParamConverter\ParamConverterInterface` - `RequestBodyParamConverter`.
Za jej pomocą możemy przekształcić ciało żądania HTTP w obiekt DTO - `@ParamConverter("dto", converter="fos_rest.request_body")`.
Więcej informacji o konfiguracji znajduje się w [dokumentacji](https://github.com/FriendsOfSymfony/FOSRestBundle/blob/3.x/Resources/doc/request_body_converter_listener.rst).

## CMS

[Contao is a powerful open source CMS that allows you to create professional websites and scalable web applications.](https://contao.org/en/)

[Kunstmaan CMS - An advanced yet user-friendly content management system, based on the full stack Symfony framework combined with a whole host of community bundles.](https://cms.kunstmaan.be/)

[Bolt CMS](https://boltcms.io/)

[Deliver awesome, robust, reliable websites with Sulu CMS](https://sulu.io/)

[Grav](https://getgrav.org/)
