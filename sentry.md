# Sentry

## Symfony

Instalujemy pakiet ` sentry/sentry-symfony` - `composer require sentry/sentry-symfony`.
Jeśli korzystamy z `symfony/flex` to zostanie włączony bundle `SentryBundle`, plik konfiguracyjny `config/packages/sentry.yaml` i zmienna środowiskowa `SENTRY_DSN`.
W przeciwnym przypadku będziemy musieli wykonać te kroki ręcznie.

Sprawdzamy z której wersji `symfony/monolog-bundle` korzystamy.

```
composer show | grep monolog
monolog/monolog                            1.26.0                             Sends your logs to files, sockets, inboxes, databases and various web services
symfony/monolog-bridge                     v4.4.20                            Provides integration for Monolog with various Symfony components
symfony/monolog-bundle                     v3.6.0                             Symfony MonologBundle
```

W przypadku wersji poniżej 3.7 do pliku konfiguracyjnego `config/packages/sentry.yaml` dodajemy:

```
monolog:
    handlers:
        sentry:
            type: service
            id: Sentry\Monolog\Handler

services:
    Sentry\Monolog\Handler:
        arguments:
            $hub: '@Sentry\State\HubInterface'
            $level: !php/const Monolog\Logger::ERROR
```

Nasza integracja między aplikacją Symfony, a Sentry jest gotowa. Wywołując polecenie ` ./bin/console sentry:test` testowa wiadomość zostanie wysłana do serwera Sentry i zapisana.

[Sentry for Symfony](https://docs.sentry.io/platforms/php/guides/symfony/)

### Performance

Aby monitorować wydajność fragmentu kodu, musimy w pliku konfiguracyjnym `config/packages/sentry.yaml` ustawić opcję 
klienta Sentry `traces_sample_rate` na wartość `1.0`. Wtedy każda próbka zostanie przesłana do Sentry.

```
sentry:
    options:
        traces_sample_rate: 1.0
```

W kluczu `options` możemy nadpisać domyślne parametry klienta Sentry. Do klasy `\Sentry\Options` zostaną przekazane wszystkie te ustawienia. Domyślne wartości dostępne są w metodzie `\Sentry\Options::configureOptions`.

### Breadcrumb

Obecnie domyślny handler dla monolog z pakietu `sentry/sentry-symfony` nie obsługuje breadcrumbs.
Istnieje nieoficialny handler z obsługą breadcrumb [monolog-sentry-handler](https://github.com/B-Galati/monolog-sentry-handler), ale nie jest on kompatybilny z nowym SDK Sentry.

[Option to add buffered (fingers_crossed) logs to context #286](https://github.com/getsentry/sentry-symfony/issues/286)
[add: breadcrumbs to monolog handler #844](https://github.com/getsentry/sentry-php/pull/844)
[Change default hook system to use Monolog #337](https://github.com/getsentry/sentry-symfony/issues/337)
