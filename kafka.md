# Kafka

Kafka gromadzi zdarzenia z różnych systemów źródłowych i zapisuje je do tzw. `unified log`.
Cechami `unified log` są:

* struktura append-only
* uporządkowane dane
* rozproszony

## PHP

Jeśli korzystamy z obrazu dockera `php:7.4` to musimy doinstalować pakiet `librdkafka-dev`, a następnie wywołać standardowe polecenia do instalacji (`pecl install rdkafka`) i włączenia rozszerzenia PHP (`docker-php-ext-enable rdkafka`). Przydata jest także biblioteka [kwn/php-rdkafka-stubs](https://github.com/kwn/php-rdkafka-stubs), która dostarcza stubs dla rozszerzenia RdKafka. Dzięki temu w IDE będzie działać m.in. inspekcja i podpowiadanie kodu.

[Installaton rphp-rdkafka](https://github.com/arnaud-lb/php-rdkafka#installation)

[Examples](https://arnaud.le-blanc.net/php-rdkafka-doc/phpdoc/rdkafka.examples.html)

[Configuration](https://github.com/edenhill/librdkafka/blob/master/CONFIGURATION.md)

## Kafka as service

Instalacja, konfiguracja i zarządzanie klastrem Kafki zajmuje sporo czasu. [Cloudkarafka](https://www.cloudkarafka.com/) dostarcza w pełni zarządzane klastry. Posiada także darmowy pakiet, który jest wystarczający dla programistów jak i wersji demo aplikacji.

### Docker image

Większość obrazów zawiera starą wersję Kafki (np. [0.11 od spotify](https://hub.docker.com/r/spotify/kafka)).

Pewnym wyjątkiem są obrazy [confluentinc/cp-kafka](https://hub.docker.com/r/confluentinc/cp-kafka). Obrazy te zawierają Kafkę dostarczaną przez Confluent Community. Przykładowy plik compose - jest dostępny w [repozytorium](https://github.com/confluentinc/kafka-images/blob/master/examples/kafka-single-node/docker-compose.yml)

[KRaft mode Kafka](https://hub.docker.com/r/doughgle/kafka-kraft)

## CLI DEMO

Ze [strony](https://kafka.apache.org/downloads) pobieramy Kafke np. `kafka_2.13-2.6.0` , rozpakowujemy archiwum i przechodzimy do nowego utworzonego katalogu.

Uruchamiamy klaster Apache ZooKeeper poleceniem `./bin/zookeeper-server-start.sh ./config/zookeeper.properties`. Skrypt ten utworzony i skonfiguruje ZooKeeper z jednym węzłem.

Następnie możemy uruchomić serwer Kafka `./bin/kafka-server-start.sh config/server.properties`.

Kolejnym zadaniem to utworzenie tematu (ang. topic) `./bin/kafka-topics.sh --create --topic raw-events --zookeeper localhost:2181 --replication-factor 1 --partition 1`

Upewniamy się że temat został utworzony wywołując polecenie `bin/kafka-topics.sh --list --zookeeper localhost:2181`.

Uruchamiamy skrypt (producer), który wyśle zdarzenia z strumienia stdin `./bin/kafka-console-producer.sh --topic raw-events --broker-list localhost:9092`

Na końcu odpalamy skrypt consumer `./bin/kafka-console-consumer.sh --topic raw-events --from-beginning --bootstrap-server localhost:9092`.

## Topic

W celu utworzenia nowego tematu (ang. topic) korzystamy z narzędzia konsolowego `kafka-topics.sh`. Jeśli podczas tworzenia tematu nie nadpiszemy parametrów konfiguracyjnych zostaną wykorzystane wartości domyślne serwera. Rozszerzenie PHP (rdkafka) obecnie nie obsługuje Topic API. Planowana jest dodanie obsługi Topic API w wersji 5.

Kafka potrafi automatycznie tworzyć temat w brokerze podczas subskrybowania. Temat zostanie utworzony tylko wtedy gdy parametr `auto.create.topics.enable` brokera jest ustawiony na wartość `true` (domyślna wartość).

Główne atrybuty konfiguracyjne to:

* [cleanup.policy](https://kafka.apache.org/26/documentation.html#cleanup.policy)
* [retention.bytes](https://kafka.apache.org/26/documentation.html#retention.bytes)
* [retention.ms](https://kafka.apache.org/26/documentation.html#retention.ms)

Przykładowe wywołanie z najczęściej wykorzystywanymi opcjami:

```
kafka-topics.sh --create \
	--bootstrap-server localhost:9092
	--replication-factor 1 \
	--partitions 3 \
	--topic TOPIC_NAME \
	--config retention.bytes=1000000000 \
	--config retention.ms=86400000
```

Jeśli podczas zakładania tematu wartość argumentu `replication-factor` przekroczy liczbę dostępnych brokerów do otrzymamy błąd:
```
[2020-09-24 12:14:50,659] ERROR org.apache.kafka.common.errors.InvalidReplicationFactorException: replication factor: 2 larger than available brokers: 1
 (kafka.admin.TopicCommand$)
```

|Argument kafka-topic   | Domyślna wartość z parametru serwera  |   |
|---|---|---|
| `--replication-factor <VALUE>`  |   |   |
| `--partitions <VALUE>`  | `num.partitions`  |   |
| `--config retention.bytes=<VALUE>`  | `log.retention.bytes`  |   |
| `--config retention.ms=<VALUE>`  | `log.retention.ms`  |   |
| `--config cleanup.policy=<VALUE>`  | `log.cleanup.policy`  |   |
|   |   |   |

[How do I specify the number of partitions for a new topic?](https://github.com/arnaud-lb/php-rdkafka/issues/163)

[Implement librdkafka Topic API ](https://github.com/arnaud-lb/php-rdkafka/issues/215)

[Topic Configs](https://kafka.apache.org/26/documentation.html#topicconfigs)

## Nadawca

Nadawca (ang. producer) przesyła wiadomości do Kafki. Wiadomości, które chcemy przesłać są zbierane w batche. Batch to zgrupowane wiadomości przez kombinacje brokera i numeru partycji do której ta wiadomość jest wysyłana. Zbieranie wiadomości ma na celu polepszenie przepustowości. Zastosowanie kompresji wiadomości ma lepszy wynik w przypadku batcha niż pojedynczej wiadomości. W przypadku gdy choć jedna wiadomość w batchu nie powiedzie się, wtedy cały batch dla tej partycji jest odrzucany. Parametr `retry` automatycznie ponawia próby przesłania wiadomości. Jednak jeśli kolejność wiadomości jest ważna, wtedy oprócz ustawienia parametru `retry`, wartość parametru `max.in.flight.requests.per.connection` nie powinna być inna niż 1.

Jeśli mamy klaster i oczekujemy wysokiej gwarancji dostarczenia i zapisu wiadomości ustawiamy parametr `acks` na wartość `all` lub `-1`. Jednak jeśli brokery z repliką partycji tematu działają bardzo wolno, to mogą zostać usunięte z ISR - [What does In-Sync Replicas in Apache Kafka Really Mean?](https://www.cloudkarafka.com/blog/2019-09-28-what-does-in-sync-in-apache-kafka-really-mean.html). Wtedy ISR będzie składać się tylko z jednego serwera i wiadomość zostanie potwierdzona tylko przez jedną replikę (lidera). Wiadomość jest więc narażona na zgubienie w przypadku utraty lidera. Ustawiając parametr konfiguracyjny [min-insync.replicas](https://kafka.apache.org/documentation/#min.insync.replicas) możemy zabezpieczyć się przed taką sytuacją. Jeśli parametr jest ustawiony na wartosć 2, to jeśli ISR zmniejszy się do jednej repliki, to  przychodzące wiadomości będą odrzucane.

Główne atrybuty konfiguracyjne to:

* [acks ](https://kafka.apache.org/26/documentation/#acks)

* [bootstrap.servers](https://kafka.apache.org/26/documentation/#bootstrap.servers)

* [compression.type](https://kafka.apache.org/26/documentation/#compression.type)

* [retries](https://kafka.apache.org/26/documentation/#retries)

* [delivery.timeout.ms](https://kafka.apache.org/26/documentation/#delivery.timeout.ms)

## systemd units

Zookeeper Unit File

```
[Unit]
Requires=network.target remote-fs.target
After=network.target remote-fs.target

[Service]
Type=simple
ExecStart=/opt/kafka/bin/zookeeper-server-start.sh /opt/kafka/config/zookeeper.properties
ExecStop=/opt/kafka/bin/zookeeper-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
```

Kafka Unit File
```
[Unit]
Requires=zookeeper.service
After=zookeeper.service

[Service]
Type=simple
ExecStart=/opt/kafka/bin/kafka-server-start.sh /opt/kafka/bin/config/server.properties
ExecStop=/home/kafka/kafka/bin/kafka-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
```
