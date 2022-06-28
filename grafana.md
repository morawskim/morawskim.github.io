# Grafana

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
