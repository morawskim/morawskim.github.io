# Symfony Serializer

## Konfiguracja i wstrzyknięcie własnego ObjectNormalizer

Często używa się podkreślenia do oddzielenia wyrazów tzw. snake_case w API JSON np. API WooCommerce. W PHP jednak preferowany jest styl camelCase do nazywania właściwości. Framework Symfony zawiera usługę do normalizacji `serializer.normalizer.object`, która dzięki autowiring zmapowana jest do klasy `Symfony\Component\Serializer\Normalizer\ObjectNormalizer`. Jednak ta usługa nie wykorzystuje wbudowanego konwertera do transformacji między stylami snake_case i camelCase. Musiałem skonfigurować własną usługę.

W frameworku Symfony konfiguracja usług z komponentu Serializer znajduje się w pliku `Resources/config/serializer.xml` pakietu `symfony/framework-bundle`. Zawiera on konfigurację domyślnej usługi `serializer.normalizer.object`. Na jej podstawie utworzyłem definicję nowej usługi, lecz z inną polityką konwersji nazw pól.

W pliku `config/services.yaml` dodałem konfigurację aliasu `app.normalizer.snake`:

```
app.normalizer.snake:
    class: Symfony\Component\Serializer\Normalizer\ObjectNormalizer
    arguments:
        $classMetadataFactory: ~
        $nameConverter: '@serializer.name_converter.camel_case_to_snake_case'
    tags:
        - { name: 'serializer.normalizer', priority: 0 }
```

Następnie skonfigurowałem swoją fabrykę w tym samym pliku, aby w argumencie `$normalizer` przyjmował nową skonfigurowaną usługę.

```
App\Factory\AddressesFactory:
    arguments:
        $normalizer: '@app.normalizer.snake'
```

Wywołując polecenie `./bin/console debug:container --tag serializer.normalizer` możemy się upewnić, że nasz nowe usługi są poprawnie skonfigurowane i gotowe do użycia. Warto zwrócić uwagę, że nasza usługa ma wyższy piorytet i będzie wykorzysywana zamiast oryginalnej implementacji.

## Symfony Framework konfiguracja serializer name_converter

Korzystając z frameworka Symfony, możemy globalnie skonfigurować wykorzystywany tramsformer nazw. w pliku `config/packages/framework.yaml` dodajemy konfigurację dla komponentu `serializer`:

```
serializer:
        name_converter: 'serializer.name_converter.camel_case_to_snake_case'
```

[Framework Configuration Reference (FrameworkBundle)](https://symfony.com/doc/current/reference/configuration/framework.html#serializer)

## FOSRestBundle

Pakiet `friendsofsymfony/rest-bundle`  często jest wykorzystywany przy budowaniu API REST. Bundle też może korzystać z Symfonowego komponentu serializacji. Poniższy fragment kodu, przedstawia jak ustawić specyficzne opcje kontekstu serializatora Symfony. Do serializacji wybranych pól, lepiej skorzystać z [groups](https://symfony.com/doc/current/components/serializer.html#attributes-groups).

```
$ctx = new Context();
$view = $this->view($order, 200);
$view->setContext($ctx);
$ctx->setAttribute(AbstractNormalizer::ATTRIBUTES, ['id', 'shippingAddress' => ['firstName', 'lastName', 'street']]);
```

## Normalizer test jednostkowy

Normalizator utworzony przez wywołanie polecenia `./bin/console make:serializer:normalizer` oczekuje przekazania w konstruktorze instancji `ObjectNormalizer`.
Framework symfony konfiguruje tą usługę w pliku `Resources/config/serializer.xml` pakietu `symfony/framework-bundle`. W przypadku testów jednostkowych musimy samemu utworzyć usługę i przekazać niezbędne zależności.
Poniższy kod tworzy instancję `ObjectNormalizer` z obsługą adnotacji. Jeśli w naszym teście wykorzystujemy inne obiekty implementujące interfejs `NormalizerInterface` to musimy je dodać przy tworzeniu usługi `Serializer`. W przykładzie poniżej dodajemy `JsonSerializableNormalizer`.

```
$normalizer = new ObjectNormalizer(
    new ClassMetadataFactory(new AnnotationLoader(new AnnotationReader())),
    new MetadataAwareNameConverter(
        new ClassMetadataFactory(new AnnotationLoader(new AnnotationReader())),
        new CamelCaseToSnakeCaseNameConverter()
    )
);
$normalizer->setSerializer(new Serializer([new JsonSerializableNormalizer(), $normalizer], []));
```
