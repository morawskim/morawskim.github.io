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