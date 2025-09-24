# Grafana – konfiguracja paneli na przykładach

## Wizualizacja metryki typu histogram (Prometheus)

W Prometheusie utworzyłem metrykę typu histogram, która mierzy czas odpowiedzi serwera API.
Dzięki skonfigurowanym bucketom możemy w Grafanie przedstawić rozkład tych czasów i łatwo obserwować zachowanie API.

### Konfiguracja panelu

Tworzymy nowy panel o typie "Bar gauge".

Zapytanie PromQL wskazuje na metrykę z etykietą hostname: `guzzle_response_duration_ms_bucket{hostname="myapi.example.com"}`

W opcjach panelu:
* ustawiamy `Legend` na `Custom` i wpisujemy "{{le}}"
* zmieniamy `Format` na "Heatmap"

[Show me the buckets’ distribution](https://grafana.com/blog/2020/06/23/how-to-visualize-prometheus-histograms-in-grafana/#show-me-the-buckets-distribution)

## Wizualizacja rozkład histogramu w czasie

Tworzymy nowy panel o type "Heatmap"

Zapytanie PromQL: `sum(increase(guzzle_response_duration_ms_bucket[$__interval])) by (le)`

[Now show me the buckets’ distribution over time](https://grafana.com/blog/2020/06/23/how-to-visualize-prometheus-histograms-in-grafana/#now-show-me-the-buckets-distribution-over-time)
