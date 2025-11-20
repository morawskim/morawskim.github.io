# Traefik - SNI load balancer

Na jednym serwerze testowym potrzebowaliśmy uruchomić wiele instancji aplikacji.
Zamiast otwierać na firewallu wiele portów dla połączeń WSS (WebSocket Secure), możemy wystawić jeden port, a następnie wykorzystać SNI (Server Name Indication) do przekierowania ruchu do odpowiedniej instancji.

Traefik działa tutaj jako TCP router, który na podstawie pola SNI wybiera, do którego backendu przekazać dane bez terminowania TLS.

Tworzymy plik `docker-compose.yml` o zawartości

```
services:
  traefik:
    image: traefik:v3.6
    command:
      - "--providers.docker=true"
      - "--entrypoints.tls.address=:443"
      - "--api.dashboard=true"
      - "--api.insecure=true"
    ports:
      - "4433:443"
      - "8080:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro

  foo:
    image: caddy:2.10
    volumes:
      - ./Caddyfilefoo:/etc/caddy/Caddyfile:ro
      - ./foo/:/srv/www
    labels:
      - "traefik.enable=true"
      # ROUTER
      - "traefik.tcp.routers.foo.rule=HostSNI(`foo.lvh.me`)"
      - "traefik.tcp.routers.foo.entrypoints=tls"
      - "traefik.tcp.routers.foo.tls.passthrough=true"
      # SERVICE
      - "traefik.tcp.services.foo.loadbalancer.server.port=443"
  bar:
    image: caddy:2.10
    volumes:
      - ./Caddyfilebar:/etc/caddy/Caddyfile:ro
      - ./bar/:/srv/www
    labels:
      - "traefik.enable=true"
      # ROUTER
      - "traefik.tcp.routers.bar.rule=HostSNI(`bar.lvh.me`)"
      - "traefik.tcp.routers.bar.entrypoints=tls"
      - "traefik.tcp.routers.bar.tls.passthrough=true"
      # SERVICE
      - "traefik.tcp.services.bar.loadbalancer.server.port=443"

```

Struktura plików w bieżącym katalogu powinna wyglądać następująco:

```
.
├── bar
│   └── index.html
├── Caddyfilebar
├── Caddyfilefoo
├── docker-compose.yml
└── foo
    └── index.html
```

Możemy sprawdzić, czy Traefik poprawnie przekazuje ruch na podstawie SNI:  `curl -kv https://bar.lvh.me:4433`.
