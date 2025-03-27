# grok_exporter

`grok_exporter` to narzędzie, które umożliwia parsowanie logów i eksportowanie wyników w formacie zgodnym z Prometheus.

## Plik konfiguracyjny

Pobierając plik grok_exporter z witryny [GitHub](https://github.com/fstab/grok_exporter), otrzymamy archiwum ZIP zawierające także wzorce Grok z Logstasha. Możemy je również pobrać samodzielnie z [repozytorium](https://github.com/logstash-plugins/logstash-patterns-core/tree/6d25c13c15f98843513f7cdc07f0fb41fbd404ef/patterns).
Bazując na poniższym pliku konfiguracyjnym, wzorce Grok powinniśmy umieścić w katalogu `patterns`.

```
global:
  config_version: 3

input:
  type: file
  path: /sciezka/do/pliku..log
  readall: true # Read from the beginning of the file? False means we start at the end of the file and read only new lines.
imports:
- type: grok_patterns
  dir: ./patterns

grok_patterns:
  - 'NAME [a-zA-Z\p{L}]+'

metrics:
  - type: counter
    name: my_metric_name
    help: "Liczba wystąpień bledow per uzytkownik"
    match: '%{YEAR}-%{MONTHNUM}-%{MONTHDAY} %{HOUR}:%{MINUTE}:%{SECOND} - error for account: %{NAME:firstname} %{NAME:lastname}'
    labels:
      fullname: "{{ .firstname }} {{ .lastname }}"

server:
  host: 0.0.0.0
  port: 9144

```

Eksporter uruchamiamy poleceniem `./grok_exporter -config config.yml`
