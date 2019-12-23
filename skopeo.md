# skopeo

`skopeo` to narzędzie wiersza poleceń, które wykonuje operacje na obrazach kontenerów i ich repozytoriach.
Wykorzystałem je do synchronizacji obrazów docker'a między repozytorium w gitlab, a publicznym repozytorium dostarczanym przez docker'a. W przypadku, gdy mamy do przeniesienia dużą ilość obrazów te rozwiązanie może nam zaoszczędzić czas.

## sync

Nie udało mi się bezpośrednio synchronizować obrazów z gitlaba do hub'a dockera. Obraz z gitlaba zawierał także nazwę rejestru i projektu np. `registry.sensilabs.pl/sensilabs/ssorder` co powodowało problemy z autoryzacją i migracją. Postanowiłem wpierw synchronizować obrazy z lokalnym katalogiem, a dopiero wtedy przesłać je do publiczne repozytorium.

Wywołałem polecenie do synchronizacji rejestru z gitlab do lokalnego katalogu. W poleceniu podajemy nazwę użytkownika(`<username>` i  hasło `<password>`), który ma dostęp do repozytorium. To może być nasze konto, ale możemy także wykorzystać tzw. `deploy keys`.

`skopeo sync --src-creds <username>:<password> docker://registry.sensilabs.pl/sensilabs/ssorder dir:///home/marcin/projekty/dockersync`

Po paru minutach i pobraniu wszystkich obrazów byłem gotowy do przesłania ich do publicznego rejestru docker’a. Wywołałem polecenie synchronizacji lokalnego katalogu z hubem docker’a.
`skopeo sync --dest-creds <username>:<password> dir:///home/marcin/projekty/dockersync/registry.sensilabs.pl/sensilabs docker://docker.io/morawskim`
Podobnie jak poprzednio podałem `<username>` i `<password>` do rejestru. Docker obsługuje autoryzację przez token, więc zamiast hasła możemy podać wygenerowany token.

Po paru minutach obrazy zostały przesłane - https://hub.docker.com/r/morawskim/ssorder
