# Prometheus

## Dobre praktyki

* Funkcja `rate` do działania wymaga dwóch próbek. Dobrą praktyką jest więc określenie wartości ze wzoru 4 x scrape_interval.
Takie ustawienie zabezpiecza nas także przed sytuacją, gdy jedno pobranie danych się nie powiodło.

[What range should I use with rate()?](https://www.robustperception.io/what-range-should-i-use-with-rate/)
[Using $__rate_interval](https://grafana.com/docs/grafana/latest/datasources/prometheus/#using-__rate_interval)

* Metryki nie powinny posiadać dużej ilości wymiarów (etykiet), ponieważ spowoduje to powstanie dużej liczby szeregów czasowych ([eksplozja kardynalności](https://prometheus.io/docs/practices/naming/)). Podobnie w przypadku etykiety, która nie ma wyraźnego limitu wartości.

> CAUTION: Remember that every unique combination of key-value label pairs represents a new time series, which can dramatically increase the amount of data stored. Do not use labels to store dimensions with high cardinality (many different label values), such as user IDs, email addresses, or other unbounded sets of values.

* Aby przeładować konfiguracje Prometeusza musimy wysłać sygnał SIGHUP, albo żądanie POST do końcówki `/-/reload`. Domyślnie API Lifecycle nie jest włączone, więc musimy uruchomić proces prometeusza z flagą `--web.enable-lifecycle`. Do weryfikowania poprawności pliku konfiguracyjnego możemy wykorzystać narzędzie promtool - `promtool check config /sciezka/do/prometheus.yml`

* Lista portów wykorzystywanych przez prometeusza i zewnętrzne programy do eksportu metryk - [Default port allocations](https://github.com/prometheus/prometheus/wiki/Default-port-allocations)

## Backfill

Tworząc kokpit w Grafanie potrzebujemy danych historycznych.
Możemy je umieścić w bazie Prometeusza korzystając z polecenia `promtool tsdb create-blocks-from openmetrics /sciezka/do/plku/z/metrykami /sciezka/do/katalogu/wyjsciowego`.
Przykładowy plik z metrykami w formacie OpenMetrics wygląda następująco:

```
# HELP my_metric_total Description of metric.
# TYPE my_metric_total counter
my_metric_total{label1="foo",label2="user"} 10 1659372370
my_metric_total{label1="bar",label2="user"} 15 1659372370
# EOF
```

Ponieważ wygenerowane bloki danych mogą nachodzić na istniejące, musimy ustawić flagę `--storage.tsdb.allow-overlapping-blocks`.
Dodatkowo należy pamiętać, że domyślnie Prometeusz przechowuje dane tylko przez 15 dni. Jeśli generujemy dane także dla wcześniejszego okresu musimy ustawić parametr startowy `--storage.tsdb.retention.time` na dłuższą wartość.

[Backfilling from OpenMetrics format](https://prometheus.io/docs/prometheus/latest/storage/#backfilling-from-openmetrics-format)
[Prometheus backfilling](https://tlvince.com/prometheus-backfilling)
