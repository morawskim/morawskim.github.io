# s6-overlay

s6-overlay to system init dla kontenerów Docker, który dba o poprawne uruchamianie, nadzorowanie i kończenie procesów w środowiskach kontenerowych.
Umożliwia uruchomienie kilku procesów w jednym kontenerze (np. Nginx + PHP-FPM).

Cechy:

* działa jako PID 1

* umożliwia zarządzanie usługami i procesami

* zapewnia prawidłowy cykl życia kontenera

* dodaje hooks (init i finish) podobne do systemd/rc.d

[Running Symfony in a Multi-Process Container (Slajdy)](https://speakerdeck.com/dazz/running-symfony-in-multi-process-containers)
[Running Symfony in a Multi-Process Container (Wideo)](https://live.symfony.com/account/replay/video/1060)
[s6-overlay-base docker image](https://github.com/dazz/s6-overlay-base)

## Przykład

Istnieje gotowy obraz dockera (`hakindazz/s6-overlay-base`) z wydobytą wersją s6-overlay (binariów i skryptów) w /s6/root, przygotowaną do dalszego użycia (bez powtarzania czynności rozpakowywania tarballi w Dockerfile).

Możemy skorzystać z obrazu `hakindazz/s6-cli`, aby wygenerować szkielet usługi (tutaj: supervisor jako longrun): `docker run -it --rm -v ./:./:/etc/s6-overlay/s6-rc.d hakindazz/s6-cli create longrun supervisor`

To polecenie utworzy w katalogu roboczym folder `supervisor` z niezbędnymi plikami konfiguracyjnymi.
Plik `supervisor/run` musi mieć prawa wykonywania (chmod +x).
Można go napisać w bash lub w execline.

Przykład run (w execline):
```
#!/command/execlineb -P
with-contenv
/usr/bin/supervisord --nodaemon --configuration /etc/supervisor/supervisord.conf
```

Tworzymy bundle o nazwie `user`: `docker run -it --rm -v ./:/etc/s6-overlay/s6-rc.d hakindazz/s6-cli create bundle user`

W katalogu `user/contents.d` dodajemy pusty plik o nazwie `supervisor` — nazwa musi odpowiadać katalogowi usługi.

Tworzymy plik Dockerfile.

```
FROM hakindazz/s6-overlay-base AS s6-overlay
FROM rockylinux:9.3

COPY --from=s6-overlay /s6/root /

RUN dnf install -y epel-release && dnf install -y supervisor && dnf clean all

ENTRYPOINT ["/init"]

```

Dołączanie konfiguracji s6 można dokonać na dwa sposoby.

### Skopiowanie konfiguracji do obrazu

```
COPY --chmod=755 ./s6/root /
```

### Zamontowanie konfiguracji przez docker-compose.yml

```
services:
  supervisor:
    build:
      context: ./
      dockerfile: ./Dockerfile
    restart: unless-stopped
    environment:
      #S6_VERBOSITY: 5 # default is 1, goes from 1-5
    volumes:
      - ./s6/s6-rc.d/svc-supervisor:/etc/s6-overlay/s6-rc.d/svc-supervisor
      - ./s6/s6-rc.d/user:/etc/s6-overlay/s6-rc.d/user
```

Należy uważać, aby nie nadpisać całego katalogu `/etc/s6-overlay/s6-rc.d`, ponieważ może to spowodować błędy przy kompilacji konfiguracji:

>#supervisor-1  | s6-rc-compile: info: resolving bundle names
>#supervisor-1  | s6-rc-compile: fatal: during resolution of bundle top: undefined service name user2
