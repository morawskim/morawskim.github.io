# doctrine/collections filtrowanie kolekcji wykorzystując własny operator

Pakiet `doctrine/collection` może być pomocny gdy mamy kolekcję obiektów DTO i chcemy je przefiltrować czy też posortować.
Choć filtrowanie i sortowanie po stronie PHP może być wolne to ciągle takie rozwiązanie może być lepsze niż wykonywanie bardzo dużej liczby zapytań do bazy danych.

Obecnie nie mamy możliwości rozbudowy/dodania własnych operatorów filtrowania.
Metoda [matching](https://github.com/doctrine/collections/blob/2.1.x/src/ArrayCollection.php#L457) w swojej definicji ma zaszytą nazwę klasy `ClosureExpressionVisitor`, która odpowiada za [filtrowanie danych](https://github.com/doctrine/collections/blob/2.1.x/src/Expr/ClosureExpressionVisitor.php#L124).

``` php
<?php

use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Criteria;
use Doctrine\Common\Collections\Expr\Comparison;

require_once __DIR__ . '/vendor/autoload.php';

$collection = new ArrayCollection([
    'wage' => [
        'name' => 'jwage',
        'address' => [
            'city' => 'Warszawa',
        ],
    ],
    'roman' => [
        'name' => 'romanb',
        'address' => [
            'city' => 'Poznań'
        ]
    ],
]);

$expr = new Comparison('address.city', '=', 'Poznań');
$criteria = new Criteria();
$criteria->where($expr);
$matchingCollection = $collection->matching($criteria);

var_dump($matchingCollection);

```

Chcąc dodać obsługę własnego operatora `=~`, który porównuje wartość ignorując wielkość znaków musimy utworzyć pomocniczą funkcję `matching`.

``` php
function matching(Collection $collection, Criteria $criteria): ReadableCollection {
    $visitor  = new class extends ClosureExpressionVisitor {
        public function walkComparison(Comparison $comparison)
        {
            $field = $comparison->getField();
            $value = $comparison->getValue()->getValue();

            if ($comparison->getOperator() === '=~') {
                return static fn ($object): bool => mb_strtolower(self::getObjectFieldValue($object, $field)) === mb_strtolower($value);
            }

            return parent::walkComparison($comparison);
        }

    };
    $filter   = $visitor->walkComparison($criteria->getWhereExpression());

    return $collection->filter($filter);
}
```

Następnie możemy przefiltrować naszą kolekcję wykorzystując utworzony operator `=~`

``` php
$expr = new Comparison('address.city', '=~', 'pOZnań');
$criteria = new Criteria();
$criteria->where($expr);

$matchingCollection = matching($collection, $criteria);
var_dump($matchingCollection);
```
