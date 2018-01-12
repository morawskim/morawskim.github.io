# composer - instalacja pakietu z kanału pear

W starych projektach ciągle mogą być wykorzystywane pakiety `pear`.
Do ich pobrania trzeba zainstalować i skonfigurować pear package manager (https://pear.php.net/manual/en/installation.getting.php). Na szczęście composer tez może pobrać pakiety pear (wymagana wersja 1.3.3).

Do pliku `composer.json` dodajemy repozytorium pear. W sekcji `require` dodajemy wymagane pakiety pear.
```
{
    "repositories": [
        {
            "type": "pear",
            "url": "https://pear.php.net"
        }
    ],
    "require": {
        "pear-pear.php.net/VersionControl_Git": "0.5@dev",
        "pear-pear.php.net/pear": "^1.1"
    }
}
```
Po wywołaniu polecenia `composer install` pakiet pear `VersionControl_Git` zostanie zainstalowany.
``` php
<?php

require_once __DIR__ . '/vendor/autoload.php';
var_dump(class_exists('VersionControl_Git'));
```
Więcej informacji:
* https://getcomposer.org/doc/05-repositories.md#pear
* https://github.com/composer/composer/issues/5069
* https://github.com/composer/composer/issues/6193