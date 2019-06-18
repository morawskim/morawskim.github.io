# yii2 - snippets

## Oddzielny plik z logiem

Do konfiguracji komponentu `log` dodajemy nowy target.
Ponieważ jest to kolejka zadań, a yii nie flushuje wpisów ustawiłem jeszcze dwa parametry `flushInterval` i `exportInterval`. Dzięki temu wpisy do loga będą zapisywane od razu. A nie w buforze (1000 wpisów) lub na koniec działania procesu.

```
...
'log' => [
    'flushInterval' => 1,
    'targets' => [
        [
            'class' => 'yii\log\FileTarget',
            'levels' => ['error', 'warning'],
        ],
        'gearman' => [
            'class' => 'yii\log\FileTarget',
            'categories' => [\common\jobs\JobBase::LOG_CATEGORY],
            'levels' => ['error', 'warning', 'info', 'trace'],
            'logFile' => '@runtime/logs/gearman.log',
            'exportInterval' => 1
        ],
    ],
],
...
```

## Domyślny kontroler modułu

W pliku `[MODUL]/config/main.php` ustawiamy klucz `defaultRoute`.
Zgodnie z dokumentacją:
> the default route of this module. Defaults to `default`.
 * The route may consist of child module ID, controller ID, and/or action ID.
 * For example, `help`, `post/create`, `admin/post/create`.
 * If action ID is not given, it will take the default value as specified in
 * [[Controller::defaultAction]].

Ustawienie tego klucza, powoduje nadpisaniw właściwości `defaultRoute` w klasie `\yii\web\Application` dla aplikacji web. Albo w klasie `\yii\console\Application` dla aplikacji konsolowej.
```
return [
...
    'defaultRoute' => 'proxy',
...
```

## Yii2 - DI definicje w main.php

```
return [
    'id' => 'app-frontend',
    'basePath' => dirname(__DIR__),
    'bootstrap' => ['log'],
    'controllerNamespace' => 'frontend\controllers',
    'sourceLanguage' => 'en_GB',
    'container' => [
        'definitions' => [
            yii\grid\GridView::class => [
                'tableOptions' => [
                    'class' => 'table table-condensed table-striped table-hover',
                ],
                'pager' => [
                    'class' => 'justinvoelker\separatedpager\LinkPager',
                ],
            ],
        ],
    ],
    'components' => [
....
```

## Konfiguracja modułu usługi REST - wyłączenie CSRF i sesji

W klasie modułu w metodzie `init` wyłączamy sesję i weryfikację tokenów CSRF.
Dzięki temu, w response nie będziemy dostawać nagłówków `Set-Cookie`.

``` php
public function init()
{
    parent::init();
    \Yii::$app->user->enableSession = false;
    \Yii::$app->request->enableCsrfCookie = false;
}
```
