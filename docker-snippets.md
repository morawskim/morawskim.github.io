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