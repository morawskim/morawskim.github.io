# Kafka

Kafka gromadzi zdarzenia z różnych systemów źródłowych i zapisuje je do tzw. `unified log`.
Cechami `unified log` są:

* struktura append-only
* uporządkowane dane
* rozproszony

## PHP

Jeśli korzystamy z obrazu dockera `php:7.4` to musimy doinstalować pakiet `librdkafka-dev`, a następnie wywołać standardowe polecenia do instalacji (`pecl install rdkafka`) i włączenia rozszerzenia PHP (`docker-php-ext-enable rdkafka`).

[Installaton rphp-rdkafka](https://github.com/arnaud-lb/php-rdkafka#installation)

[Examples](https://arnaud.le-blanc.net/php-rdkafka-doc/phpdoc/rdkafka.examples.html)

[Configuration](https://github.com/edenhill/librdkafka/blob/master/CONFIGURATION.md)

## Kafka as service

Instalacja, konfiguracja i zarządzanie klastrem Kafki zajmuje sporo czasu. [Cloudkarafka](https://www.cloudkarafka.com/) dostarcza w pełni zarządzane klastry. Posiada także darmowy pakiet, który jest wystarczający dla programistów jak i wersji demo aplikacji.

## CLI DEMO

Ze [strony](https://kafka.apache.org/downloads) pobieramy Kafke np. `kafka_2.13-2.6.0` , rozpakowujemy archiwum i przechodzimy do nowego utworzonego katalogu.

Uruchamiamy klaster Apache ZooKeeper poleceniem `./bin/zookeeper-server-start.sh ./config/zookeeper.properties`. Skrypt ten utworzony i skonfiguruje ZooKeeper z jednym węzłem.

Następnie możemy uruchomić serwer Kafka `./bin/kafka-server-start.sh config/server.properties`.

Kolejnym zadaniem to utworzenie tematu (ang. topic) `./bin/kafka-topics.sh --create --topic raw-events --zookeeper localhost:2181 --replication-factor 1 --partition 1`

Upewniamy się że temat został utworzony wywołując polecenie `bin/kafka-topics.sh --list --zookeeper localhost:2181`.

Uruchamiamy skrypt (producer), który wyśle zdarzenia z strumienia stdin `./bin/kafka-console-producer.sh --topic raw-events --broker-list localhost:9092`

Na końcu odpalamy skrypt consumer `./bin/kafka-console-consumer.sh --topic raw-events --from-beginning --bootstrap-server localhost:9092`.
