# docker - wiele uwierzytelnień dla tego samego rejestru

Włączając funkcję `docker registry` w gitlab, otrzymamy dla każdego projektu indywidualny token.
Na maszynie, gdzie chcemy wdrożyć obrazy dockera, możemy jednak przechowywać w pliku konfiguracyjnym dockera (albo w cred store) tylko jedno poświadczenie dla rejestru. Mając dwa tokeny, musimy ciągle się logować i wylogowywać. Jednak to nie rozwiązuje całkowicie problemu, bo może dojść do wyścigu.

Rozwiązaniem tego problemu jest poinstruowanie dockera, aby korzystał z różnych plików konfiguracyjnych.
Możemy stworzyć plik json z danymi uwierzytelniającymi ręcznie albo skorzystać z polecenia:
`docker --config ~/project1/config.json login registry.example.com -u <username>`

```
{
    "auths": {
        "registry.example.com": {
            "username": "<nazwaUzytkownika>",
            "password": "<haslo>"
        }
    }
}
```
Podobnie robimy to dla kolejnych projektów, ale dane konfiguracyjne dockera zapisujemy w innym katalogu.
Możemy też wygenerować plik json podczas uruchamiania zadania wdrożenia (wykorzystując zmienne środowiskowe gitlaba) i przesłać go na serwer dockera.

Podczas wywoływania standardowych poleceń dockera, musimy dodać globalny parametr `--config` z ścieżką do konfiguracji dockera - `docker --config ~/project1/config.json pull registry.example.com/project1`
