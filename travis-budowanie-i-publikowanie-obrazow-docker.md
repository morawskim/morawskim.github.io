# travis - budowanie i publikowanie obrazów docker

W panelu konfiguracyjnym travis tworzymy dwie zmienne środowiskowe `DOCKER_USERNAME` i `DOCKER_PASSWORD`.
Przechowują one dane autoryzacyjne do naszego konta w docker hub. Obecnie docker hub nie obsługuje autoryzacji przez token - https://github.com/docker/hub-feedback/issues/1419. Musimy więc podać nasz login i hasło.

Następnie do pliku `.travis.yml` dodajemy usługę docker:
```
services:
  - docker
```

Tworzymy zadanie, które w kluczu `script`, będzie wykonywać nasze polecenia do budowy i publikowania obrazu dockera.

```
script:
    - echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
    - docker build -t morawskim/pipeline-scripts .
    - docker push morawskim/pipeline-scripts
```

Więcej informacji [https://docs.travis-ci.com/user/docker/](https://docs.travis-ci.com/user/docker/)
