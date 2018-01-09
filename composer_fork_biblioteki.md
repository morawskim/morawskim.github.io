# Composer - pobranie pakietu z lokalnego forku

Czasami musimy zmodyfikować kod pakietu, aby np. działał na innej wersji PHP.
Zanim nasza zmiana zostanie zintegrowana z projektem może zejść parę dni.
W takim przypadku możemy zrobić fork i w katalogu `vendor` zainstalować naszą wersję.

Plik `composer.json`

``` json
{
    "require": {
        "monolog/monolog": "dev-master"
    },
    "repositories": [
        {
            "type": "path",
            "url": "_patched/monolog"
        }
    ]
}
```

Musimy ustawić wersję pakietu na `dev-master`. Zgodnie z dokumentacją:
>If the package is a local VCS repository, the version may be inferred by the branch or tag that is currently checked out. Otherwise, the version should be explicitly defined in the package's composer.json file. If the version cannot be resolved by these means, it is assumed to be dev-master.

Po tych zmianach możemy wywołać `composer install` lub `composer update`.
``` bash
composer install
.....
- Installing monolog/monolog (dev-master)
Symlinked from _patched/monolog
...
```
W katalogu vendor został zainstalowany nasz pakiet biblioteki monolog.
``` bash
ls -la ./vendor/monolog/monolog
lrwxrwxrwx 1 marcin marcin 22 10-02 09:50 ./vendor/monolog/monolog -> ../../_patched/monolog
```
