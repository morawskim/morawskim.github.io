Docker - kopiowanie pliku
=========================

Wyświetlamy wszystkie uruchomione kontenery

``` bash
docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
d6366e3c6380        opensuse:42.2       "bash"              5 days ago          Up 3 seconds                            elegant_leakey
```

Kopiujemy plik foo.txt do kontenera elegant_leakey:/foo.txt

``` bash
docker cp foo.txt elegant_leakey:/foo.txt
```

Podłączamy się pod kontener i wyświetlamy zawartość pliku

``` bash
docker exec -it elegant_leakey bash
bash-4.3# cat /foo.txt
foo
bash-4.3#
```