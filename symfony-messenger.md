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