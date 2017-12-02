Yii2 - main local
=================

Konfiguracje komponentów w yii można nadpisywać poprzez plik main-local.php. Poniżej ustawienia, które często wprowadzam w projektach:

``` php
<?php

return [
    'components' => [
        'db' => [
            'class' => 'yii\db\Connection',
            'dsn' => 'mysql:host=127.0.0.1;dbname=DBNAME',
            'username' => 'DB_USERNAME',
            'password' => 'DB_PASSWORD',
            'charset' => 'utf8',
        ],
        'mailer' => [
            'class' => 'yii\swiftmailer\Mailer',
            'viewPath' => '@common/mail',
            // send all mails to a file by default. You have to set
            // 'useFileTransport' to false and configure a transport
            // for the mailer to send real emails.
            'useFileTransport' => true,
        ],
        'log' => [
            'flushInterval' => 1,
            'traceLevel' => YII_DEBUG ? 3 : 0,
            'targets' => [
                [
                    'class' => 'yii\log\FileTarget',
                    'levels' => ['error', 'warning', 'info', 'trace'],
                    'exportInterval' => 1
                ],
            ],
        ],
        'assetManager' => [
            // Instead of publishing assets by file copying, use symbolic links
            /** @see  http://www.yiiframework.com/doc-2.0/yii-web-assetmanager.html#$linkAssets-detail */
            'linkAssets' => true
        ],
    ]
];
```
