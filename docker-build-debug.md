# Debug docker build

Migrując projekt na nowy bazowy obraz kontenera, otrzymywałem błąd podczas budowania obrazu podobny do poniższego.


> => ERROR [5/5] RUN /app/bin/console commnad-not-exists 1.0s
>
> \------
>
> \> [5/5] RUN /app/bin/console commnad-not-exists


Błąd ten nie występował z poprzednim bazowym obrazem. Korzystałem z dockera w wersji 24.0.5-ce, który domyślnie ma włączony mechanizm BuildKit.
Korzystając z BuildKit nie widzimy identyfikatorów kontenerów, poszczególnych etapów budowania obrazu.
Obecnie możemy wyłączyć i korzystać z starszego mechanizmu budowania obrazu ustawiając zmienną środowiskową `DOCKER_BUILDKIT=0`.
W takim przypadku otrzymamy identyfikator kontenera.


> Step 8/8 : RUN /app/bin/console command-not-exists
>
> ---> Running in 3143339121e5


Wywołując polecenie `docker ps -a | head -2` otrzymamy wynik podobny do poniższego:

> CONTAINER ID   IMAGE             COMMAND                  CREATED          STATUS                       PORTS    NAMES
> 
> d84ded8502a6   064b4a689561      "docker-php-entrypoi…"   27 seconds ago   Exited (0) 12 seconds ago             ecstatic_volhard

Interesuje nas identyfikator obrazu - `064b4a689561`. 
Znając identyfikator obrazu możemy uruchomić kontener i analizować problem `docker run -it 064b4a689561 bash`.

W przyszłości, jeśli nie będziemy w stanie wyłączyć mechanizm BuildKit to w pliku Dockerfile dodajemy `RUN sleep infinity` przed poleceniem, które nie wykonuje się poprawnie. Uruchamiamy proces budowania obrazu. Następnie szukamy identyfikatora procesu sleep - `ps -ef | grep sleep`:

> root     23214 23199  0 18:52 ?        00:00:00 /bin/sh -c sleep infinity
> root     23238 23214  0 18:52 ?        00:00:00 sleep infinity
> marcin   23767 14105  0 18:53 pts/5    00:00:00 grep --color=auto sleep

Widzimy, że proces sleep ma PID 23238. Wywołujemy polecenie `sudo nsenter -a -t 23238 bash`, aby uzyskać dostęp do powłoki. 
Wywołując polecenie `docker ps` jednak nie zobaczymy żadnego działającego kontenera podcas budowania obrazu.

Rozwiązanie z sleep infinity jest obecnie działającym obejściem: 

[always display image hashes #1053](https://github.com/moby/buildkit/issues/1053#issuecomment-564340155)

[[question] where to find intermediate image hashes? #742](https://github.com/docker/buildx/issues/742#issuecomment-902838322)
