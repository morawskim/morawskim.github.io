## Yii2 testy jednostkowe snippets

Domyślnie framework Yii2 wykorzystuje Codeception do testowania kodu.
Metoda `\Codeception\Lib\Connector\Yii2::startApp()` konfiguruje i uruchamia aplikację przed każdym testem.
Dzięki temu w testach możemy korzystać z `\Yii::$app` oraz `\Yii::$container`.

W przypadku, gdy nie korzystamy z Codeception (np. używamy czystego PHPUnit), możemy ręcznie inicjalizować aplikację za pomocą metody `createTestWebApp`.

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

    public static function createTestWebApp(array $config = [])
    {
        self::removeGlobalApp();
        $defaultConfig = [
            # .....
        ];

        new Application(array_merge($defaultConfig, $config));
    }

    public static function removeGlobalApp(): void
    {
        \Yii::$app = null;
        \Yii::$container = new \yii\di\Container();
    }
}

```




