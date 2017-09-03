Xdebug - zdalne debugowanie kodu
================================

Na serwerze musimy mieć zainstalowany PHP wraz z rozszerzeniem Xdebug. Do pliku php.ini dodajemy minimalną konfigurację dla tego modułu:

``` ini
[xdebug]
zend_extension=xdebug.so
xdebug.remote_enable=1
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