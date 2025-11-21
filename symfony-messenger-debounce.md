# symfony/messenger debounce

Komponent `symfony/messenger` używamy do asynchronicznej komunikacji w aplikacji, kolejkowania zadań oraz implementacji wzorca message bus.
Umożliwia konfigurację wielu transportów, dzięki czemu różne wiadomości mogą być wysyłane do różnych brokerów lub kolejek (np. RabbitMQ, Redis, Doctrine).

Messenger nie obsługuje jednak funkcji debounce.
W projekcie potrzebowaliśmy pobierać ostatnią wartość zadania z okresu 5 minut.
W związku z tym postanowiłem napisać własny transport, który na to pozwala. Całość oparłem na bazie MySQL.

Tworzymy tabelę, w której będziemy przechowywać zadania:

```
CREATE TABLE `debounce_job` (
  `key` varchar(48) NOT NULL,
  `created_at` datetime NOT NULL,
  `available_at` datetime NOT NULL,
  `delivered_at` datetime DEFAULT NULL,
  `queue_name` varchar(48) NOT NULL,
  `body` longtext NOT NULL,
  `headers` longtext NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

Następnie, bazując na kodzie publicznych transportów [doctrine](https://github.com/symfony/doctrine-messenger) oraz [sql-messenger](https://github.com/balpom/sql-messenger), budujemy własny transport. Tworzymy także własny "stempel" - `DebounceKeyStamp`

W moim przypadku metoda `send` klasy `Connection` powinna nadpisywać wiersz w tabeli korzystając z mechanizmu upsert, czyli:

```
ON DUPLICATE KEY UPDATE body=VALUES(body), available_at=VALUES(available_at), headers=VALUES(headers), delivered_at=null
```

## Problem z RetryListener

Jeśli chcemy nasz transport podłączyć do mechanizmu „ponawiacza” (`\Symfony\Component\Messenger\EventListener\SendFailedMessageForRetryListener`), pojawia się problem.
Messenger wysyła nową wiadomość, a starą usuwa.
Ponieważ mój transport nadpisywał dane w wierszu o tym samym kluczu, mechanizm retry nie działał poprawnie — wiadomość była kasowana po pierwszej nieudanej próbie wykonania.

Rozwiązałem ten problem, dodając do transportu metodę wywoływaną przez `EventDispatcher` w momencie wystąpienia zdarzenia `\Symfony\Component\Messenger\Event\WorkerMessageRetriedEvent`.
Metoda nasłuchuje zdarzenia ponownej próby przetworzenia wiadomości i zapamiętuje klucz debounce, aby później wiedzieć, że wiadomość została przekazana do ponownego wykonania.

```

class DebounceTransport implements TransportInterface
{
    # ...

    public function onWorkerMessageRetiredEvent(WorkerMessageRetriedEvent $event): void
    {
        $key = $event->getEnvelope()->last(DebounceKeyStamp::class)?->getKey();
        if ($key) {
            $this->redeliveryDebounceKeys[$key] = 1;
        }
    }

    # ...
```

W metodzie `reject` sprawdzam, czy envelope zawiera stempel `DebounceKeyStamp`.
Jeśli tak — weryfikuję, czy podczas zdarzenia `WorkerMessageRetriedEvent` dodaliśmy ten klucz do zestawu ignorowanych kluczy.
Jeśli kilka prób zawiedzie i finalnie zdarzenie `WorkerMessageRetriedEvent` nie zostanie wywołane, to klucz nie znajdzie się w zestawie ignorowanych, a wiadomość zostanie ostatecznie usunięta z bazy.

```

class DebounceTransport implements TransportInterface
{
    # ...

    public function reject(Envelope $envelope): void
    {
        $key = $envelope->last(DebounceKeyStamp::class)?->getKey();
        if (isset($this->redeliveryDebounceKeys[$key])) {
            unset($this->redeliveryDebounceKeys[$key]);
            return;
        }

        $this->getReceiver()->reject($envelope);
    }
```

[How to Create Your own Messenger Transport](https://symfony.com/doc/7.4/messenger/custom-transport.html)
