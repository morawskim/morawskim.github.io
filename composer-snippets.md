# composer - snippets

## composer show

Komenda `show` wyświetla listę wszystkich zainstalowanych pakietów z ich wersją i opisem.

```
anahkiasen/underscore-php 2.0.0 A redacted port of Underscore.js for PHP
barryvdh/laravel-debugbar v2.2.2 PHP Debugbar integration for Laravel
barryvdh/laravel-ide-helper v2.2.0 Laravel IDE Helper, generates correct PHPDocs for all Facade classes, to im...
barryvdh/reflection-docblock v2.0.4
classpreloader/classpreloader 3.0.0 Helps class loading performance by generating a single PHP file containing ...
cmgmyr/messenger 2.11 Simple user messaging tool for Laravel
dnoegel/php-xdg-base-dir 0.1 implementation of xdg base directory specification for php
doctrine/inflector v1.1.0 Common String Manipulations with regard to casing and singular/plural rules.
doctrine/instantiator 1.0.5 A small, lightweight utility to instantiate objects in PHP without invoking...
dompdf/dompdf v0.6.2 DOMPDF is a CSS 2.1 compliant HTML to PDF converter
..…
```
Dane możemy także wyświetlić w formie drzewa zależności. Wystarczy dodać flagę `-t`.
```
kalnoy/nestedset v4.1.3 Nested Set Model for Laravel 4-5
|--illuminate/database 5.2.*
|--illuminate/events 5.2.*
|--illuminate/support 5.2.*
`--php >=5.5.9
php-curl-class/php-curl-class 4.11.0 PHP Curl Class is an object-oriented wrapper of the PHP cURL extension.
|--ext-curl *
`--php >=5.3
intervention/image 2.3.7 Image handling and manipulation library with support for Laravel integration
|--ext-fileinfo *
|--guzzlehttp/psr7 ~1.1
| |--php >=5.4.0
| `--psr/http-message ~1.0
| `--php >=5.3.0
`--php >=5.4.0
...…
```

Możemy także wyświetlić szczegółowe informacje tylko dla wybranego pakietu - `composer show vendor/nazwapakietu`

```
name : guzzlehttp/psr7
descrip. : PSR-7 message implementation
keywords : http, message, stream, uri
versions : * 1.3.1
type : library
license : MIT License (MIT) (OSI approved) https://spdx.org/licenses/MIT.html#licenseText
source : [git] https://github.com/guzzle/psr7.git 5c6447c9df362e8f8093bda8f5d8873fe5c7f65b
dist : [zip] https://api.github.com/repos/guzzle/psr7/zipball/5c6447c9df362e8f8093bda8f5d8873fe5c7f65b 5c6447c9df362e8f8093bda8f5d8873fe5c7f65b
names : guzzlehttp/psr7, psr/http-message-implementation

autoload
psr-4
GuzzleHttp\Psr7\ => src/
files

requires
php >=5.4.0
psr/http-message ~1.0

requires (dev)
phpunit/phpunit ~4.0

