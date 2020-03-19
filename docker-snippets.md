# docker - snippets

## Dostanie się na kontener z uprawnieniami roota

Niektóre obrazy dockera zawierają dyrektywę `USER`. Dzięki niej proces(y) działające w kontenerze nie działają z uprawnieniami użytkownika root. Niestety logując się na taki kontener (przez docker exec) trafiamy na konto zwykłego użytkownika. Czasami potrzebujemy jednak dostępu root.

Możemy się zalogować na konto root w kontenerze ustawiając parametr `--user` na wartość `root` przy wywołaniu `docker exec`. Jak w poniższym poleceniu.

```
docker exec -it --user root rocketchat_rocketchat_1 bash
```

Po wywołaniu polecenia uruchomi się powłoka bash z uprawnieniami użytkownika root, anie rocketchat.

## Budowanie obrazków bez korzystania z warstw buforowanych (cached)

W momencie, kiedy niezbędne jest zbudowanie obrazku od podstaw, na przykład chcemy wymusić aktualizacje systemu musimy wyłączyć korzystanie z warstw buforowanych.

Robimy to dodając parametr `--no-cache` do polecenia `docker build`.
```
docker build -t test --no-cache .
```

## Wczytanie dump'a bd na kontener (docker-compose)

```
docker exec -i $(docker-compose ps -q mysql) mysql -uroot -ppassword  -D DBNAE < dump.sql
```

## Pokaż całkowitą przestrzeń dyskową używaną przez Docker

Wywołując polecenie `docker system df` możemy zobaczyć ile miejsca zajmują poszczególne elementy dockera.

```
TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE
Images              29                  22                  10.01GB             2.556GB (25%)
Containers          36                  7                   252.2MB             155.6MB (61%)
Local Volumes       90                  11                  10.1GB              2.1GB (20%)
Build Cache                                                 0B                  0B
```
Do polecenia możemy także dodać flage `-v` (verbose). W takim przypadku zobaczymy szczegółowe informacje.
```
Images space usage:

REPOSITORY                         TAG                            IMAGE ID            CREATED ago         SIZE                SHARED SIZE         UNIQUE SiZE         CONTAINERS
edbizarro/gitlab-ci-pipeline-php   7.2                            57dd2e743e0f        29 hours ago ago    747.4MB             0B                  747.4MB             0
project_php                        latest                         4ee5878fc103        4 days ago ago      380.8MB             380.8MB             42B                 1
phpstorm_helpers                   PS-183.4284.150                52f8b943c1f0        4 days ago ago      1.28MB              1.154MB             125.2kB             1
busybox                            latest                         758ec7f3a1ee        5 days ago ago      1.154MB             1.154MB             0B                  0
gitlab/gitlab-runner-helper        x86_64-f100a208                be0981921bd1        9 days ago ago      43.67MB             0B                  43.67MB             1
plantuml/plantuml-server           tomcat                         4df75ac78ecf        9 days ago ago      717.4MB             0B                  717.4MB             1
ssorder_ssorder                    latest                         abe4f3b57467        9 days ago ago      479MB               356.7MB             122.3MB             1
<none>                             <none>                         2f4b46ef808f        9 days ago ago      799.5MB             264.6MB             534.8MB             0
....

Containers space usage:

CONTAINER ID        IMAGE                                      COMMAND                  LOCAL VOLUMES       SIZE                CREATED ago         STATUS                      NAMES
82d81b878fe8        ssorder_ssorder                            "docker-php-entryp..."   0                   96.6MB              2 hours ago ago     Up 2 hours                  ssorder_ssorder_1
d6d6f77c32eb        mysql:5.6                                  "docker-entrypoint..."   0                   2B                  2 hours ago ago     Up 2 hours                  test_mysql_1
d812ea6da4fb        traefik:1.5                                "/traefik --web --..."   0                   0B                  .....

Local Volumes space usage:

VOLUME NAME                                                        LINKS               SIZE
25f913f0369b39fb0f13253f03a3a99d797749aade69bd48e7563f43c3805805   0                   0B
47e10963c763f88b3705f4661dc4e68b7d19fede47b5beaf354a7345162439ff   0                   315.2MB
7374e81449064fdc73ca33dc95ee5550f6b5c844de2b2787247ae98fc8b70ebc   0                   314.7MB
7fc922c55260fb752c95720fc993b7ed2684d5e3af1f0d7619722051e8518f92   0                   0B
af4354f48a99a6ef1c21f055a03ed59c89b468feb370243f06d3d019794153a2   1                   78.49kB
b9ed15c31622187704061db5291dd5de3627dcd9640eac94346d80537494e8ba   0                   0B
project_phpstorm_helpers_PS-183.4284.150                           1                   125.2kB
15b93c203d766a241fadbd36dfd4879e492a87427ff4f4d3a1a2d8cdd3bfefbd   0                   124.9kB
0367cf59f3353a344f6f75784bf85041220fd27be4a8e43dbf9c42a0f702327e   1                   0B
6627659aca923f475dbe29590805e7436eb69d884b2a05e2e0fd7acf7fc8fd81   0                   0B
b4cefa2f850f9632afdb63beb90c6d1b9db8540db680491da4cd921674310c3b   0                   0B
.....

Build cache usage: 0B
```

## docker-compose config

Polecenie `docker-compose config` ma dwa zadania. Po pierwsze weryfikuje poprawność pliku/plików `docker-compose.yml`. Po drugie wyświetla na wyjściu końcowy plik yml. Jeśli nadpisujemy konfigurację poprzez `docker-override.yml` to zobaczymy połączony plik yaml. Dodatkowo wszystkie wartości zmiennych środowiskowych zostaną podstawione.

## Pobranie specyficznej wersji obrazu

`docker pull ubuntu@sha256:HASH`

## Kasowanie lokalnej bazy z konfiguracją sieci dockera

Plik z bazą danych nazwany jest `local-kv.db` i jest przechowywany w katalogu `/var/lib/docker/network/files`.

## Wymagania docker

Do poprawnego działania docker'a wymagane są włączone parametry jądra `namespaces` i `cgroups`.
Za pomocą poleceń `zgrep -i namespace /proc/config.gz` i  `zgrep -i cgroups /proc/config.gz` uzyskamy odpowiedź, czy jądro jest skompilowane z odpowiednimi parametrami. W wyniku tych poleceń powinniśmy widzieć `CONFIG_NAMESPACES=y` i `CONFIG_CGROUPS=y`. Dodatkowo docker może korzystać z device-mapper. Aby sprawdzić czy jądro obsługuje ten typ urządzenia wywołujemy polecenie `grep device-mapper /proc/devices`. W przypadku powodzenia uzyskamy wynik podobny do  `254 device-mapper`. Dodatkowo możemy wywołać polecenie `docker info`, które wyświetli obsługiwane tryby sieci, sterownik magazynu (ang. storage driver) itp. Dodatkowo w przypadku problemu z konfiguracją jądra otrzymamy ostrzeżenia.
