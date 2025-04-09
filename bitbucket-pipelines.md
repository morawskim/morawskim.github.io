# Bitbucket pipelines

## Obraz thecodingmachine/php

Podczas korzystania z obrazu [thecodingmachine/php](https://github.com/thecodingmachine/docker-images-php) w Bitbucket Pipelines napotykamy problem z [instalacją rozszerzeń PHP](https://github.com/thecodingmachine/docker-images-php/issues/89).

Bitbucket nadpisuje `ENTRYPOINT` obrazu, co uniemożliwia automatyczne instalowanie rozszerzeń PHP.
Aby obejść ten problem, konieczne jest ręczne wywołanie skryptu `docker-entrypoint.sh`,
eksportując wcześniej zmienną środowiskową `PHP_EXTENSIONS` z listą wymaganych rozszerzeń.

```
pipelines:
  default:
    - parallel:
        - step:
            name: PHP step
            image: thecodingmachine/php:8.4-v4-cli-node20
            script:
              - export PHP_EXTENSIONS='pdo_sqlite sqlite3'
              - /usr/local/bin/docker-entrypoint.sh echo init
              - php -m
              - echo $PHP_EXTENSIONS
```
