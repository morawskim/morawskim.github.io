Npm - główny katalog instalacyjny pakietów
==========================================

Podczas konfiguracji PHPStorm z stylelint, musiałem podać ścieżkę do pakietu. Stylelint instalowałem globalnie, więc nie wiedziałem, gdzie został zainstalowany.
Aby sprawdzić, gdzie npm instaluje pakiety wywołałem polecenie:

``` bash
npm root -g
/usr/local/lib/node_modules
```
