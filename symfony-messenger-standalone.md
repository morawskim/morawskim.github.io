# symfony/messenger standalone

Ta notatka rozszerza wcześniejszy opis użycia [symfony/messenger](symfony-messenger.md#Standalone) w projektach nieopartych o pełny framework Symfony, czyli w trybie standalone.

W tym przykładzie integrujemy symfony/messenger z RabbitMQ (AMQP), wykorzystując dodatkowe funkcje, takie jak DLQ (Dead Letter Queue) czy wykładnicze ponawianie.

Najpierw należy zainstalować rozszerzenie PHP amqp: `pecl install amqp`.
Wymaga ono pakietu systemowego librabbitmq-dev (lub podobnego w zależności od dystrybucji).

Następnie instalujemy wymagane paczki PHP: `compsoer require symfony/messenger symfony/amqp-messenger`

Dodajemy usługę RabbitMQ do docker-compose.yml:
```
services:
  rabbitmq:
    image: rabbitmq:4.1-management
    restart: unless-stopped
    ports:
#      - "5672:5672"
      - "15672:15672"
      - "15692:15692"
    environment:
      RABBITMQ_DEFAULT_USER: admin
      RABBITMQ_DEFAULT_PASS: secretpassword
```

Tworzemy transporty AMQP

```
$dsn = 'amqp://admin:secretpassword@rabbitmq:5672/%2f/messages';
$dsnFailed = 'amqp://admin:secretpassword@rabbitmq:5672/%2f/messages_failed';

$factory = new Symfony\Component\Messenger\Bridge\Amqp\Transport\AmqpTransportFactory();

$transport  = $factory->createTransport(
    $dsn,
    [],
    new Symfony\Component\Messenger\Transport\Serialization\PhpSerializer()
);
$transportFailed = $factory->createTransport(
    $dsnFailed,
    [],
    new Symfony\Component\Messenger\Transport\Serialization\PhpSerializer()
);
```

Następnie ServiceLocator

```
$senderServiceLocator = new class(['async' => fn () => $transport]) implements \Psr\Container\ContainerInterface {
        use \Symfony\Contracts\Service\ServiceLocatorTrait;
    };
};

$retryStrategyServiceLocator = new class(['async' => fn () => new \Symfony\Component\Messenger\Retry\MultiplierRetryStrategy(3, 60000, 3, 300000, 0.1)]) implements \Psr\Container\ContainerInterface {
        use \Symfony\Contracts\Service\ServiceLocatorTrait;
    };
};

```

Finalnie możemy utworzyć MessageBus:

```
$handler = new \app\foo\Messenger\TestHandler();

$messageBus = new \Symfony\Component\Messenger\MessageBus([
    new \Symfony\Component\Messenger\Middleware\RejectRedeliveredMessageMiddleware(),
    new \Symfony\Component\Messenger\Middleware\DispatchAfterCurrentBusMiddleware(),
    new \Symfony\Component\Messenger\Middleware\FailedMessageProcessingMiddleware(),
    new \Symfony\Component\Messenger\Middleware\SendMessageMiddleware(new \Symfony\Component\Messenger\Transport\Sender\SendersLocator(
        [
            \app\foo\Messenger\TestMessage::class => ['async'],
        ],
        $senderServiceLocator,
    )),
    new \Symfony\Component\Messenger\Middleware\HandleMessageMiddleware(new \Symfony\Component\Messenger\Handler\HandlersLocator([
        \app\foo\Messenger\TestMessage::class => [$handler],
    ])),
]);
```

Przykładowy kod wysyłający testową wiadomość:

```
$messageBus->dispatch(
    new TestMessage('Test message ' . date('Y-m-d H:i:s')),
    [new DelayStamp(10)]
);
```

Do odbierania wiadomości z kolejki potrzebujemy workera (consumera).

```
$logger = .... //psr3 logger
$messageBus = ....
$transport = ...
$eventDispatcher = new EventDispatcher();

// Obsługa sygnałów systemowych
if (\defined('SIGINT') && SignalRegistry::isSupported()) {
    $signalRegistry = new SignalRegistry();
    foreach ([\SIGINT, \SIGTERM, \SIGUSR1, \SIGUSR2] as $signal) {
        $signalRegistry->register($signal, function ($signal) use ($logger) {
            $logger->info(sprintf('Received signal %s. Stopping worker if running....', $signal));
            if (isset($this->worker)) {
                $this->worker->stop();
            }
        });
    }
}

// Listener’y i limity
$eventDispatcher->addSubscriber(new StopWorkerOnMessageLimitListener(50, $logger));
$eventDispatcher->addSubscriber(new StopWorkerOnTimeLimitListener(3600, $logger));
$eventDispatcher->addSubscriber(new SendFailedMessageForRetryListener(
    $senderServiceLocator,
    $retryStrategyServiceLocator,
    $logger,
    $eventDispatcher,
));
$eventDispatcher->addSubscriber(new \Symfony\Component\Messenger\EventListener\SendFailedMessageToFailureTransportListener(new class(['async' => static fn () => $failureTransport]) implements \Psr\Container\ContainerInterface {
    use \Symfony\Contracts\Service\ServiceLocatorTrait;
}));
$receivers = [
    'async' => $transport,
];
$this->worker = new Worker($receivers, $bus, $eventDispatcher, $logger, null);
$options = [
    'sleep' => 1 * 1000000,
];

try {
    $this->worker->run($options);
} finally {
    $this->worker = null;
}
```
