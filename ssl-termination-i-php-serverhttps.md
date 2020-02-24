# SSL termination i PHP $_SERVER['HTTPS']

Jeśli przed naszym serwerem HTTP znajduje się proxy, które ma za zadanie rozszyfrowanie ruchu SSL to w PHP w zmiennej serwerowej `$_SERVER['HTTPS']` nie będzie informacji o tym, że połaczenie było szyfrowane.

W przypadku projektu, który "na sztywno" sprawdza wartość tej zmiennej, możemy ten problem roziwązać przez ustawienie tej zmiennej przez serwer HTTP Apache.

W tym przypadku bazując na wartości nagłówka `X-Forwarded-SSL` ustawiania jest zmienna serwera PHP `$_SERVER['HTTPS']` na wartośc `on`.
```
RewriteEngine on
RewriteCond %{HTTP:X-Forwarded-SSL} ^on$
RewriteRule (.*) - [E=HTTPS:on]
```

## Trusted proxy server

Większość frameworków PHP, poprawnie określa czy połączenie było nawiązane przez protokół `https` bazując na nagłówku `X-Forwarded-Proto`. Jednak wymagana jest konfiguracja zaufanych serwerów. Jeśli połączenie przyszło z tego serwera, to będą interpretowane pewne nagłówki. W efekcie nasz framework będzie świadom, że połączenie nawiązano przez protokół `https`. W przypadku frameworka Yii2 musimy dodać do konfiguracji komponentu `request` parametr `trustedHosts`.

``` php
return [
    'id' => 'app-frontend',
    'language' => 'pl-PL',
    'name' => 'SSOrder',
    'basePath' => dirname(__DIR__),
    // ...
    'components' => [
        'request' => [
            // ...
            'trustedHosts' => ['10.0.0.0/24'],
        ],
        // ...
    ],
    'params' => $params,
];
```
