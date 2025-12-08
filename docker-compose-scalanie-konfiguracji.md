# docker compose scalanie konfiguracji

Plik `docker-compose.yml` możemy nadpisać, tworząc plik `docker-compose.override.yml`.
Zmniejsza to liczbę powtórzeń w sytuacji, gdy konfiguracja produkcyjna różni się od deweloperskiej.

W przypadku wartości typu lista, wynik będzie zawierał elementy z obu plików.
Korzystając z dyrektywy `!override` możemy polecić Compose użycie wyłącznie wartości z pliku nadpisującego.

docker-compose.yml:
```
services:
  app:
    image: nginx
    environment:
      FOO: "1"
      BAR: "2"
```

docker-compose.override.yml:
```
services:
  app:
    environment: !override
      BAZ: "3"

```

Po wykonaniu polecenia `docker compose config` zobaczymy, że ustawiona zostanie wyłącznie zmienna środowiskowa z pliku `docker-compose.override.yml`:

```
name: cdtmp-vbz3xw
services:
  app:
    environment:
      BAZ: "3"
    image: nginx
    networks:
      default: null
networks:
  default:
    name: cdtmp-vbz3xw_default
```
