# RabbitMQ metryki

[Metryki /metrics](https://github.com/rabbitmq/rabbitmq-server/blob/21fd44fde62d40eec81d6cf747419b55cdf86194/deps/rabbitmq_prometheus/metrics.md)

Endpoint `/metrics/detailed` w RabbitMQ (3.10+) udostępnia szczegółowe metryki per-obiekt (np. kolejki, exchange, konsumenci), które można selektywnie pobierać przez parametr family.
Znacząco zmniejsza to obciążenie względem pełnego `/metrics/per-object`.
Endpoint pozwala filtrować dane do konkretnego vhosta za pomocą parametru vhost (np. `vhost=%2F` dla /).

## Metryki szczegółowe

| Family                   | Opis |
| ------------------------ | --------------------------------------------------- |
| `queue_coarse_metrics`   | Podstawowe statystyki kolejek — liczba wiadomości, ready/unacked, procesy kolejek. |
| `queue_delivery_metrics` | Statystyki dostarczania wiadomości — delivered, ack, redelivery, get, drop itd. |
| `queue_consumer_count`   | Liczba konsumentów przypiętych do kolejek. |
| `queue_exchange_metrics` | Całkowita liczba wiadomości opublikowanych w kolejce za pośrednictwem exchange. |
| `node_metrics`           | Metryki noda RabbitMQ — memory, fd, sockets, uptime, Erlang VM. |
| `auth_attempt_metrics` | Próby logowania i autoryzacji użytkowników. |
|  | |
| `queue_metrics`          | Szczegółowe metryki kolejek — rozmiary, RAM, dysk itp. |
| `exchange_metrics` | Szczegółowe metryki exchange |


### Przykładowy request

```
http://localhost:15692/metrics/detailed?family=queue_coarse_metrics
```

http://localhost:15692/metrics/detailed?family=queue_coarse_metrics&queue=^messages$

## Prometheus

```
# ...
global:
  scrape_interval: 30s
scrape_configs:
  - job_name: rabbitmq
    static_configs:
      - targets:
          - rb1.example.com:15692
        #labels:
          #rabbitmq_cluster: aggregated
  - job_name: rabbitmq-details
    metrics_path: /metrics/detailed
    params:
      family:
        - queue_coarse_metrics
        - node_metrics
        - queue_consumer_count
    static_configs:
      - targets:
          - rb1.example.com:15692
        #labels:
          #rabbitmq_cluster: detailed

# if we want use rabbitmq queue dashboard (see section Grafana)
rule_files:
  - /etc/prometheus/rabbitmq.rules.yml

```

## Grafana

[RabbitMQ-Overview (ID=10991)](https://grafana.com/grafana/dashboards/10991-rabbitmq-overview/)

[RabbitMQ / Queue (ID=17308)](https://grafana.com/grafana/dashboards/17308-rabbitmq-queue/)

W przypadku dashbordu "RabbitMQ / Queue" zgodnie z artykułem [RabbitMQ Per Queue Monitoring](https://hodovi.cc/blog/rabbitmq-per-queue-monitoring/) musimy utworzyć regułę definiującą metrykę `rabbitmq_queue_info`.

>I also recommend that you add a Prometheus rule which defines a new metric called rabbitmq_queue_info. This is done by grouping the default rabbitmq_identity_info metric with the detailed consumer metric based on the instance/cluster/node. This is used in the dashboard to filter on and specify the rabbitmq_cluster

W moim przypadku konieczne było dodanie etykiety `job`.
Prometheus scrapował dane zarówno z endpointu `/metrics`, jak i `/metrics/detailed`, przez co zwracanych było więcej serii, co skutkowało błędem:

> execution: found duplicate series for the match group {instance="XXX.YYY.ZZZ.ZZZ:15692"} on the right hand-side of the operation:

Dodatkowo należy ustawić różne wartości etykiety `rabbitmq_cluster` w konfiguracji jobów Prometheusa.

```
groups:
  - name: rabbitmq_rules
    rules:
      - record: rabbitmq_queue_info
        expr: |
          rabbitmq_detailed_queue_consumers * on(instance)
          group_left(rabbitmq_cluster, rabbitmq_node)
          max(rabbitmq_identity_info{job="rabbitmq-details"})
          by (rabbitmq_cluster, instance, rabbitmq_node)
```
