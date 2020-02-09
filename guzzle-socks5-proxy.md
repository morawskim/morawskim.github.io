# Guzzle - socks5 proxy

W jednym z projektów musiałem pobrać informacje o kraju dla kilku tysięcy punktów POI.
Posiadałem ich współrzędne geograficzne, więc zdecydowałem się pobrać informacje o kraju z API `Nominatim`. Posiadam maszynę wirtualną z danymi dla kraju Polska (https://app.vagrantup.com/morawskim/boxes/nominatim-poland), jednak potrzebowałem globalnej wersji. Musiałem, więc skorzystać z publicznych serwerów, które mają limity requestów. Skorzystałem z serwerów proxy do pobrania tych danych szybciej.
Choć istnieje otwarte zgłoszenie z problemami z serwerami proxy SOCKS5 (https://github.com/guzzle/guzzle/issues/1484), ja korzystając z własnego serwera SOCKS5 nie miałem żadnych problemów. Gdy korzystałem z publicznych serwerów proxy (http://spys.one/en/socks-proxy-list/) pojawiały się timeouty i gubieniem pakietów. Prócz tych publicznych serwerów proxy, możemy także skorzystać z sieci TOR. Zbudowałem demo (https://github.com/morawskim/php-examples/tree/master/guzzle/socks5-proxy), gdzie w kontenerze docker'a działa klient tor.

Dodajemy parametr `proxy` do konfiguracji klienta guzzle, aby korzystać z serwera proxy.

```php
$response = $client->get('/', [
    'headers' => [
        'User-Agent' => 'curl/7.60.0',
    ],
    'proxy' => "socks5://${proxy}"
]);
```
