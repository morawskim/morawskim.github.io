# Traefik - SNI load balancer

Na jednym serwerze testowym potrzebowaliśmy uruchomić wiele instancji aplikacji.
Zamiast otwierać na firewallu wiele portów dla połączeń WSS (WebSocket Secure), możemy wystawić jeden port, a następnie wykorzystać SNI (Server Name Indication) do przekierowania ruchu do odpowiedniej instancji.

Traefik działa tutaj jako TCP router, który na podstawie pola SNI wybiera, do którego backendu przekazać dane bez terminowania TLS.

### Traefik

Tworzymy plik `docker-compose.yml` o zawartości

```
services:
  traefik:
    image: traefik:v3.6
    command:
      - "--providers.docker=true"
      - "--providers.docker.network=sni"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.tls.address=:443"
      - "--api.dashboard=true"
      - "--api.insecure=true"
    ports:
      - "4433:443"
      - "8080:8080"
    networks:
      - default
      - sni
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro

networks:
  sni:
    external: true

```

Tworzymy sieć Dockera sni - `docker network create sni`

Tworzymy dwa katalogi: `foo` i `bar`.
W każdym z nich tworzymy:
* docker-compose.yml
* Caddyfile
* katalog `webroot` z plikiem `index.html`.

Plik index.html powinien zawierać treść pozwalającą rozpoznać, z którą usługą się połączyliśmy (np. "FOO" lub "BAR").

### usługa foo

foo/docker-compose.yml:


```
services:
  foo:
    image: caddy:2.10
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - ./webroot/:/srv/www
    networks:
      - default
      - sni
    labels:
      - "traefik.enable=true"
      # ROUTER
      - "traefik.tcp.routers.foo.rule=HostSNI(`foo.lvh.me`)"
      - "traefik.tcp.routers.foo.entrypoints=tls"
      - "traefik.tcp.routers.foo.tls.passthrough=true"
      # SERVICE
      - "traefik.tcp.services.foo.loadbalancer.server.port=443"
networks:
  sni:
    external: true

```

foo/Caddyfile:

```
https:// {
    root * /srv/www
    file_server
    tls internal {
      on_demand
    }
    log
}
```

### usługa bar

bar/docker-compose.yml:

```
services:
  bar:
    image: caddy:2.10
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - ./webroot/:/srv/www
    networks:
      - default
      - sni
    labels:
      - "traefik.enable=true"
      # ROUTER
      - "traefik.tcp.routers.bar.rule=HostSNI(`bar.lvh.me`)"
      - "traefik.tcp.routers.bar.entrypoints=tls"
      - "traefik.tcp.routers.bar.tls.passthrough=true"
      # SERVICE
      - "traefik.tcp.services.bar.loadbalancer.server.port=443"
networks:
  sni:
    external: true

```

bar/Caddyfile:

```
https:// {
    root * /srv/www
    file_server
    tls internal {
      on_demand
    }
    log
}
```

### Test

Możemy sprawdzić, czy Traefik poprawnie przekazuje ruch na podstawie SNI:  `curl -kv https://bar.lvh.me:4433`.
