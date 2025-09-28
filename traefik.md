# Traefik

## Domyślny host (v1.7)

W niektórych przypadkach (np. gdy testujemy integrację OAuth) chcemy, aby ruch na localhost był przekierowany do konkretnego kontenera (bez analizy nagłówka `Host`). W takim przypadku musimy skorzystać z zasady dopasowania `HostRegex`. Ważne jest ustawienie niskiego priorytetu dla tej reguły, aby nie powodować konfliktu z innymi regułami.

```
version: '3.4'
services:
    httpd:
        image: nginx:1.19-alpine
        depends_on:
            - php-fpm
        labels:
            traefik.backend: "httpd"
            traefik.static.frontend.rule: "Host:domain.lvh.me"
            traefik.wildcard.frontend.rule: "HostRegexp: {everything:.*}"
            traefik.wildcard.frontend.priority: "1"
        # ...
```

## Niestandardowe nagłówki (v1.7)

```
version: '3.4'
services:
    httpd:
        image: nginx:1.19-alpine
        depends_on:
            - php-fpm
        labels:
            #...
            traefik.frontend.headers.customRequestHeaders: "X-FOO:foo||X-BAR:bar||X-BAZ:baz"
            traefik.frontend.headers.customResponseHeaders: "X-Response-Foo:foo||X-Response-Bar:bar"
        # ...
```

## Port is missing (v2.x)

Traefik v2 [w pewnych okolicznościach potrafi wykryć port usługi](https://doc.traefik.io/traefik/v2.8/providers/docker/#port-detection).
W przypadku problemu w logach będzie linia podobna do:
> time="2023-11-22T16:59:23Z" level=error msg="service \"foo\" error: port is missing" container=fpp-17bfc0d15446a14931c98b3f27b900d5ec011c13795a1cd6913e83e389a0537e providerName=docker

Kiedy obraz kontenera nie ujawnia portów, albo wystawia więcej niż 1 port to musimy ręcznie poinstruować traefik do którego portu ma się łączyć.
Do tego celu korzystamy z etykiety:

```
services:
  foo:
     # ..
    labels:
      traefik.http.services.php-kindle.loadbalancer.server.port: "80"
```

## Auth basic i SSL (v3)

Za pomocą narzędzia `htpasswd` generujemy hasło `echo $(htpasswd -nb user mysecretpassword) | sed -e s/\\$/\\$\\$/g`.
Polecenie sed zdubluje znak $, ponieważ docker compose traktuje pojedyncze $ jako początek zmiennej środowiskowej.

W pliku `.env` umieszczamy wygenerowaną wartość `TREAFIK_USER_PASS=user:$$apr1$$SnYhj1kp$$TiAr.raEh3ZyKuBWotM.A1` (nie dodajemy żadnych `'` ani `"` wokół wartości)

```
services:
  nginx:
    image: nginx:latest
    labels:
      - traefik.enable=true
      - traefik.http.routers.nginx.rule=Host(`nginx.example.com`)
      - traefik.http.routers.nginx.entrypoints=https
      - traefik.http.services.nginx.loadbalancer.server.port=80
      - traefik.http.routers.nginx.middlewares=nginx-auth
      - traefik.http.middlewares.nginx-auth.basicauth.users=${TREAFIK_USER_PASS}
  traefik:
    image: traefik:v3.1
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    command:
      #- --log.level=DEBUG
      #- --log.filePath=/letsencrypt/traefik.log
      - --api.dashboard=true
      - --providers.docker=true
      - --providers.docker.exposedbydefault=false
      - --entrypoints.http.address=:80
      - --entrypoints.http.http.redirections.entrypoint.to=https
      - --entrypoints.http.http.redirections.entrypoint.scheme=https
      - --entrypoints.https.address=:443
      - --certificatesresolvers.letsencrypt.acme.httpchallenge.entrypoint=http
      # - --certificatesresolvers.letsencrypt.acme.tlschallenge=true
      # - --certificatesresolvers.letsencrypt.acme.caserver=https://acme-staging-v02.api.letsencrypt.org/directory
      - --certificatesresolvers.letsencrypt.acme.email=email@example.com
      - --certificatesresolvers.letsencrypt.acme.storage=/letsencrypt/acme.json
```
