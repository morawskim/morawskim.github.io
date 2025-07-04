## Yii2 testy jednostkowe snippets

```
<?php

namespace common\tests;

use PHPUnit\Framework\MockObject\Generator\Generator;
use PHPUnit\Framework\MockObject\MockObject;

class Yii2TestHelper
{
    /**
     * @template T of object
     * @param string|class-string<T> $className
     *
     * @return new<T>|T|MockObject
     */
    public static function createMock(string $className, array $methodsToMock, ?Generator $g = null)
    {
        $generator =  $g ?? new Generator();

        return $generator->testDouble(
            $className,
            true,
            $methodsToMock,
            callOriginalConstructor: false,
            callOriginalClone: false,
            cloneArguments: false,
            allowMockingUnknownTypes: false,
        );
    }
}

```
