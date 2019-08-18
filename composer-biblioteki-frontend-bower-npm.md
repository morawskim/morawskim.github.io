# composer - biblioteki frontend (bower/npm)

## fxpio/composer-asset-plugin (deprecated)

Podczas instalacji frameworka `yii2` otrzymałem błąd:

```
yiisoft/yii2-bootstrap 2.0.6 requires bower-asset/bootstrap 3.3.* | 3.2.* | 3.1.* -> no matching package found.
```

Musimy globalnie zainstalować plugin composera `fxp/composer-asset-plugin`.
Wywołujemy więc polecenie:

`composer global require "fxp/composer-asset-plugin"`

Po zainstalowaniu globalnie tego pakietu, composer znajdzie wymagane biblioteki bower/npm.
Niestety ten plugin znacznie spowalnia działanie `composer update`.
Zaleca się korzystać z dodatkowego repozytorium z pakietami bower/npm dla composera, zamiast z tego pluginu.


## Repozytorium asset packagist

Podczas instalacji frameworka `yii2` otrzymałem błąd:

```
Installation request for yiisoft/yii2 ~2.0.25 -> satisfiable by yiisoft/yii2[2.0.25].
    - yiisoft/yii2 2.0.25 requires bower-asset/jquery 3.4.*@stable | 3.3.*@stable | 3.2.*@stable | 3.1.*@stable | 2.2.*@stable | 2.1.*@stable | 1.11.*@stable | 1.12.*@stable -> no matching package found.
```

Do pliku `composer.json` dodajemy:
``` json
"repositories": [
    {
        "type": "composer",
        "url": "https://asset-packagist.org"
    }
]
```

Te repozytorium zawiera najpopularniejsze pakiety npm/bower.
Dodatkowo nie spowalnia działania composera, tak jak robi to plugin `fxp/composer-asset-plugin`.

[https://asset-packagist.org/](https://asset-packagist.org/)
