# yii2-queue

Do integracji dwóch technologi PHP i node uzyłem Redis.
Program w node dodawał zadanie do kolejki, zaś worker w PHP pobierał zadania i je przetwarzał.
Redis natywnie nie obsługuje kolejek, ale za pomocą dostępnych struktur danych i poleceń możemy je zaimplementować.
Pakiet `yii2-queue` narzuca nam strukturę danych.
Domyślnie `yii2-queue` korzysta z serializatora php. Musimy go zmienić na format, który jest obsługiwany przez wszystkie nasze technologie. Najczęściej będzie to `json`. W konfiguracji komponentu kolejki dodałem parametr `serializer`.

``` php
'queue' => [
    'class' => \yii\queue\redis\Queue::class,
    'channel' => 'queue',
    'serializer' => \yii\queue\serializers\JsonSerializer::class,
],
```

Podłączyłem się do usługi redis przez `redis-cli` i wywołałem polecenie `MONITOR`. Dzięki temu widziałem wszystkie polecenia przesyłane do usługi redis.
Następnie dodałem przez pakiet `yii2-queue` przykładowe zadania do kolejki.
Kod implementujący logikę dodania zadania do kolejki redis znajduje się w metodzie `\yii\queue\redis\Queue::pushMessage`. W konsoli gdzie monitorowałem polecenia redis otrzymałem:
```
1584276889.611802 [0 172.18.0.11:50538] "INCR" "queue.message_id"
1584276889.612186 [0 172.18.0.11:50538] "HSET" "queue.messages" "1" "300;{\"class\":\"common\\\\jobs\\\\RateOrders\",\"date\":\"\\2020-02-15\"}"
1584276889.612472 [0 172.18.0.11:50538] "LPUSH" "queue.waiting" "1"
```

Dzięki temu w node korzystając z pakietu `ioredis` mogłem zaimplementować takie same polecenia.
``` javascript
const QUEUE_ID = await client.incr('queue.message_id');
    try {
        await client.multi()
            .hset('queue.messages', QUEUE_ID, `300;${JSON.stringify({
                class: '\\common\\jobs\\RateOrders',
                date: `${date.getFullYear()}-${date.getMonth()+1}-${date.getDate()}`
            })}`)
            .lpush('queue.waiting', QUEUE_ID)
            .exec();
    } catch (e) {
        console.error(e);
        throw Error("Can't add task to queue");
    } finally {
        client.disconnect();
    }
```

W pliku konfiguracji `console/config/main.php` w kluczu `bootstrap` dodałem `queue`.
``` php
// ...
return [
    'id' => 'app-console',
    'name' => 'SSOrder',
    'basePath' => dirname(__DIR__),
    'bootstrap' => ['log', 'queue'],
    'controllerNamespace' => 'console\controllers',
    ///....
```

Po dodaniu zadania do kolejki w node, korzystając z narzędzi CLI uruchomiłem polecenie `./yii queue/info`.
W oczekujących zadaniach zwiększyła się liczba zadań.

Uruchomiłem polecenie `./yii queue/run`. Zadanie zostało pobrane z kolejki i przetworzone.
Jednak chciałem nasłuchiwać na zadania w kolejce. Utworzyłem nowy kontener dockera.
W konfiguracji entrypoint podałem `["php", "./yii", "queue/listen", "--verbose"]`.

Podczas nasłuchiwania na zadania, mogą być zrzucane wyjątki:
```
Exception 'yii\redis\SocketException' with message 'Failed to read from socket.
Redis command was: BRPOP queue.waiting 3'
```

[Polecenie](https://redis.io/commands/brpop) `BRPOP` blokuje połączenie na określony czas. W przypadku `yii2-queue` parametr `timeout` wynosi 3 sekundy. Klasa odpowiadająca za pobranie zadania z kolejki to `\yii\queue\redis\Queue::reserve`. Zaś wartość timeout jest definiowany w metodzie `\yii\queue\redis\Command::actionListen`. Podczas wywoływania polecenia `queue/listen` możemy zmienić domyślną wartość poprzez dodanie argumentu - `yii queue/listen [timeout]`.
Musimy pamiętać, aby podczas konfiguracji połączenia z redis ustawić parametr `dataTimeout` na wyższą wartość:
``` php
'redis' => [
    'class' => \yii\redis\Connection::class,
    'hostname' => getenv('REDIS_HOST'),
    'port' => getenv('REDIS_PORT'),
    'database' => getenv('REDIS_DATABASE'),
    'connectionTimeout' => 2,
    'dataTimeout' => 5,
    'retries' => 3,
    'retryInterval' => 500,
],
```
