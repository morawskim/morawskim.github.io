# skopeo

`skopeo` to narzędzie wiersza poleceń, które wykonuje operacje na obrazach kontenerów i ich repozytoriach.
Wykorzystałem je do synchronizacji obrazów docker'a między repozytoriami w gitlab. Można także użyć publicznego repozytorium docker'a. W przypadku, gdy mamy do przeniesienia dużą ilość obrazów te rozwiązanie może nam zaoszczędzić czas.

## sync

Nie udało mi się bezpośrednio synchronizować obrazów z gitlaba do hub'a dockera. Obraz z gitlaba zawierał także nazwę rejestru i projektu np. `registry.sensilabs.pl/sensilabs/ssorder` co powodowało problemy z autoryzacją i migracją. Postanowiłem wpierw synchronizować obrazy z lokalnym katalogiem, a dopiero wtedy przesłać je na publiczne repozytorium.

Wywołałem polecenie do synchronizacji rejestru z gitlab do lokalnego katalogu. W poleceniu podajemy nazwę użytkownika(`<username>` i  hasło `<password>`), który ma dostęp do repozytorium. To może być nasze konto, ale możemy także wykorzystać tzw. `deploy keys`.

`skopeo sync --src-creds <username>:<password> --src docker --dest dir registry.sensilabs.pl/sensilabs/ssorder /home/marcin/projekty/dockersync`

Po paru minutach i pobraniu wszystkich obrazów byłem gotowy do przesłania ich do innego rejestru docker’a. Wywołałem polecenie synchronizacji lokalnego katalogu z repozytorium gitlab.
`skopeo sync --dest-creds <username>:<password> --src dir --dest docker /home/marcin/projekty/dockersync/ registry.gitlab.com/morawskim/ssorder`
Podobnie jak poprzednio podałem `<username>` i `<password>` do rejestru. Gitlab obsługuje autoryzację przez token, więc zamiast hasła możemy podać [wygenerowany token](https://gitlab.com/help/user/profile/personal_access_tokens).
Nic nie stoi na przeszkodzenie, aby obrazy dockera przesłać do oficjalnego repozytorium dockera. W takim przypadku jako destination podajemy adres huba dockera np. `docker.io/morawskim`.

[Po paru minutach obrazy zostały przesłane](https://gitlab.com/morawskim/ssorder/container_registry/)
