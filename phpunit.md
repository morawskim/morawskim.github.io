# PHPUnit

PHPUnit to pakiet do tworzenia i uruchamiania testów jednostkowych. IDE PHPStorm [zawiera plugin](https://plugins.jetbrains.com/plugin/9674-phpunit-enhancement), który dostarcza autouzupełnianie, nawigację po kodzie i refaktoryzację dla atrap obiektów (mocked object).

## Testy integracyjne Symfony

Instalując pakiet `symfony/test-pack` możemy wykorzystać PHPUnit do tworzenie testów integracyjnych. W tym typie testów nie tworzymy atrap - wykorzystujemy rzeczywiste usługi.
Tworząc nowy przypadek testowy, nie dziedziczymy po klasie `\PHPUnit\Framework\TestCase`, lecz `\Symfony\Bundle\FrameworkBundle\Test\KernelTestCase`. Klasa ta dostarcza nam statyczne metody do uruchomienia kernela Symfony. Na początku testu musimy wywołać `self::bootKernel()`. Metoda ta upewnia się, że istniejący kernel został wyłączony, a następnie tworzy nowy na potrzeby testu. Następnie korzystając z metody `self::$kernel->getContainer()->get(<SERVICE_ID>)` możemy pobierać z naszego kontenera usługi.
Jednak w Symfony4 nasze usługi, które są automatycznie rejestrowane są prywatne. Nie możemy, więc ich bezpośrednio pobrać z kontenera wykorzystując identyfikator usługi. W przypadku Symfony4 tworzymy plik `config/services_test.yaml` i ustawiamy klucz `public` na wartość `true`:

```
services:
    _defaults:
        public: true
```
Następnie w tym pliku możemy definiować aliasy usług.

```
services:
    #....
    test.App\Service\FooService: '@App\Service\FooService'
```

Możemy także użyć innej formy. W tym przypadku jawnie definiujemy, że usługa jest publiczna.
```
services:
    # access the service in your test via
    # self::$container->get('test.App\Service\FooService')
    test.App\Service\FooService:
        # the id of the private service
        alias: 'App\Service\FooService'
        public: true
```

## Uruchomienie tylko jednego testu

W momencie gdy, chcemy debugować nasz test, przydatną opcją jest uruchomienie tylko jednego testu. Uruchamiamy phpunit z dodatkowym parametrem `--filter <TEST_NAME>`.
Jeśli test przyjmuje dane od dostawcy danych to możemy ograniczyć się tylko do konkretnego zestawu danych. Jeśli nie korzystamy z nazwanych zestawu danych to podajemy indeks tablicy - `--filter '<testMethod> #<index>'`. W przeciwnym przypadku `--filter '<testMethod> @<name>'`.

## Guzzle MockHandler

`Guzzle` to popularny klient HTTP, który upraszcza integrację z usługami REST. Dostarcza zbiór klas, które umożliwiają nam łatwo tworzyć atrapy (mocks) i testować warstwę HTTP bez wysyłania żądań HTTP przez internet.
Zamiast korzystać z domyślnego handlera, do metody `GuzzleHttp\HandlerStack::create` przekazujemy instancję `GuzzleHttp\Handler\MockHandler`. Za jej pomocą definiujemy gotowe odpowiedzi HTTP. Możemy, więc z łatwością zasymulować różnego rodzaju błędy API. Wykorzystując middleware history przechowujemy historię wysyłanych requestów HTTP, które możemy przetestować pod kątem zgodności z API.

``` php
<?php
// ....
$container = [];
$history = \GuzzleHttp\Middleware::history($container);
$mock = new \GuzzleHttp\Handler\MockHandler([
    new \GuzzleHttp\Psr7\Response(200, [], '<root />'),
]);
$handlerStack = \GuzzleHttp\HandlerStack::create($mock);
$handlerStack->push($history);
$client = new \GuzzleHttp\Client(['handler' => $handlerStack]);
$service = new FooApiClient($client, $apiKey);
$report = $service->getReportForProject(1);

$this->assertCount(1, $container);
/** @var \GuzzleHttp\Psr7\Request $request */
$request = $container[0]['request'];
$this->assertEquals('GET', $request->getMethod());
$this->assertEquals("api/projects/$projectId/reports", $request->getUri()->getPath());
$this->assertNull($report);
// ....
```

[Testing Guzzle Clients](http://docs.guzzlephp.org/en/stable/testing.html)
