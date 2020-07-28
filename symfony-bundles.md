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
