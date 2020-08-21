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
