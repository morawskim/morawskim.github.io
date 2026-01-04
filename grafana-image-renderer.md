# Grafana Image Renderer

Grafana Image Renderer to usługa służąca do wykonywania zrzutów ekranowych (renderowania) paneli i dashboardów Grafany do obrazów PNG przy użyciu headless Chrome.

Nie obsługuje eksportu do PDF — eksport oraz raporty PDF są dostępne wyłącznie w Grafana Enterprise oraz Grafana Cloud, a nie w wersji OSS - [Set up image rendering](https://github.com/grafana/grafana/blob/v12.1.1/docs/sources/setup-grafana/image-rendering/_index.md).

> Grafana supports automatic rendering of panels as PNG images. This allows Grafana to automatically generate images of your panels to include in alert notifications, PDF export, and Reporting. PDF Export and Reporting are available only in Grafana Enterprise and Grafana Cloud.

[Set up image rendering](https://grafana.com/docs/grafana/latest/setup-grafana/image-rendering/)

[Create and manage reports](https://grafana.com/docs/grafana/latest/visualizations/dashboards/create-reports/)

## Docker compose

Aby wyświetlić listę dostępnych opcji oraz parametrów konfiguracyjnych, można użyć polecenia:
`docker run --rm grafana/grafana-image-renderer:v5.1.0 server --help`.

Przykładowa konfiguracja docker-compose.yml:

```
services:
  renderer:
    image: grafana/grafana-image-renderer:v5.1.0
    environment:
      AUTH_TOKEN: TOKEN1111,TOKEN2222
      # enum: debug, info, warn, error
      LOG_LEVEL: info
      GOMEMLIMIT: 1GiB
    ports:
      - "8081:8081"
  grafana:
    image: grafana/grafana:12.3
    ports:
      - "3000:3000"
    environment:
      GF_RENDERING_SERVER_URL: http://renderer:8081/render
      GF_RENDERING_CALLBACK_URL: http://grafana:3000/
      GF_RENDERING_RENDERER_TOKEN: TOKEN2222
      GF_SECURITY_ADMIN_USER: admin
      GF_SECURITY_ADMIN_PASSWORD: admin
    volumes:
      - grafana-data:/var/lib/grafana
volumes:
  grafana-data:

```

## Metryki

Metryki Prometheus są dostępne pod ścieżką `/metrics` np. `http://renderer:8081/metrics`.

W Grafanie można zaimportować przykładowy dashboard [Grafana Image Renderer dashboard (ID: 12203)](https://grafana.com/grafana/dashboards/12203-grafana-image-renderer/)