provides
psr/http-message-implementation 1.0
```


## composer why

Wyświetla informacje, dlaczego dany pakiet został zainstalowany. Dzięki tej komendzie dowiemy się który pakiet go wymaga.

Ponownie możemy skorzystać z flagi `-t`, która spowoduje wyświetlenie danych w formie drzewa.

`composer why barryvdh/laravel-debugbar`

```
laravel/laravel dev-master requires barryvdh/laravel-debugbar (^2.1)
```


## composer why-not

Czasami nie możemy zainstalować lub zaktualizować jakiego pakietu ze wzgledu na zależności.
Komenda `why-not` pozwala nam się dowiedzieć, co blokuje zainstalowanie wybranego pakietu.
Podobnie i w tej komendzie możemy użyć widoku drzewa `-t`

`composer why-not phpunit/phpunit '8.0'`

```
laravel/laravel dev-master requires (for development) phpunit/phpunit (~4.0)
phpunit/phpunit 8.0.0 requires php (^7.2 but 7.1.28 is installed)
phpunit/phpunit 8.0.0 requires doctrine/instantiator (^1.1)
laravel/laravel dev-master does not require doctrine/instantiator (but 1.0.5 is installed)
phpunit/phpunit 8.0.0 requires phpspec/prophecy (^1.7)
laravel/laravel dev-master does not require phpspec/prophecy (but v1.6.1 is installed)
phpunit/phpunit 8.0.0 requires phpunit/php-code-coverage (^7.0)
laravel/laravel dev-master does not require phpunit/php-code-coverage (but 2.2.4 is installed)
phpunit/phpunit 8.0.0 requires phpunit/php-file-iterator (^2.0.1)
laravel/laravel dev-master does not require phpunit/php-file-iterator (but 1.4.1 is installed)
phpunit/phpunit 8.0.0 requires phpunit/php-timer (^2.0)
laravel/laravel dev-master does not require phpunit/php-timer (but 1.0.8 is installed)
phpunit/phpunit 8.0.0 requires sebastian/comparator (^3.0)
laravel/laravel dev-master does not require sebastian/comparator (but 1.2.0 is installed)
phpunit/phpunit 8.0.0 requires sebastian/diff (^3.0)
laravel/laravel dev-master does not require sebastian/diff (but 1.4.1 is installed)
phpunit/phpunit 8.0.0 requires sebastian/environment (^4.1)
laravel/laravel dev-master does not require sebastian/environment (but 1.3.7 is installed)
phpunit/phpunit 8.0.0 requires sebastian/exporter (^3.1)
laravel/laravel dev-master does not require sebastian/exporter (but 1.2.2 is installed)
phpunit/phpunit 8.0.0 requires sebastian/global-state (^3.0)
laravel/laravel dev-master does not require sebastian/global-state (but 1.1.1 is installed)
phpunit/phpunit 8.0.0 requires sebastian/version (^2.0.1)
laravel/laravel dev-master does not require sebastian/version (but 1.0.6 is installed)
```


## composer outdate

Zanim wywołamy polecenie `composer update` możemy przejrzeć które pakiety są przestarzałe i mają dostępne aktualizacje. Słuzy do tego właśnie komenda `outdate`.
Wyjście zostanie pokolorowane. Kolor zielony oznacza, że to najnowsza wersja. Żółty, że dostępna jest aktualizacja, ale może wprowadzać niekompatybilność wsteczną. Kolor czerwony oznacza  poprawkę, która powinna być wstecznie kompatybilna.

`composer outdate`

```
barryvdh/laravel-debugbar v2.2.2 v3.2.3 Package graham-campbell/htmlmin is abandoned, you should avoid using it. No replacement was suggested.
PHP Debugbar integration for Laravel
barryvdh/laravel-ide-helper v2.2.0 v2.6.2 Laravel IDE Helper, generates correct PHPDocs for all ...
barryvdh/reflection-docblock v2.0.4 v2.0.6
...
```

## Composer2

Jeśli nasz projekt wymaga composer w wersji 2 (wykorzystuje jedną z funkcji środowiska wykonawczego) to możemy dodać zależność do wirtualnego pakietu `composer-runtime-api` w wersji `^2.0`.
Ten pakiet zapewnia, że użytkownicy będą musieli używać Composera 2.x.


## Memory limit

`PHP Fatal error: Allowed memory size of XXXXXX bytes exhausted <...>` gdy zobaczymy taki komunikat możemy ustawić zmienną środowiskową `COMPOSER_MEMORY_LIMIT`, aby zwiększyć limit pamięci. Składnia jest taka sama jak w parametrze konfiguracyjnym `memory_limit` w PHP.

[Memory limit errors](https://getcomposer.org/doc/articles/troubleshooting.md#memory-limit-errors)

## Uwierzytelnianie

W środowiskach gdzie wielu programistów wywołuje polecenia `composer install/require/update` może dojść do przekroczenia limitu żądań.
W takim przypadku composer poprosi nas o podanie tokenu do API GitHub czy Bitbucket. Wywołując poniższe polecenia dane autoryzacyjne zostaną zapisane do pliku `~/.composer/auth.json`,
który następnie możemy podmontować do kontenera dockera.

`composer config --global github-oauth.github.com my-token`

`composer config --global bitbucket-oauth.bitbucket.org consumer-key consumer-secret`

Przykładowa zawartość pliku `~/.composer/auth.json`:

```
{
    "bitbucket-oauth": {
        "bitbucket.org": {
            "consumer-key": "consumer-key",
            "consumer-secret": "consumer-secret"
        }},
    "github-oauth": {
        "github.com": "my-token"},
    "gitlab-oauth": {},
    "gitlab-token": {},
    "http-basic": {},
    "bearer": {}
}
```

Innym rozwiązaniem jest utworzenie zmiennej środowiskowej `COMPOSER_AUTH`.
Zmienna ta przyjmuje taki sam obiekt JSON jak w pliku `auth.json` np. `{"github-oauth": {"github.com": "token"}}`.
W przypadku serwisu Bitbucket: `{"bitbucket-oauth":{"bitbucket.org":{"consumer-key":"2u...","consumer-secret":"7t..."}}}`

[Authentication for privately hosted packages and repositories](https://getcomposer.org/doc/articles/authentication-for-private-packages.md)
