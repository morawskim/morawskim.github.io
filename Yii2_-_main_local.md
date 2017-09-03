Yii2 - main local
=================

Konfiguracje komponentów w yii można nadpisywać poprzez plik main-local.php. Poniżej ustawienia, które często wprowadzam w projektach:

``` php
<?php

return [
    'components' => [
        'assetManager' => [
            /** @see  http://www.yiiframework.com/doc-2.0/yii-web-assetmanager.html#$linkAssets-detail */
            'linkAssets' => true
        ]
    ]
];
```