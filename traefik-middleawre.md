# Traefik middleware

Traefik obsługuje wtyczkową architekturę i tym samym możemy utworzyć w języku Go własny middleware.
Tryb "Local Mode" jest przydatny w czasie testowania nowego pluginu, ktorego jeszcze nie opublikowaliśmy w zdalnym repozytorium.
Katalog z kodem źródłowym pluginu musi być umieszony w folderze `./plugins-local/src` w katalogu roboczym procesu traefik.
Dodatkowo musi być zorganizowany w odpowiedni sposób - zachowując ścieżke modułu np. dla "github.com/morawskim/go-projects/traefik-abuseip-middleware" kod musi być dostępny w katalogu "./plugins-local/src/github.com/morawskim/go-projects/traefik-abuseip-middleware".

W projekcie dodajemy plik `docker-compose.yml` (wykorzystuje on tryb Local mode).

```
services:
  traefik:
    image: traefik:v3.0
    command:
      - --api.insecure=true
      - --providers.docker
      - --log.level=DEBUG
      - --accesslog
      - --experimental.localPlugins.abuseip.moduleName=github.com/morawskim/go-projects/traefik-abuseip-middleware
    ports:
      - 80:80
      - 8080:8080
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - .:/plugins-local/src/github.com/morawskim/go-projects/traefik-abuseip-middleware
    tty: true
  whoami:
    image: traefik/whoami # https://github.com/traefik/whoami
    command: >-
      -name whoami -verbose true
    labels:
      traefik.http.routers.whoami.rule: Host(`whoami.lvh.me`)
      traefik.http.routers.whoami.middlewares: abuse
      traefik.http.middlewares.abuse.plugin.abuseip.foo: bar
```

Nazwa pakietu tworzonego pluginu jest powiązana z modułem. Nie możemy użyć dowolnej nazwy, ponieważ dostaniemy błąd ([How to debug in the local mode? #15 ](https://github.com/traefik/plugindemo/issues/15)):

> ERR github.com/traefik/traefik/v3/cmd/traefik/traefik.go:230 > Plugins are disabled because an error has occurred. error="failed to eval New: 1:28: undefined: traefik_abuseip_middleware"

[traefik newYaegiMiddlewareBuilder](https://github.com/traefik/traefik/blob/12a37346a4eacc9ddbe9a0c782999418e340d14d/pkg/plugins/middlewareyaegi.go#L26)

W projekcie musimy także posiadać plik manifestu dla pluginu `.traefik.yml`.

```
displayName: AbuseIP
type: middleware

import: github.com/morawskim/go-projects/traefik-abuseip-middleware

summary: '[Example] AbuseIP'

testData:
  foo: bar
```

[Przykładowy plugin dla traefik](https://github.com/traefik/plugindemo)


## Debugowanie

Obecnie nie możemy wykorzystać delve do debugowania pluginu - [Integrate yaegi with delve -> adds yaegis' interpreter to a debug session #1446](https://github.com/traefik/yaegi/issues/1446)
