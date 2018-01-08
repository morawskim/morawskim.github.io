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

