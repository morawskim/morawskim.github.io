Composer pobieranie pakietu z git'a
===================================

Czasem jakaś biblioteka PHP może nie znajdować się w repozytorium packagist. Ciągle jednak możemy zarządzać instalacją biblioteki przez composera. Wystarczy dodać informacje o bibliotece do pliku composer.json naszego projektu.

``` javascript
...
"repositories": [
   {
      "type": "package",
      "package": {
         "name": "kalaspuff/redis-cache-zend-framework",
         "version": "0.1.0",
         "source": {
            "url":"https://github.com/kalaspuff/redis-cache-zend-framework.git",
            "type": "git",
            "reference":"65bdfa098abde74bc74c9a5d101daec8c9b01a97"
         },
         "autoload": {
            "files": [
               "Extended/Cache/Backend/Redis.php"
            ]
        }
      }
   }
],
...
"require": {
    ....
    "kalaspuff/redis-cache-zend-framework": "0.1.0"
}
```

## composer.json w repozytorium

Jeśli w repozytorium znajduje się plik `composer.json` to composer potrafi pobrać niezbędnę informacje z tego pliku.
W takim przypadku wystarczy prostrza konfiguracja repozytorium.
```
"repositories": [
    {
        "type": "git",
        "url": "https://github.com/morawskim/yii2-utils"
    }
],
```
Jeśli jest to wersja deweloperska, a my wymuszamy tylko instalację pakietów stabilnych możemy ominąc te ograniczenie dla jednego pakietu wywolując polecenie - `composer require mmo/yii2-utils:dev-master`
