# yii2 - nadpisanie konfiguracji AssetBundle

Dodatkowe rozszerzenia yii2 jak np. alexantr/yii2-elfinder mogą zawierać AssetBundle.
W tym przypadku dołaczana jest zminimalizowana wersja pliku elfinder.
Taka wersja utrudnia śledzenie kodu i wyłapywanie błędów.

``` php
class ElFinderAsset extends AssetBundle
{
    public $sourcePath = '@vendor/studio-42/elfinder';
    public $css = [
        'css/elfinder.min.css',
        'css/theme.css',
    ];
    public $js = [
        'js/elfinder.min.js',
    ];
//....
```

Wczytywane pliki js przez `AssetBundle` można łatwo nadpisać w pliku `main-local.php`.
W tym pliku w kluczu `components` wstawiamy konfigurację podobną do poniższej:

``` php
//...
components' => [
    'assetManager' => [
        'bundles' => [
            \alexantr\elfinder\ElFinderAsset::class => [
                'js' => [
                    'js/elfinder.full.js'
                ],
            ]
        ],
    ],
//...
```


