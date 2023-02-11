# PHP programowanie funkcyjne

Biblioteka [lstrojny/functional-php](https://github.com/lstrojny/functional-php)

## Cartesian

Kod funkcji pobrany od użytkownika jwage [https://gist.github.com/jwage/11193216](https://gist.github.com/jwage/11193216)


``` php
function cartesian(array $set) {
    if (!$set) {
        return [[]];
    }

    $subset = array_shift($set);
    $cartesianSubset = cartesian($set);

    $result = [];
    foreach ($subset as $value) {
        foreach ($cartesianSubset as $p) {
            array_unshift($p, $value);
            $result[] = $p;
        }
    }

    return $result;
}

class CartesianTest extends TestCase
{
    /**
     * @dataProvider data
     */
    public function testCartesian(array $attributes, array $expectedCartesian): void
    {
        $this->assertEquals($expectedCartesian, cartesian($attributes));
    }

    public function data(): iterable
    {
        yield 'set_one' => [
            [[1,2], ['a', 'b']],
            [[1, 'a'], [1, 'b'], [2, 'a'], [2, 'b']]
        ];
    }
}

```

## Flatten

``` php
class FlattenTest extends TestCase
{
    /**
     * @dataProvider provideArrayToFlatten
     */
    public function testFlatten(array $nestedArray, array $expectedFlatArray): void
    {
        $flatten = static function (array $array) {
            $return = [];
            array_walk_recursive($array, static function ($v) use (&$return) {
                $return[] = $v;
            });

            return $return;
        };

        $this->assertEquals($expectedFlatArray, $flatten($nestedArray));
    }

    /**
     * @dataProvider provideArrayToFlatten
     */
    public function testFlattenIterator(array $nestedArray, array $expectedFlatArray): void
    {
        $iterator = new \RecursiveIteratorIterator(
            new class ($nestedArray) extends \RecursiveArrayIterator {
                public function hasChildren(): bool
                {
                    return is_array($this->current());
                }
            }
        );
        $data = iterator_to_array($iterator, false);

        $this->assertEquals($expectedFlatArray, $data);
    }

    public function provideArrayToFlatten(): iterable
    {
        yield 'nested_array' => [
            ['a', 'b', ['c', 'd', 'e', ['f', 'g'], 'h', 'i'], 'j', 'k', ],
            ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', ],
        ];

        yield 'nested_array_of_objects' => [
            [
                new ValueObject('a'),
                new ValueObject('b'),
                [
                    new ValueObject('c'),
                    new ValueObject('d'),
                    new ValueObject('e'),
                    [
                        new ValueObject('f'),
                        new ValueObject('g'),
                    ],
                    new ValueObject('h'),
                    new ValueObject('i'),
                ],
                new ValueObject('j'),
                new ValueObject('k')
            ],
            [
                new ValueObject('a'),
                new ValueObject('b'),
                new ValueObject('c'),
                new ValueObject('d'),
                new ValueObject('e'),
                new ValueObject('f'),
                new ValueObject('g'),
                new ValueObject('h'),
                new ValueObject('i'),
                new ValueObject('j'),
                new ValueObject('k'),
            ],
        ];

        yield 'mixed' => [
            [
                new ValueObject('a'),
                new ValueObject('b'),
                [
                    new ValueObject('c'),
                    new ValueObject('d'),
                    new ValueObject('e'),
                    [
                        new ValueObject([1,2,3]),
                        new ValueObject(['f', 'g']),
                    ],
                    new ValueObject('h'),
                    new ValueObject('i'),
                ],
                new ValueObject('j'),
                new ValueObject('k')
            ],
            [
                new ValueObject('a'),
                new ValueObject('b'),
                new ValueObject('c'),
                new ValueObject('d'),
                new ValueObject('e'),
                new ValueObject([1,2,3]),
                new ValueObject(['f', 'g']),
                new ValueObject('h'),
                new ValueObject('i'),
                new ValueObject('j'),
                new ValueObject('k'),
            ],
        ];
    }
}

```
