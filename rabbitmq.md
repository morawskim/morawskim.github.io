# RabbitMQ

## Exchange

Odbiera wiadomości wysłane do RabbitMQ i określa, gdzie je wysłać (do których kolejek). Pełni rolę routingu wiadomości na podstawie atrybutów przekazanych wraz z wiadomością. Protokół AMPQ definiuje cztery rodzaje exchange, a każdy rodzaj traktuje "routing key" w inny sposób:
* Direct
* Fanout
* Topic
* Headers

Dodatkowo mamy także `exchange-to-echange` ale jest to specyficzna funkcja RabbitMQ i protokół AMPQ nie definiuje tego typu.

## Kolejka (ang. Queue)

Atrybut `durable` oznacza czy definicja kolejki przetrwa reset serwera czy nie. Nie ma nic wspólnego z przechowywaniem wiadomości.

Kolejki są niemodyfikowalne (immutable) - nie możemy zmieniać ich konfiguracji po utworzeniu.
Chcąc je zmienić, musimy ją skasować i zadeklarować raz jeszcze.

## Wiadomość (ang. Message)

Domyślnie kiedy publikujemy wiadomość, która nie może zostać dostarczona do żadnej kolejki (ze względu na brak powiązania między exchange a kolejką) zostanie po cichu porzucona. Aby się przed tym zabezpieczyć musimy ustawić atrybut `mandatory` na wartość `true`.

Atrybut `delivery-mode` określa czy wiadomość zostanie zapisana w pamięci RAM, czy na dysku.

Atrybut `expiration` powoduje że wiadomość może automatycznie wygasnąć i nie zostanie przesłana do konsumenta.

Atrybut `user-id` nie reprezentuje identyfikatora użytkownika systemu, tylko konto RabbitMQ na które się logujemy. Jeśli te wartości nie będą takie same (różne konta) wiadomości zostanie odrzucona - w PHP rzucony wyjątek.

[Atrybuty wiadomości](https://www.rabbitmq.com/publishers.html#message-properties)

## Konsument (ang. Consumer)

Worker, który ma przetwarzać wiadomości z kolejki może podczas połączenia z kolejką ustawić atrybut `no_ack`. Przy wartości `true` RabbitMq będzie wysyłał kolejne wiadomości z kolejki nie oczekując na potwierdzenie wiadomości. Gdy flaga ta jest ustawiona na wartość `false` wtedy konsument musi potwierdzić każdą wiadomość którą otrzymał.

Różnica między poleceniami `get` a `consume` polega na tym że `get` jest w modelu polling, a `consume` push. Za każdym razem kiedy wywołujemy polecenie `get` wysyłany jest żądanie do serwera RabbitMQ. W przypadku `consume` RabbitMQ będzie asynchronicznie przesyłał wiadomości jak tylko będą dostępne.

Bez ustawienia atrybutu `exclusive` na kolejce, RabbitMQ zezwala na podłączenie wielu konsumentów. Wiadomości dostarcza w trybie round-robin do wszystkich konsumentów, którzy są w stanie odbierać komunikaty z kolejki.

RabbitMQ pozwala zarejestrować tylko jednego konsumenta ["Single Active Consumer"](https://www.rabbitmq.com/consumers.html#single-active-consumer), który będzie korzystał z kolejki oraz przejście na innego zarejestrowanego konsumenta w przypadku anulowania lub śmierci aktywnego konsumenta.

[Przy domyśnej konfiguracji konsumer musi powtwierdzić wiadomość w ciągu 30 min.](https://www.rabbitmq.com/consumers.html#acknowledgement-timeout)
