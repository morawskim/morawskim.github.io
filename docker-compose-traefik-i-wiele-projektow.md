# docker-compose - traefik i wiele projektów

Dołączyłem do większego klienta, gdzie istniało kilka projektów PHP. Były one niezależne. Jedne działały w intranecie, drugie były dostępne publicznie. Z wewnętrznego systemu CRM można  wygenerować link do zmiany metody płatności. W takim przypadku klient, może wejść na swoje konto i dokończyć proces zmiany płatności. Obie aplikacje to oddzielne byty, które nie komunikują się ze sobą, ale oba chcą nasłuchiwać na porcie 80. Za pomocą `docker-compose` zbudowałem środowisko deweloperskie. Dzięki gotowym obrazom docker’a przypominało te produkcyjne.  Zamiast przełączać się między projektami, postanowiłem utworzyć nową sieć dockera i przez mechanizm reverse-proxy kierować ruch do odpowiedniego kontenera.

Nasz przykład składa się z trzech plików `docker-compose.yml`. Zostały one uproszczone i uruchamiają tylko jeden obraz `containous/whoami:v1.5.0`.

W pierwszym projekcie mamy definicję usługi `who`, a także odwołanie do zewnętrznej sieci `project`. Ustawiam etykiety dla serwera proxy `traefik` i podłączam kontener do dwóch sieci - domyślnej (`default`) i zewnętrznej (`project`).

```
version: '3.4'
services:
    who:
        image: containous/whoami:v1.5.0
        networks:
            - default
            - project
        environment:
            WHOAMI_NAME: project1
        labels:
            traefik.backend: "project1"
            traefik.frontend.rule: "Host:project1.lvh.me"
            traefik.port: "80"
            traefik.docker.network: project
networks:
   project:
      external: true
```

Podobne korki wykonuje w drugim projekcie. Ustawiam tylko inna nazwę, aby odróżnić te dwa projekty.
```
version: '3.4'
services:
    who:
        image: containous/whoami:v1.5.0
        networks:
            - default
            - project
        environment:
            WHOAMI_NAME: project2
        labels:
            traefik.backend: "project2"
            traefik.frontend.rule: "Host:project2.lvh.me"
            traefik.port: "80"
            traefik.docker.network: project

networks:
   project:
      external: true
```

Tworzymy ostatni plik `docker-compose.yml` z definicją kontenera `traefik`. Przypisujemy go do sieci `project`, a także wystawiamy porty `80` i `8080`.

```
version: '3.4'
services:
    traefik:
        image: traefik:1.7
        command: --web --docker --logLevel=DEBUG
        networks:
            - project
        ports:
          - "80:80"
          - "8080:8080"
        volumes:
          - /var/run/docker.sock:/var/run/docker.sock
          - /dev/null:/etc/traefik/traefik.toml

networks:
   project:
      external: true
```

Podczas uruchamiania środowiska `docker-compose up -d --build` w jednym z projektów dostaniemy błąd:
```
ERROR: Network project declared as external, but could not be found. Please create the network manually using `docker network create project` and try again.
```

Musimy utworzyć naszą sieć `project`. Robimy to wywołując polecenie `docker network create project`. Wywołując polecenie `docker network ls` możemy upewnić się, że nasza sieć została utworzona. Uruchamiamy pozostałe projekty.

Wywołując teraz polecenie `curl project1.lvh.me` lub `curl project2.lvh.me` kontener `traefik` przekaże żądanie HTTP do odpowiedniego kontenera.

Przykładowa odpowiedz z `project1`:
```
Name: project1
Hostname: 3a0c71b090cf
IP: 127.0.0.1
IP: 172.22.0.2
IP: 172.19.0.2
RemoteAddr: 172.22.0.4:60064
GET / HTTP/1.1
Host: project1.lvh.me
User-Agent: curl/7.60.0
Accept: */*
Accept-Encoding: gzip
X-Forwarded-For: 172.22.0.1
X-Forwarded-Host: project1.lvh.me
X-Forwarded-Port: 80
X-Forwarded-Proto: http
X-Forwarded-Server: b2a790132b36
X-Real-Ip: 172.22.0.1
```
