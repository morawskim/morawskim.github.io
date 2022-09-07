# Behat

## Rozszerzenia

| Extension  | Description  |
|---|---|
| [adamquaile/behat-command-runner-extension](https://github.com/adamquaile/behat-command-runner-extension)  | Extension to run commands at hooks in test lifecycle   |

## SymfonyExtension i .env.test

Pakiet "friends-of-behat/symfony-extension" obecnie nie wczytuje zmiennych środowiskowych zdefiniowanych w pliku `.env` czy `.env.test`.
Istnieją otwarte zgłoszenia [Support .env.test](https://github.com/Behat/Symfony2Extension/issues/146) czy też [Environment variable not found since symfony 5.1](https://github.com/FriendsOfBehat/SymfonyExtension/issues/126) i tymczasowe rozwiązania tego problemu.

Mając zainstalowany pakiet "symfony/phpunit-bridge" możemy wykorzystać [plik bootstrap.php](https://github.com/symfony/recipes/blob/main/symfony/phpunit-bridge/5.3/tests/bootstrap.php), który jest automatycznie tworzymy podczas instalacji przez flex.

W przeciwnym przypadku tworzymy własny plik bootstrap.php (w moim przypadku w katalogu "tests/Behat"). Ma to duże znaczenie, gdzie go tworzymy bo musimy odpowiednio dostosować ścieżkę do pliku `.env`. Wybierając ten katalog musimy także zmodyfikować plik "config/services_test.yaml".

```
// tests/Behat/bootstrap.php

<?php

(new Symfony\Component\Dotenv\Dotenv())->bootEnv(dirname(__DIR__, 2).'/.env');
```

W pliku `behat.yml.dist` dodajemy parametr bootstrap do rozszerzenia `FriendsOfBehat\SymfonyExtension`:

```
default:
    # ...
    extensions:
        FriendsOfBehat\SymfonyExtension:
            bootstrap: tests/Behat/bootstrap.php
```

Ponieważ plik bootstrap znajduje się w katalogu w którym Symfony oczekuje usług musimy go wykluczyć.
W pliku `config/services_test.yaml` odnajdujemy definicję dla usług z przestrzeni nazw `App\Tests\Behat` i dodajemy parametr "exclude":

```
services:
    # ...
    App\Tests\Behat\:
        resource: '../tests/Behat/*'
        exclude: '../tests/Behat/bootstrap.php'

```
