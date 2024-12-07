# phpunit

## Pomiń testy w przypadku braku rozszerzenia PHP

W projekcie `yii2-utils` utworzyłem klasę `\mmo\yii2\actions\SlugGenerator`, która generuje nam slug.
Wykorzystuje ona klasę `\yii\helpers\Inflector`, która korzysta z rozszerzenia `intl`.
Podczas uruchomienia testów w środowisku, gdzie nie ma tego rozszerzenia otrzymujemy negatywny wynik testów.

`phpunit` obsługuje pomijanie testów, jeśli warunki nie są spełnione. Jednym z warunków może być zainstalowane rozszerzenie PHP. Dodając adontację `@requires extension intl` do testu jednostkowego ograniczyłem wykonywanie testów.
Nie otrzymuje fałszywych informacji o niepowodzeniu testów wynikających z braku rozszerzenia `intl`.
O pozostałych warunkach wstępnych, które ograniczają wykonywanie testów można przeczytać w [dokumentacji](https://phpunit.readthedocs.io/en/8.5/incomplete-and-skipped-tests.html#skipping-tests-using-requires).


## Atrapa (Mock) dynamicznej metody

Klasa `\yii\redis\Connection` dostarcza wiele wirtualnych metod np. `publish`. Odwzorują one polecenia redisa. Klasa nie zawiera ich definicji – są wywoływane poprzez magiczną metodę `__call`. Przy próbie stworzenia atrapy w phpunit, otrzymałem ostrzeżenie `[PHPUnit\Framework\Warning] Trying to configure method "publish" which cannot be configured because it does not exist, has not been specified, is final, or is static`.

Rozwiązaniem jest jawne określenie metod, które nie istnieją w klasie, a chcemy je mieć w naszej atrapie.

``` php
$redisMock = $this->getMockBuilder(Connection::class)->addMethods(['publish'])->getMock();
$redisMock->expects($this->once())
    ->method('publish')
    ->with($this->equalTo('sse'), $this->isType('string'));
```

## willReturnOnConsecutiveCalls i dynamicznie obliczanie wartości dla kolejnych wywołań metody

```
$mock->method('someMethod')->willReturnOnConsecutiveCalls(
    $this->returnCallback(function () {
        return 1;
    }),
    $this->returnCallback(function () {
        return 2;
    })
);

$mock->someMethod(); // Returns 1
$mock->someMethod(); // Returns 2
```

Warto jednak pamiętać, że metoda `willReturnOnConsecutiveCalls` jest oznaczona jako deprecated i zostanie skasowana w PHPUnit 12 - [Deprecate InvocationMocker::willReturnOnConsecutiveCalls() #5425](https://github.com/sebastianbergmann/phpunit/issues/5425)

## Yii2 i Active Record

Yii2 wykorzystuje wzorzec Active Record, który utrudnia pisanie testów jednostkowych.
Gdy próbujemy ustawić wartość dla pola modelu, Yii2 nawiązuje połączenie z bazą danych w celu pobrania informacji o dostępnych kolumnach w bazie danych.

W projekcie mieliśmy model dla którego chciałem utworzyć testy w celu sprawdzenia działania walidacji.
PHPUnit umożliwia nam utworzenie częściowej atrapy.
W pliku testy tworzymy atrapę, na której ustawiamy stan i wywołujemy metodę walidacji/walidatora.

```
$mock = $this->createPartialMock(MyActiveRecordModel::class, ['getRelatedActiveRecordModel', 'attributes']);
$mock->method('getRelatedActiveRecordModel')->willReturnCallback($myCallable);
$mock->method('attributes')->willReturn(['status', 'type']);
```
