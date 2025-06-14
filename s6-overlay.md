# s6-overlay

s6-overlay to system init dla kontenerów Docker, który dba o poprawne uruchamianie, nadzorowanie i kończenie procesów w środowiskach kontenerowych.
Umożliwia uruchomienie kilku procesów w jednym kontenerze (np. Nginx + PHP-FPM).

Cechy:

* działa jako PID 1

* umożliwia zarządzanie usługami i procesami

* zapewnia prawidłowy cykl życia kontenera

* dodaje hooks (init i finish) podobne do systemd/rc.d

## Przykład

Istnieje gotowy obraz dockera (`hakindazz/s6-overlay-base`) z wydobytą wersją s6-overlay (binariów i skryptów) w /s6/root, przygotowaną do dalszego użycia (bez powtarzania czynności rozpakowywania tarballi w Dockerfile).

```
FROM hakindazz/s6-overlay-base AS s6-overlay
FROM rockylinux:9.3

COPY --from=s6-overlay /s6/root /

RUN dnf install -y epel-release && dnf install -y supervisor && dnf clean all
ENTRYPOINT ["/init"]

```

