# clair

clair - narzędzie do statycznej analizy podatności w obrazach kontenerowych.

Przykładowa instalacja w [klastrze Kubernetes](https://github.com/morawskim/provision-dev-servers/commit/cda203b1b9df97c497eb2bc8e4a0e8f39b385fcb).

Przykładowy plik konfiguracyjny:
```
introspection_addr: ":8089"
http_listen_addr: ":6060"
log_level: debug

# updaters:
#   sets:
#     - ubuntu
#     - alpine
#     - redhat
#     - debian


indexer:
    connstring: "postgres://postgres:password@clair-postgres:5432/clair?sslmode=disable"
    migrations: true
matcher:
    connstring: "postgres://postgres:password@clair-postgres:5432/clair?sslmode=disable"
    indexer_addr: http://localhost:6060/
    migrations: true
notifier:
    connstring: "postgres://postgres:password@clair-postgres:5432/clair?sslmode=disable"
    migrations: true
    indexer_addr: http://localhost:6060/
    matcher_addr: http://localhost:6060/
```

Dokumentacja OpenAPI jest dostpęna pod adresem: `/openapi/v1`.

## docker compose

Uruchomienie serwera clair: `clair -conf config.yaml  -mode combo`

Testowy kontener z bazą danych dla clair

```
name: clair
services:
  db:
    image: docker.io/library/postgres:15
    network_mode: host
    # port 5432
    environment:
      POSTGRES_PASSWORD: password
      POSTGRES_DB: clair
    command: >
      postgres
      -c shared_buffers=512MB
      -c effective_cache_size=1GB
    volumes:
      - db:/var/lib/postgresql/data
    mem_limit: "2G"
volumes:
  db:

```

## clairctl

`clairctl manifest redis:6` - pobrania i wyświetlenia manifest obrazu kontenera redis:6

`clairctl report redis:6` - generuje raport o podatnościach dla obrazu kontenera redis:6
