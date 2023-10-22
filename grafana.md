# Grafana

## Przykładowa konfiguracja Prometheus'a

Do przeładowania konfiguracji (jeśli nie mamy włączonej opcji przeładowania konfiguracji przez API) - `docker kill -s SIGHUP NAZWA_LUB_ID_KONTENERA_PROMETHEUSA`

```
global:
  # How frequently to scrape targets by default.
  scrape_interval: 1m
  # How long until a scrape request times out.
  scrape_timeout: 10s

# A list of scrape configurations.
scrape_configs:
  # The job name assigned to scraped metrics by default.
  - job_name: nodeexporter
    # How frequently to scrape targets from this job.
    scrape_interval: 1m
    # Per-scrape timeout when scraping this job.
    scrape_timeout: 10s
    # The HTTP resource path on which to fetch metrics from targets.
    metrics_path: /metrics
    # List of labeled statically configured targets for this job.
    static_configs:
      - targets: ["nodeexporter:9100"]
```

## Szablon dla docker-compose

```
version: '3.4'
services:
  nodeexporter:
    image: prom/node-exporter:v1.3.1
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.ignored-mount-points=^/(sys|proc|dev|host|etc)($$|/)'
  prometheus:
    image: prom/prometheus:v2.36.2
    volumes:
      - ./prometheus:/etc/prometheus
      - prometheus:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
      - '--storage.tsdb.retention.time=200h'
      - '--web.enable-lifecycle'
    labels:
      traefik.backend: "prometheus"
      traefik.frontend.rule: "Host:prometheus.lvh.me"
      traefik.port: "9090"
  grafana:
    image: grafana/grafana:9.0.1
    volumes:
      - grafana:/var/lib/grafana
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=admin
      - GF_USERS_ALLOW_SIGN_UP=false
    labels:
      traefik.backend: "grafana"
      traefik.frontend.rule: "Host:grafana.lvh.me"
      traefik.port: "3000"
  traefik:
    image: traefik:1.7
    command: --web --docker
    ports:
      - "80:80"
      - "8080:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /dev/null:/etc/traefik/traefik.toml
volumes:
  prometheus:
  grafana:

```

## Grafana i Prometheus źródło danych

Tworzymy plik `prometheus.yaml` i wklejamy:

```
apiVersion: 1
datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    orgId: 1
    url: http://prometheus:9090
    basicAuth: false
    isDefault: true
    editable: true
```

Utworzony plik musimy zamontować do kontenera Grafany `/etc/grafana/provisioning/datasources/prometheus.yaml`.

## Konfiguracja Grafany

Wszystkie opcje dostępne w pliku konfiguracyjnym możemy nadpisać poprzez zmienne środowiskowe korzystając z składki `GF_<SectionName>_<KeyName>` ([Konfiguracja Grafany](https://grafana.com/docs/grafana/latest/installation/configuration/#configure-with-environment-variables)).

Aktualną konfigurację możemy podejrzeć wchodząc na stronę `/admin/settings`.
