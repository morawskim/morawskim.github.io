Apache - Ustawienie środowiska deweloperskiego dla aplikacji PHP
================================================================

Podczas tworzenia aplikacji PHP, chcemy wyświetlać stos wywołań funkcji na stronie błędów. Jednak te informacje chcemy ukryć na serwerze produkcyjnym. Możemy przekazać do aplikacji PHP zmienną środowiskową, która będzie włączać lub wyłączać tryb deweloperski aplikacji. Na serwerze produkcyjnym ta zmienna środowiskowa nie będzie ustawiona, więc tryb deweloperski nigdy się nie włączy. Do poprawnego działania, potrzebny jest włączony moduł [mod_env serwera Apache](http://httpd.apache.org/docs/2.2/mod/mod_env.html). Do konfiguracji VirtualHost'a dodajemy dyrektywę "SetEnv".

``` apache
 <VirtualHost *:80>
    ServerAdmin developer@morawskim.local
    DocumentRoot "/var/www/app.local"
    ServerName app-dev.local
    SetEnv APP_DEV 1
</VirtualHost>
```

W kodzie PHP możemy sprawdzić, czy zmienna środowiskowa APP_DEV istnieje. Jeśli jej wartość to true, to włączamy tryb deweloperski aplikacji. Przykład pliku index.php dla frameworka Yii2.

``` php
<?php
if (getenv('APP_DEV')) {
    defined('YII_DEBUG') or define('YII_DEBUG', true);
    defined('YII_ENV') or define('YII_ENV', 'dev');
}
require(__DIR__ . '/../vendor/autoload.php');
require(__DIR__ . '/../vendor/yiisoft/yii2/Yii.php');
$config = require(__DIR__ . '/../config/web.php');
(new yii\web\Application($config))->run();
```