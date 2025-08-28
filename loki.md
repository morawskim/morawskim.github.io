# Loki

## Instalacja z docker compose

### Przykładowy plik konfiguracyjny `loki/local-config.yaml`

```
# Disables authentication for Loki, making it easier to set up and test locally.
# In a production environment, you would likely enable authentication for security reasons.
auth_enabled: false

server:
  http_listen_port: 3100
  grpc_listen_port: 9096
  log_level: debug
  grpc_server_max_concurrent_streams: 1000

common:
  instance_addr: 127.0.0.1
  path_prefix: /loki
  storage:
    filesystem:
      chunks_directory: /loki/chunks
      rules_directory: /loki/rules
  replication_factor: 1
  ring:
    kvstore:
      store: inmemory

query_range:
  results_cache:
    cache:
      embedded_cache:
        enabled: true
        max_size_mb: 100

limits_config:
  metric_aggregation_enabled: true

schema_config:
  configs:
    - from: 2020-10-24
      store: tsdb
      object_store: filesystem
      schema: v13
      index:
        prefix: index_
        period: 24h

pattern_ingester:
  enabled: true
  metric_aggregation:
    loki_address: localhost:3100

#ruler:
#  alertmanager_url: http://localhost:9093

frontend:
  encoding: protobuf

# By default, Loki will send anonymous, but uniquely-identifiable usage and configuration
# analytics to Grafana Labs. These statistics are sent to https://stats.grafana.org/
#
# Statistics help us better understand how Loki is used, and they show us performance
# levels for most users. This helps us prioritize features and documentation.
# For more information on what's sent, look at
# https://github.com/grafana/loki/blob/main/pkg/analytics/stats.go
# Refer to the buildReport method to see what goes into a report.
#
# If you would like to disable reporting, uncomment the following lines:
analytics:
  reporting_enabled: false

```

### docker-compose.yaml

```
services:
  loki:
    image: grafana/loki:latest
    ports:
      - "3100:3100"
    command: -config.file=/etc/loki/local-config.yaml
    volumes:
      - ./loki/local-config.yaml:/etc/loki/local-config.yaml
```

Wysłanie przykładowego wpisu loga (z etykietą foo=bar2 i komunikatem fizzbuzz):

```
curl -H "Content-Type: application/json" \
  -s -X POST "http://localhost:3100/loki/api/v1/push" \
  --data-raw "{\"streams\": [{ \"stream\": { \"foo\": \"bar2\" }, \"values\": [ [ \"$(date +%s%N)\", \"fizzbuzz\", {\"trace_id\" : \"1111-2222-3333-4444\"} ] ] }]}"
```

## Analiza etykiet (labels) i kardynalności

W wersji Loki 1.6.0 i nowszych wprowadzono możliwość analizy etykiet przy użyciu polecenia `logcli series` z flagą `--analyze-labels`, co jest szczególnie przydatne do debugowania etykiet o wysokiej kardynalności - `logcli series '{}' --since=1h --analyze-labels`

Analiza kardynalności etykiet pozwala uniknąć problemów z wydajnością i przechowywaniem danych w systemie Loki. Wysoka kardynalność może znacząco obciążać system, dlatego zaleca się unikać dynamicznych lub unikalnych identyfikatorów jako etykiet.

```
Total Streams:  25017
Unique Labels:  8

Label Name  Unique Values  Found In Streams
requestId   24653          24979
logStream   1194           25016
logGroup    140            25016
accountId   13             25016
logger      1              25017
source      1              25016
transport   1              25017
format      1              25017
```

`requestId` posiada bardzo wysoką kardynalność (24 653 unikalnych wartości), co oznacza, że nie powinno być używane jako etykieta.
Zamiast tego, należy traktować `requestId` jako dane w treści logu (linia logu zawiera requestId=value) i filtrować je za pomocą wyrażeń, np.: `{logGroup="group1"} |= "requestId=32422355"`

## Zapytania

"Log stream" to strumień wpisów dziennika z tymi samymi etykietami.

Wybieranie strumienia logów za pomocą LogQL:

* log selector - Filtrowanie strumieni logów na podstawie dopasowanych etykiet przy użyciu indeksu np. `{app="foo"}`

* filter expression - przeszukuje zawartość linii logu, odrzucając te linie, które nie pasują do wyrażenia np. `|= "error"`


### Dopasowanie adresów IP

`{job_name="myapp"} |= ip("192.168.1.5/24")`

Pojedynczy adres IP `ip("192.0.2.0")`, `ip("::1")`
Zakres `ip("192.168.0.1-192.189.10.12")`, `ip("2001:db8::1-2001:db8::8")`
Maska CIDR `ip("192.51.100.0/24")`, `ip("2001:db8::/32")`

[LogQL: Log query language](https://grafana.com/docs/loki/latest/query/?pg=oss-loki&plcmt=resources#logql-log-query-language)

### Pattern match filter operators

"Pattern Filter" pozwala wyeleminować stosowanie złożonych wyrażeń regularnych.
W składni wzorca symbol `<_>` pełni rolę symbolu wieloznacznego (wildcard), reprezentującego dowolny tekst.
Umożliwia to dopasowywanie linii logów, w których występuje określony wzorzec — na przykład linie zawierające treść statyczną z fragmentami zmiennej treści pomiędzy nimi.

```
|> (line match pattern)
!> (line match not pattern)


{service_name=`distributor`} |> `<_> caller=http.go:194 level=debug <_> msg="POST /push.v1.PusherService/Push <_>`
```

[Pattern match filter operators](https://grafana.com/docs/loki/latest/query/#pattern-match-filter-operators)

