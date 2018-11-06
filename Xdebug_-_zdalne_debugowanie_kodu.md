Xdebug - zdalne debugowanie kodu
================================

Na serwerze musimy mieć zainstalowany PHP wraz z rozszerzeniem Xdebug. Do pliku php.ini dodajemy minimalną konfigurację dla tego modułu:

```
[xdebug]
zend_extension=xdebug.so
xdebug.remote_enable=1
xdebug.remote_connect_back=0
xdebug.remote_host=127.0.0.1
xdebug.remote_port=9000
```

Na lokalnym hoście (tam gdzie odpalone jest środowisko programistyczne) wydajemy polecenie:

``` bash
ssh -R 9000:localhost:9000 username@hostname
```

Komenda ta tworzy tunel między naszym komputerem, a serwerem, W konfiguracji Xdebuga nasłuchujemy na połączenia tylko na lokalnym interfejsie, dlatego punkt początkowy tunelu to localhost i port 9000. Punkt końcowy tego tunelu to nasza maszyna. Jeśli chcemy debugować skrypty konsolowe to musimy wyeksportować na serwerze zmienną środowiskową:

``` bash
export XDEBUG_CONFIG="idekey=PHPSTORM"
```

Od tego momentu środowisko programistyczne (jeśli nasłuchuje na porcie 9000) pozwoli nam debugować kod.


## Konfiguracja xdebug dla maszyny vagrant
```
xdebug.remote_connect_back=0
xdebug.remote_enable=1
xdebug.remote_host=10.0.2.2
xdebug.remote_port=9000
```

## Docker, PHPStorm i debugowanie skryptu CLI

Jeśli chcemy debugować skrypty lub aplikacje CLI (np. testy jednostkowe) w PHPStorm to musimy na kontenerze ustawić zmienną środowiskową `PHP_IDE_CONFIG`. Najprościej jest to zrobić dodając taką zmienną do definicji kontenera PHP w pliku `docker-compose.yml`. Wartość tej zmiennej środowiskowej musi wskazywać nazwę serwera, którą nadaliśmy w opcjach PHPStorm (Settings / Preferences | Languages & Frameworks | PHP | Servers).
Więcej informacji:
https://confluence.jetbrains.com/display/PhpStorm/Debugging+PHP+CLI+scripts+with+PhpStorm

```
php:
environment:
- XDEBUG_CONFIG=remote_connect_back=0 remote_host=${XDEBUG_HOST}
- PHP_IDE_CONFIG=serverName=${SERVER_NAME}
```

W takim przypadku w pliku `.env` musimy mieć zdefiniowane zmienne `XDEBUG_HOST` i `SERVER_NAME`.
