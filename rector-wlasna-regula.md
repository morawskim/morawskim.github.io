# Rector własna reguła

Tworzymy szkic klasy dla reguły rector poleceniem `./vendor/bin/rector custom-rule`

Możemy także samemu utworzyć klasę dziedziczącą po `Rector\Rector\AbstractRector`.
Musimy zaimplementować metody: `getRuleDefinition`, `getNodeTypes` i `refactor`.

Metoda `getRuleDefinition` służy do opisania reguły (transformacji kodu), którą dana klasa implementuje.
Jest to sposób na dokumentowanie, jakie zmiany są dokonywane w kodzie źródłowym przez daną regułę.
Powinna zwracać krótki opis reguły i przykłady kodu pokazujące, jak wygląda kod przed zastosowaniem reguły i po.

Metoda `getNodeTypes` służy do określenia, z jakimi typami węzłów (ang. nodes) dana reguła Rectora jest powiązana.
Netoda ta definiuje, jakie elementy kodu źródłowego będą przetwarzane przez daną regułę.
Pewnie najczęściej będziemy wybierać typ węzła, który chcemy zmodyfikować np. jeśli chcemy zmienić nazwę wywoływanej metody \
to typ węzła będzie `PhpParser\Node\Expr\MethodCall`.
Warto utworzyć jak najprostrzy fragment kodu (nawet 1 linie) i wywołać polecenie \
` vendor/bin/php-parse --var-dump example.php` w celu wyświetlenia węzłów i poznanie typu węzła.


Tworząc własne reguły możemy także skorzystać z kilku metod zaimplementowanych w AbstractRector:

* `isName` sprawdza, czy nazwa danego węzła AST (np. funkcji, metody, klasy, zmiennej) odpowiada określonemu ciągowi znaków. \
Za pomocą tej metody możemy spraawdzić, czy wywoływana jest metoda o określonej nazwie np. `foo`.

* `isObjectType` służy do sprawdzania, czy dany węzeł AST reprezentuje obiekt określonego typu (klasy lub interfejsu). \
Możemy więc skorzystać z tej metody do sprawdzenia, czy obiekt jest instancją konkretnej klasy w wyrażeniach takich jak np. wywołanie metod.


Przykładowy plik konfiguracyjny rector:

```
<?php

declare(strict_types=1);

use Utils\Rector\Rector\MyRuleRector;
use Rector\Config\RectorConfig;

return RectorConfig::configure()
    ->withPaths([__DIR__ . '/src'])
    ->withRules([
        MyRuleRector::class,
    ]);
```

Uruchamiając testowo rector warto wyłączyć cache - `./vendor/bin/rector process --dry-run --clear-cache`

## Testy jednostkowe

Do tworzenia testów jednostkowych warto skorzystać z klasy `Rector\Testing\PHPUnit\AbstractRectorTestCase`, która upraszcza testowanie reguł refaktoryzacji - \
Umożliwia porównywanie kodu źródłowego "przed" i "po" zastosowaniu konkretnej reguły.

Musimy zaimplementować metodę `provideConfigFilePath`, która zwraca ścieżkę do plik konfiguracyjny dla Rectora.
Przykładowy plik konfiguracyjny dla testów:
```
<?php

declare(strict_types=1);

use Rector\Config\RectorConfig;
use Utils\Rector\Rector\RemoveCloneOnDateTimeRector;

return RectorConfig::configure()
    ->withRules([\Utils\Rector\Rector\MyRuleRector::class]);

```

Tworzymy statyczną metodę, która zwróci nam dane do testów.
Pliki w katalogu `Fixture` powinny mieć rozszerzenie `.php.inc`, każdy plik to jeden przypadek testowy, a także w jednym pliku umieszczamy kod "przed" i "po" \
zastosowaniu reguły refaktoryzującej oddzielając je `-----`.
W przypadku, gdy kod jest taki sam (czyli reguła nie ma zastosowania i nie modyfikuje kodu) możemy podać kod bez wersji "po".

```
public static function providedDataForTest(): iterable
{
    return self::yieldFilesFromDirectory(__DIR__ . '/Fixture');
}
```

Tworzymy metodę z testem i podłączamy utworzony provider.

```
#[DataProvider('providedDataForTest')]
public function testRule(string $fixtureFilePath)
{
    $this->doTestFile($fixtureFilePath);
}
```
