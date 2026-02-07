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

## Przykład

W projekcie ustalono zasady dotyczące nazewnictwa metod w klasach repozytoriów.
Metody rozpoczynające się od prefiksu "get" nie mogą zwracać wartości null.
Jeżeli encja nie istnieje, metoda powinna zgłosić wyjątek.

Poniższa reguła usuwa null ze zwracanego typu metody.
Dzięki temu, podczas uruchamiania narzędzia Rector w pipeline CI, możliwe jest wykrycie naruszeń tej zasady.
W efekcie pipeline zakończy się błędem, a programista zostanie poinformowany o konieczności dostosowania implementacji do przyjętych reguł projektowych.

Podczas pisania własnych reguł Rectora warto bazować na istniejących, wbudowanych przykładach dostępnych w repozytorium projektu.
W katalogu rules znajdują się implementacje wbudowanych reguł.
Każdy zestaw reguł posiada podkatalog Rector, zawierający konkretne klasy reguł, które można traktować jako wzorce do własnych implementacji.

Przykładowa wbudowana reguła Rectora: [https://github.com/rectorphp/rector/blob/7c8588008fc1e5e5e9434be3cd399ae21be337f3/rules/CodingStyle/Rector/ClassMethod/NewlineBeforeNewAssignSetRector.php](https://github.com/rectorphp/rector/blob/7c8588008fc1e5e5e9434be3cd399ae21be337f3/rules/CodingStyle/Rector/ClassMethod/NewlineBeforeNewAssignSetRector.php)

Analogiczna struktura występuje również w dedykowanym projekcie reguł dla PHPUnit (rector-phpunit).
Tam także reguły są pogrupowane w katalogu rules, a następnie w ramach odpowiedniego zestawu reguł (np. PHPUnit90) należy szukać podkatalogu Rector, który zawiera konkretne implementacje.

Przykład reguły z projektu rector-phpunit: [https://github.com/rectorphp/rector-phpunit/blob/a2e10b59880655fd19146cd53916efc993380b48/rules/PHPUnit90/Rector/MethodCall/ReplaceAtMethodWithDesiredMatcherRector.php](https://github.com/rectorphp/rector-phpunit/blob/a2e10b59880655fd19146cd53916efc993380b48/rules/PHPUnit90/Rector/MethodCall/ReplaceAtMethodWithDesiredMatcherRector.php)

```
<?php

declare(strict_types=1);

namespace app\infrastructure\Rector;

use PhpParser\Node;
use PhpParser\Node\Identifier;
use PhpParser\Node\NullableType;
use PhpParser\Node\Stmt\Class_;
use PhpParser\Node\UnionType;
use Rector\Rector\AbstractRector;

final class RepositoryMethodNameRuleRector extends AbstractRector
{
    /**
     * @return array<class-string<Node>>
     */
    public function getNodeTypes(): array
    {
        return [Class_::class];
    }

    /**
     * @param Class_ $node
     */
    public function refactor(Node $node): ?Node
    {
        if (!$node instanceof Class_) {
            return null;
        }

        $classFQCN = $this->getName($node);

        if (false === stripos($classFQCN, '\\repositories\\')) {
            return null;
        }

        foreach ($node->getMethods() as $method) {
            $returnType = $method->getReturnType();
            $methodName = $this->getName($method);

            if (null === $methodName || $methodName === 'get' || !str_starts_with($methodName, 'get')) {
                continue;
            }

            if ($returnType instanceof NullableType) {
                $method->returnType = $returnType->type;
            }

            if ($returnType instanceof UnionType) {
                $typesWithoutNull = [];
                foreach ($returnType->types as $type) {
                    if ($type instanceof Identifier && $type->toString() === 'null') {
                        continue;
                    }

                    $typesWithoutNull[] = $type;
                }

                if (count($typesWithoutNull) !== count($returnType->types)) {
                    // jeśli po usunięciu null został 1 typ => unwrap
                    if (count($typesWithoutNull) === 1) {
                        $method->returnType = $typesWithoutNull[0];
                    } else {
                        $method->returnType = new UnionType($typesWithoutNull);
                    }
                }
            }
        }

        return $node;
    }
}

```
#### Plik do testów

```
<?php

namespace myapp\repositories2 {
    class MyRepository {
        public function getSomethingCorrect(): \stdClass
        {
            return null;
        }

        public function getSomething(): ?\stdClass
        {
            return null;
        }

        public function getSomething2(): \stdClass|null
        {
            return null;
        }

        public function getSomething3(): \stdClass|null|string
        {
            return null;
        }

        public function getSomething4(): array|null|string
        {
            return null;
        }

        public function findEntries(): ?\stdClass
        {
            return null;
        }
    }
}

namespace myapp\repositories {
    class MyRepository {
        public function getSomethingCorrect(): \stdClass
        {
            return null;
        }

        public function getSomething(): ?\stdClass
        {
            return null;
        }

        public function getSomething2(): \stdClass|null
        {
            return null;
        }

        public function getSomething3(): \stdClass|null|string
        {
            return null;
        }

        public function getSomething4(): array|null|string
        {
            return null;
        }

        public function findEntries(): ?\stdClass
        {
            return null;
        }
    }
}

?>
-----
<?php

namespace myapp\repositories2 {
    class MyRepository {
        public function getSomethingCorrect(): \stdClass
        {
            return null;
        }

        public function getSomething(): ?\stdClass
        {
            return null;
        }

        public function getSomething2(): \stdClass|null
        {
            return null;
        }

        public function getSomething3(): \stdClass|null|string
        {
            return null;
        }

        public function getSomething4(): array|null|string
        {
            return null;
        }

        public function findEntries(): ?\stdClass
        {
            return null;
        }
    }
}

namespace myapp\repositories {
    class MyRepository {
        public function getSomethingCorrect(): \stdClass
        {
            return null;
        }

        public function getSomething(): \stdClass
        {
            return null;
        }

        public function getSomething2(): \stdClass
        {
            return null;
        }

        public function getSomething3(): \stdClass|string
        {
            return null;
        }

        public function getSomething4(): array|string
        {
            return null;
        }

        public function findEntries(): ?\stdClass
        {
            return null;
        }
    }
}

?>

```
