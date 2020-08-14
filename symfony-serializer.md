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
