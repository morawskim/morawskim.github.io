# Docker Swarm Szablony

## Kontener

```
version: '3.4'
services:
  foo:
    # ...
    logging:
      driver: "json-file"
      options:
        max-file: 5
        max-size: 10m
    deploy:
      labels:
        traefik.port: 8080
        traefik.backend: "example"
        traefik.frontend.rule: "Host:example.com"
        traefik.enable: "true"
      resources:
        limits:
          cpus: '1'
          memory: 75M
        reservations:
          cpus: '0.20'
          memory: 50M
      restart_policy:
        condition: on-failure
        delay: 30s
        max_attempts: 3
        window: 20s
# ...
# vim: ft=docker-compose.yaml:

```

