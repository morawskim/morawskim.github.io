# Kontrolowanie gotowości usług w Docker Compose

Jeśli korzystamy z `docker-compose` natrafimy na problem połączenia się z np. kontenerem bazy danych, który nie jest jeszcze gotowy na połączenia klientów.
W takim przypadku możemy użyć jednego z wielu implementacji skryptów [wait-for-docker](https://github.com/vishnubob/wait-for-it). Inne rozwiązanie to dodać nową usługę w pliku `docker-compose.yml`.
Wystarczy dodać definicję usługi `wait` do pliku `docker-compose.yml`. Wykorzystamy obraz [dokku/wait](https://hub.docker.com/r/dokku/wait), który waży tylko 9MB.
```
wait:
    image: dokku/wait
```

Następnie możemy sprawdzić czy usługa `mongo` jest gotowa i nasłuchuje na przychodzące połączenia TCP za pomocą polecenia `docker-compose run --rm wait -c mongo:27017 -t 15` Parametr `-t 15` ustawia timeout na 15 sekund.
Możemy także czekać na wiele usług na raz `docker-compose run --rm wait -c mysql:3306,redis:6379`

W przypadku, gdy usługa jest gotowa zobaczymy komunikat:
```
Waiting for mongo:27017  .  up!
Everything is up
```

W przypadku, gdy usługa nie jest gotowa i przekroczymy wartość parametru timeout dostaniemy:
```
Waiting for mongo:2701  ................  ERROR: unable to connect
```
Dodatkowo kod wynikowy procesu będzie wynosił `1`.
