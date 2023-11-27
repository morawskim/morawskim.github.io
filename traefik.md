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
