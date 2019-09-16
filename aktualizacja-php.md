# Aktualizacja PHP

W pliku `composer.json` ustawiłem nową wymaganą wersję PHP.
```
"require": {
    "php": ">=7.3.0",
    ...
```

Zmodyfikowałem także  ustawienia emulowanej platformy.
```
"config": {
    "platform": {
        "php": "7.3"
    }
},
```

Miałem zainstalowany pakiet `phpcompatibility/php-compatibility`, który nie zgłaszał żadnych problemów z kompatybilnością z wersją 7.3.

Uruchomiłem lint `jakub-onderka/php-parallel-lint` sprawdzający poprawność kodu. Ten test również nie zgłaszał żadnych problemów.

Następnie sprawdziłem kod przez `phpstan` i `phpstan/phpstan-deprecation-rules`.
W tym przypadku dostałem błędy:
`Fatal error: Cannot use yii\base\Object as Object because 'Object' is a special class name in ...`

Poprawiłem je. Framework `YII2` dostarcza klasę `BaseObject` dla PHP >= 7.2.

Finalnie odpaliłem dostępne testy integracyjne postman, jednostkowe, a także e2e.

W przypadku testów jednostkowych pomimo, że wszystkie testy wykonały się poprawnie kod wyjściowy procesu wynosił `255`.

Musiałem podłączyć się xdebug’em, aby zobaczyć co się dzieje - `PHP_IDE_CONFIG=serverName=<domena.lvh.me>  php -d xdebug.remote_host=<MOJ_IP> -d xdebug.remote_autostart=1 -d xdebug.remote_enable=1 ../vendor/bin/codecept run unit`

Linia `vendor/symfony/console/Application.php:186` wyglądała następująco `exit($exitCode);`.
Zmienna `exitCode` miała wartość 0. Jednak sprawdzając kod wynikowy ostatniego procesu w bash otrzymywałem `255`. W PHP możemy zarejestrować funkcję (przez `register_shutdown_function`), która będzie się uruchamiać podczas "zamykania procesu PHP". Jedna z zarejestrowanych funkcji rzucała wyjątkiem:
```
PHP Fatal error: Uncaught Error: Call to a member function getRequest() on null in /app/vendor/yiisoft/yii2-debug/src/panels/RequestPanel.php on line 59
```

W PHPStorm w debug a następnie output mogłem zobaczyć ten wyjątek. Dzięki temu wiedziałem już, dlaczego dostaje kod 255 zamiast 0. Błąd powstał poprzez ustawienie środowiska `dev` zamiast `test`. W przypadku środowiska `test` nie włączany jest moduł `yii2-debug`. Zmiana wartości stałej `YII_ENV` rozwiązał problem. A aplikacja działała na nowej wersji PHP.

