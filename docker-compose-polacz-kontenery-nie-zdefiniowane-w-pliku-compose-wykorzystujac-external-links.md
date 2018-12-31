# Docker Compose - połącz kontenery nie zdefiniowane w pliku compose wykorzystując external_links

## Urzywając zewnętrznych sieci (kontener zdefiniowany w innym pliku docker-compose)

Wpierw musimy poznać nazwę sieci, którą utworzył docker dla drugiego pliku `docker-compose`.
W moim przypadku, plik `docker-compose.yml` znajdował się w katalogu test, więc sieć nazywa się `test-default`.
Wywołując polecenie `docker network ls` zobaczymy utworzone i dostępne sieci dockera.

```
NETWORK ID          NAME                 DRIVER              SCOPE
2a7be3b644e1        bridge               bridge              local
f9150e758ad4        gollfront_default    bridge              local
75149565020b        host                 host                local
8ac8acac3b59        noipclient_default   bridge              local
61c42305e922        none                 null                local
0801c5dbd65b        project_default      bridge              local
0c1a9fc1c82e        ssorder_default      bridge              local
9b7fc2890310        test_default         bridge              local
```

Następnie musimy poznać nazwę kontenera, do którego chcemy się podłączyć.
Wywołujemy polecenie `docker-compose ps` będąc w katalogu, gdzie znajduje się plik docker-compose.

```
    Name                 Command             State           Ports
---------------------------------------------------------------------------
test_mysql_1   docker-entrypoint.sh mysqld   Up      0.0.0.0:3308->3306/tcp
```
Nazwa naszego kontenera do którego chcemy się połączyć to `test_mysql_1`.

Wracamy do naszego głównego pliku docker-compose.yml.
Musimy dodać definicję sieci.
```
.....
networks:
    test_default:
        external: true
```

Prócz tego do definicji usługi musimy dodać dwa klucze `external_links` i `networks`.
A także skasować powiązanie z sekcji `links`, jeśli używamy tego samego aliasu.

```
....
services:
  ssorder:
    external_links:
      - test_mysql_1:mysql
    networks:
      - default
      - test_default
....
```
Dzięki tym zmianom, z kontenera ssorder możemy połączyć się z kontenerem `mysql` zdefiniowanym w innym pliku docker-compose.


## Ustawienie trybu sieci kontenerów na bridge (wykorzystanie interfejsu docker0 bridge)

Innym sposobem połączenia konenerów z różnych sieci, jest rezygnacja z izolacji sieci.
W takim przypadku kontenery, które mają się ze sobą komunikować muszą mieć ustawiony tryb sieci `network_mode` na `bridge`.

```
...
services:
...
  php:
    ...
    network_mode: bridge
    external_links:
      - test_mysql_1:mysql
```

```
...
services:
...
  mysql:
    ...
    network_mode: bridge
```


## docker run

Wywołując polecenie `docker run` z parametrem `network` możemy podłączyć nowo tworzony kontener do izolowanej sieci. Jeśli docker utworzył nam sieć `ssorder_default` to aby podłączyć się do tej sieci wywołując polecenie `docker run -it --rm --network=ssorder_default [OBRAZ] [CMD]`.
