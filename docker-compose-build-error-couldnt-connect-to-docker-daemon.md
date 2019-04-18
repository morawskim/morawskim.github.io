# docker-compose build - ERROR: Couldn't connect to Docker daemon

W projekcie zaktualizowałem plik `Dockerfile` i próbowałem ponownie zbudować obraz poleceniem `docker-compose build`.
Jednak otrzymałem błąd:
```
traefik uses an image, skipping
mysql uses an image, skipping
Building blog
ERROR: Couldn't connect to Docker daemon at http+docker://localunixsocket - is it running?
```

Oczywiście usługa dockerd była uruchomiona. Mogłem wywołać bez problemu polecenie `docker info`.
Postanowiłem wykorzystać polecenie `docker build` i sprawdzić czy otrzymam jakiś bardziej szczegółowy błąd.

```
docker build -tblog_blog   .
error checking context: 'no permission to read from '/home/marcin/projekty/audyt/blog/.r/mysqldata/auto.cnf''.
```

Tym razem błąd był jasny. Dodałem plik `.dockerignore` z regułą wykluczającą katalog `.r/`.
Dzięki temu mogłem znów zacząć budować obrazy za pomocą polecenia `docker-compose build`.
