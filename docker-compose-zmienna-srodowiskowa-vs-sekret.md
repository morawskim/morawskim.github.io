# Docker compose: zmienna środowiskowa vs sekret

Zmienna środowiskowa to wartość przechowywana w pamięci systemowej, którą można łatwo odczytać i wykorzystać w procesach aplikacji.
Jest dostępna globalnie (dla wszystkich procesów) i może być logowana podczas debugowania błędów, co stanowi potencjalne zagrożenie dla bezpieczeństwa.

Sekret to plik przechowywany w katalogu /run/secrets/, który jest dostępny tylko dla danego kontenera i nie jest widoczny dla innych procesów.
Nie jest on logowany ani udostępniany w sposób niekontrolowany, co czyni go bezpieczniejszą opcją do przechowywania poufnych danych, takich jak hasła czy klucze API.

## Użycie sekretów w Docker Compose

Tworzymy klucz `secrets`, w którym definiujemy sekret o nazwie `my_secret`.
Jego wartość zostanie pobrana ze zmiennej środowiskowej `SECRET_ENV`.
Montujemy także utworzony sekret w kontenerze `app` poprzez wykorzystanie klucza `secrets`.

```yaml
services:
  app:
    image: my_app_image
    secrets:
      - my_secret

secrets:
  my_secret:
    environment: SECRET_ENV
```

Sekret będzie dostępny w katalogu `/run/secrets/my_secret` uruchominonego kontenera.
Można go odczytać w kontenerze np. za pomocą polecenia `cat /run/secrets/my_secret`

[How to use secrets in Docker Compose](https://docs.docker.com/compose/how-tos/use-secrets/)
[Compose file reference / Secrets top-level elements](https://docs.docker.com/reference/compose-file/secrets/)
