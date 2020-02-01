# Composer - pobranie pakietu z lokalnego forku, gdy jest dodawany przez inny pakiet

Jeśli chcemy nadpisać pakiet `ezyang/htmlpurifier`, który jest wymagany przez `yiisoft/yii2`, musimy dodać repozytorium. A także skorzystać z tzw. inline alias.

Plik `composer.json`

``` json
{
    "minimum-stability": "stable",
    "repositories": [
        {
            "type": "path",
            "url": "_patched/htmlpurifier"
        }
    ],
    "require": {
        "yiisoft/yii2": "~2.0.11.2",
        "ezyang/htmlpurifier": "dev-master as v4.6.0"
    }
}

```

W sekcji `require` dodajemy jawnie pakiet, który chcemy nadpisać z lokalnej ścieżki.
W wersji musimy skorzystać z inline alias (https://getcomposer.org/doc/articles/aliases.md#require-inline-alias).


Musimy ustawić wersję pakietu na `dev-master`. Zgodnie z dokumentacją:
>If the package is a local VCS repository, the version may be inferred by the branch or tag that is currently checked out. Otherwise, the version should be explicitly defined in the package's composer.json file. If the version cannot be resolved by these means, it is assumed to be dev-master.

Jako alias dajemy v.4.6.0, ponieważ biblioteka `yiisoft/yii2` dopuszcza wersję `~4.6`. Composer wymaga podania pełnej wersji. Nie możemy podać w aliasie wersji '~4.6'. Jeśli nasz fork jest z wersji 4.6.0 to taką wersję podajemy w aliasie.

Po tych zmianach możemy wywołać `composer install` lub `composer update`.
``` bash
composer update
.....
- Removing ezyang/htmlpurifier (v4.9.3)
- Installing ezyang/htmlpurifier (dev-master)
Symlinked from _patched/htmlpurifier
...
```

W katalogu vendor został zainstalowany nasz pakiet biblioteki htmlpurifier
``` bash
ls -la ./vendor/ezyang/htmlpurifier
lrwxrwxrwx 1 marcin marcin 27 10-02 11:53 ./vendor/ezyang/htmlpurifier -> ../../_patched/htmlpurifier
```

## fzaninotto/faker

Biblioteka `faker` pozwala nam pobrać z serwisu lorempixel obrazki. Jednak od pewnego czasu usługa ta jest niedostępna (https://github.com/fzaninotto/Faker/issues/1884). Postanowiłem napisać provider do usługi picsum.

Na githubie utworzyłem fork repozytorium `https://github.com/fzaninotto/Faker`. Następnie w pliku `composer.json` w kluczu `repositories` dodałem kolejny element tablicy:
``` json
{
    "type": "git",
    "url": "https://github.com/morawskim/Faker"
}
```

Nowy provider opublikowałem w gałęzi `picsum`.
Wywołałem polecenie `composer require --dev fzaninotto/faker:dev-picsum` w celu zainstalowania mojej wersji biblioteki `fzaninotto/faker`. Jednak dostałem błąd:
```
Updating dependencies (including require-dev)
Your requirements could not be resolved to an installable set of packages.

  Problem 1
    - yiisoft/yii2-faker 2.0.4 requires fzaninotto/faker ~1.4 -> satisfiable by fzaninotto/faker[1.9.x-dev].
    - yiisoft/yii2-faker 2.0.4 requires fzaninotto/faker ~1.4 -> satisfiable by fzaninotto/faker[1.9.x-dev].
    - yiisoft/yii2-faker 2.0.4 requires fzaninotto/faker ~1.4 -> satisfiable by fzaninotto/faker[1.9.x-dev].
    - Can only install one of: fzaninotto/faker[1.9.x-dev, dev-picsum].
    - Can only install one of: fzaninotto/faker[dev-picsum, 1.9.x-dev].
    - Installation request for fzaninotto/faker dev-picsum -> satisfiable by fzaninotto/faker[dev-picsum].
    - Installation request for yiisoft/yii2-faker (locked at 2.0.4, required as ~2.0.0) -> satisfiable by yiisoft/yii2-faker[2.0.4].


Installation failed, reverting ./composer.json to its original content.
```

Wywołałem więc polecenie `composer why-not fzaninotto/faker:dev-picsum`, aby przekonać się, że problem jest z wersją biblioteki.

Otrzymałem wynik:
```
yiisoft/yii2-faker  2.0.4  requires  fzaninotto/faker (~1.4)
```

Musiałem więc ustawić alias na wersję podczas instalacji pakietu - `composer require --dev 'fzaninotto/faker:dev-picsum as v1.8.0'`
```
    1/1:        http://repo.packagist.org/p/provider-latest$0d293edf76995ac9b223743b1eb1f627309bda3ee3baa7e5d4735c6fa246f4aa.json
    Finished: success: 1, skipped: 0, failure: 0, total: 1                            ./composer.json has been updated
Loading composer repositories with package information                                    Updating dependencies (including require-dev)
Package operations: 0 installs, 1 update, 0 removals
  - Removing fzaninotto/faker (v1.8.0)
  - Installing fzaninotto/faker (dev-picsum 38d1489): Cloning 38d1489792 from cache
Package spomky-labs/jose is abandoned, you should avoid using it. Use web-token/jwt-framework instead.
Writing lock file
Generating autoload files
ocramius/package-versions: Generating version class...
ocramius/package-versions: ...done generating version class
```

Sprawdziłem tylko jeszcze czy faktycznie moja wersja pakietu została zainstalowana, poprzez wywołanie polecenia `composer show | grep faker`. Dostałem wynik:
```
fzaninotto/faker                      dev-picsum 38d1489 Faker is a PHP library that generates fake data for you.
yiisoft/yii2-faker                    2.0.4              Fixture generator. The Faker integration for the Yii framework.
```

Przed instalacją mojej wersji pakietu miałem taką wersję:
```
fzaninotto/faker                      v1.8.0             Faker is a PHP library that generates fake data for you.
yiisoft/yii2-faker                    2.0.4              Fixture generator. The Faker integration for the Yii framework.
```
