# Symfony Twig

## Integracja

Instalując przez narzędzie Symfony Flex pakiet  `twig` zainstalowany zostanie pakiet `twig/twig`, ale także bundle `symfony/twig-bundle`. Ten bundle odpowiada za konfigurację i integrację Twig z Symfony.

Jeśli nie korzystamy z frameworka Symfony, możemy zainstalować `twig` i go skonfigurować. Wystarczy, że wywołamy polecenie `composer require "twig/twig:^3.0"`. Następnie tworzymy plik `index.php`  o zawartości:

``` php
<?php
require __DIR__ .'/vendor/autoload.php';

$loader = new \Twig\Loader\FilesystemLoader(__DIR__ . '/views');
$twig = new \Twig\Environment($loader, [
    'cache' => false,
]);

echo $twig->render('test.html.twig', ['name' => 'World']);
```

Wywołująć polecenie `php ./index.php` na wyjściu uzyskamy wygenerowany widok.
