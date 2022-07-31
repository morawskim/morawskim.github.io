# Symfony Messenger

## Konfiguracja

Wywołując polecenie `php bin/console debug:messenger` otrzymamy informacje o widocznych wiadomościach i obsługujących ich klasach. Za pomocą interfejsu `\Symfony\Component\Messenger\Handler\MessageHandlerInterface` oznaczamy naszą klasę jako handler. Implementując metodę `__invoke` jako parametr przekazujemy instancję klasy wiadomości. Na tej podstawie komponent wie, który handler należy wywołać dla wiadomości.

Konfigurując komponent messenger w frameworku Symfony w pliku `config/packages/messenger.yaml` ustalamy routing. Każdą klasę wiadomości możemy przekierować na odpowiedni transport np. `async`. Jednak mając kilkanaście klas wiadomości i kilka różnych mechanizmów transportu lepszym podejściem jest utworzenie tzw. `mark interface` np. `RouteToAsyncTransportInterface`. Każda klasa wiadomości, która implementuje ten interfejs zostanie przekazana do wybranego transportu. Jeśli klasa pasuje do wielu linii rutingu zostanie wysłana do każdego.

```
# route all messages that extend this example base class or interface
'App\Message\AbstractAsyncMessage': async
'App\Message\AsyncMessageInterface': async

'My\Message\ToBeSentToTwoSenders': [async, audit]
```

[Routing Messages to a Transport](https://symfony.com/doc/current/messenger.html#routing-messages-to-a-transport)


Aby podejrzeć aktualną konfigurację komponentu messenger wywołujemy polecenie `php bin/console config:dump framework messenger`. Za jej pomocą możemy zobaczyć [ustawienia odnośnie ponownych prób obsługi wiadomości](https://symfony.com/doc/current/messenger.html#retries-failures).

```
retry_strategy:
    # Service id to override the retry strategy entirely
    service:              null
    max_retries:          3

    # Time in ms to delay (or the initial value when multiplier is used)
    delay:                1000

    # If greater than 1, delay will grow exponentially for each retry: this delay = (delay * (multiple ^ retries))
    multiplier:           2

    # Max time in ms that a retry should ever be delayed (0 = infinite)
    max_delay:            0
```

Domyślnie wykorzystywana jest klasa `Symfony\Component\Messenger\Retry\MultiplierRetryStrategy` jako strategia do ponawiania. Bazuje ona na wzorze `delay = (delay * (multiple ^ retries))`. Możemy utworzyć własną strategię implementując interfejs `Symfony\Component\Messenger\Retry\RetryStrategyInterface`.

Konfiguracja dla kolejki wywołań webhook może wyglądać następująco:

```
retry_strategy:
    max_retries: 9
    # milliseconds delay
    delay: 300000
    max_delay: 86400000
    multiplier: 3
```

Da nam to następujący efekt:
```
Retry 1: 15 min
Retry 2: 45 min
Retry 3: 2 hours 15 min
Retry 4: 6 hours 45 min
Retry 5: 20 hours 15 min
Retry 6: 24 hours
Retry 7: 24 hours
Retry 8: 24 hours
Retry 9: 24 hours
```

## Standalone

Z komponentu możemy korzystać w dowolnym projekcie PHP. Punktem wejścia (entrypoint) jest interfejs `Symfony\Component\Messenger \MessageBusInterface`, który umożliwia nam przesłanie wiadomości do magistrali. Cała pracę związaną z przesłaniem wiadomości wykonują middlewares. Implementacje `MessageBusInterface` odpowiadają tylko za wywołanie kolejnych middlewerów. Jednym z najważniejszych middleware jest `SendMessageMiddleware`, który utrwala przesłaną wiadomość wykorzystując określony transport. Najprostsza implementacja transportu to `InMemoryTransport`, który jest wykorzystywany w testach jednostkowych. Prócz niego możemy przekazać wiadomość do Doctrine, RabbitMQ czy  Redis. Mając wiele możliwości utrwalenia wiadomości musimy powiązać wiadomość z kolejką. Interfejs `SendersLocatorInterface` wymaga utworzenia metody `getSenders`, która zwróci nam tablicę transportów dla wiadomości. Domyślna implementacja tego interfejsu - `SendersLocator` - oczekuje jako pierwszy parametr tablicę, gdzie klucz to nazwa klasy wiadomości (albo `*` jeśli dla każdej wiadomości chcemy wykorzystać dany transport), a wartość to tablica nazw transportów zarejestrowanych w ServiceContainer.

```
<?php

use Psr\Container\ContainerInterface;
use Symfony\Component\Messenger\MessageBus;
use Symfony\Component\Messenger\Middleware\SendMessageMiddleware;
use Symfony\Component\Messenger\Transport\InMemoryTransport;
use Symfony\Component\Messenger\Transport\Sender\SendersLocator;
use Symfony\Contracts\Service\ServiceLocatorTrait;

require_once __DIR__ . '/vendor/autoload.php';

$connection = DriverManager::getConnection(['url' => 'sqlite:///db.sqlite']);


$transport = new InMemoryTransport();
$container = new class([
    'memory' => function () use ($transport) {
        return $transport;
    }
]) implements ContainerInterface {
    use ServiceLocatorTrait;
};

$locator = new SendersLocator(['*' => ['memory']], $container);
$sendMessageMiddleware = new SendMessageMiddleware($locator);

$middlewareHandlers = [$sendMessageMiddleware];
$bus = new MessageBus($middlewareHandlers);

$message = new stdClass();
$bus->dispatch($message);
```

W pliku `Resources/config/messenger.xml` pakietu `symfony/framework-bundle` rejestrowane są domyślne middlewary komponentu Messenger. Domyślnie Rejestrowane są poniższe middlewary.

```
$defaultMiddleware = [
    'before' => [
        ['id' => 'add_bus_name_stamp_middleware'],
        ['id' => 'reject_redelivered_message_middleware'],
        ['id' => 'dispatch_after_current_bus'],
        ['id' => 'failed_message_processing_middleware'],
    ],
    'after' => [
        ['id' => 'send_message'],
        ['id' => 'handle_message'],
    ],
];
```

## Worker

### systemd
[Symfony Messenger systemd](https://jolicode.com/blog/symfony-messenger-systemd)

### docker-compose

```
worker:
    entrypoint: ["/path/to/your/app/bin/console", "messenger:consume", "--limit=100", "--time-limit=3600", "transport"]
    restart: unless-stopped
    # ...
```

### Supervisor

[Supervisor Configuration](https://symfony.com/doc/current/messenger.html#supervisor-configuration)

```
;/etc/supervisor/conf.d/messenger-worker.conf
[program:messenger-consume]
command=php /path/to/your/app/bin/console messenger:consume async --time-limit=3600
user=ubuntu
numprocs=1
startsecs=0
autostart=true
autorestart=true
process_name=%(program_name)s_%(process_num)02d

;stdout_logfile=/dev/stdout
;stdout_logfile_maxbytes=0
;stderr_logfile=/dev/stderr
;stderr_logfile_maxbytes=0
```

## DDD/CQRS

```
framework:
    messenger:
        default_bus: event.bus
        buses:
            command.bus:
                middleware:
                    - doctrine_transaction
            query.bus:
            event.bus:
                default_middleware: allow_no_handlers
```

Symfony umożliwia nam przekazanie do konstruktora odpowiedniego MessageBus na podstawie nazwy zmiennej i typu - np. `MessageBusInterface $commandBus`.
