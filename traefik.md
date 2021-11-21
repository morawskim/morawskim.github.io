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
