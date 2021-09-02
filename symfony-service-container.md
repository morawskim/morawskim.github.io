# Symfony Service Container

## Autowiring i typy abstrakcyjne

W projekcie zainstalowałem pakiet `lcobucci/clock`, aby pobierać informacje o aktualnej dacie z pośrednika i w efekcie pominąć wywołania systemowe. Pakiet ten dostarcza dwie implementacje. Do testów służy implementacja `Lcobucci\Clock\FrozenClock`. Konfigurując Service Container w Symfony chciałem wykorzystać abstrakcyjny typ danych, niż konkretną implementację. Autowire nie działa bezpośrednio z interfejsem. Musimy utworzyć alias usługi. W klasie w konstruktorze dodałem parametr o typie `Lcobucci\Clock\Clock`. W pliku `services.yml` zarejestrowałem usługę `Lcobucci\Clock\SystemClock: ~`. Następnie dla typu abstrakcyjnego utworzyłem alias do konkretnej implementacji `Lcobucci\Clock\Clock: '@Lcobucci\Clock\SystemClock'`. Dzięki temu framework Symfony podczas tworzenie mojej usługi automatycznie wstrzyknął wybraną implementację typu `Lcobucci\Clock\Clock`.

[autowiring and interfaces](https://symfony.com/doc/current/service_container/autowiring.html#working-with-interfaces)

## Konfiguracja Service Container w środowisku test

W środowisku testowym (`APP_ENV=test`) zależności nie są wstrzykiwane za pomocą konstruktora. W Symfony nasze usługi są rejestrowane jako prywatne. Nie możemy ich pobrać bezpośrednio z kontenera. Dla tego środowiska tworzymy więc plik konfiguracyjny `config/packages/test/services.yaml` i definiujemy w nim aliasy usług. Przykład poniżej tworzy nam alias `test.order.api.factory`, do automatycznie zarejestrowanej usługi `App\Factory\OrderApiFactory`. Dzięki temu, usługa `test.order.api.factory` jest publiczna, możemy ją bezpośrednio pobrać z kontenera. W metodzie testującej z kernela pobieramy `ServiceContainer` wywołując metodę `getContainer`. A następnie metodę `get`, aby pobrać usługę. Nasz test jednostkowy musi dziedziczyć po klasie `\Symfony\Bundle\FrameworkBundle\Test\KernelTestCase`.

```
test.order.api.factory:
    alias: 'App\Factory\OrderApiFactory'
    public: true
```

```
$kernel = self::bootKernel();
//...
/** @var OrderApiFactory $orderApiFactory */
$orderApiFactory = $kernel->getContainer()->get('test.order.apifactory');
```

## Service tags

Tagi nie zmieniają funkcjonowania usługi. Możemy jednak odpytać się kontener o listę usług, które zostały oznaczone określonym tagiem. W frameworku Symfony [mamy wiele wbudowanych tagów](https://symfony.com/doc/4.4/reference/dic_tags.html). Możemy także wyświetlić je korzystając z narzędzia konsolowego `./bin/console debug:container --tags | grep -E '^".*? tag$'``. Dzięki funkcji auto konfiguracji frameworka, nie musimy jawnie tagować usług. Usługi implementujące odpowiednie interfejsy lub rozszerzające wybrane klasy zostaną automatycznie oznaczone odpowiednim tagiem.

W aplikacji Symfony w metodzie `build` klasy `Kernel` (`src/Kernel.php`) możemy automatycznie przypisywać tag `app.custom_tag` usługom które implementują interfejs `CustomInterface`.

```
protected function build(ContainerBuilder $container)
{
    $container->registerForAutoconfiguration(CustomInterface::class)
        ->addTag('app.custom_tag')
    ;
}
```

W innej usłudze, możemy wstrzyknąć wszystkie usługi, które są oznaczone tagiem np. `app.custom_tag`. W pliku `config/services.yaml`

```
services:
    #.....
    App\HandlerCollection:
        # inject all services tagged with app.custom_tag as first argument
        arguments:
            - !tagged_iterator app.custom_tag
```

W przypadku konfiguracji w pliku `xml`:

```
<service id="App\HandlerCollection">
    <!-- inject all services tagged with app.custom_tag as first argument -->
    <argument type="tagged_iterator" tag="app.custom_tag"/>
</service>
```

[How to Work with Service Tags](https://symfony.com/doc/4.4/service_container/tags.html)

## Service configurator

Service configurator umożliwia nam wykorzystanie usługi do skonfigurowania innej usługi przed jej zwróceniem.
Jest to bardzo pomocne, gdy usługa wymaga dynamicznej konfiguracji np. na podstawie danych z bazy danych.

```
# config/services.yaml
services:
    # ...

    App\Some\Service:
        configurator: ['@App\Some\ServiceConfigurator', 'configure']
```

[How to Configure a Service with a Configurator](https://symfony.com/doc/current/service_container/configurators.html)
