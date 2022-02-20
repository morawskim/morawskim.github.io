# Dockerfile najlepsze praktyki

[Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

## Entrypoint

```
#!/bin/bash
set -e

if [ "$1" = 'postgres' ]; then
    # some commands need to setup
    exec gosu postgres "$@"
fi

exec "$@"
```

[ENTRYPOINT](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#entrypoint)

[Docker Tips: Running a Container With a Non Root User](https://medium.com/better-programming/running-a-container-with-a-non-root-user-e35830d1f42a)

## Laravel setfacl

W frameworku [Symfony ustawia się odpowiednią wartość `umask`](https://github.com/symfony/recipes/blob/9a7f5bcebbda2f5244c4be4133a6bd181080cbea/symfony/framework-bundle/4.4/public/index.php#L9) aby pliki utworozne przez proces PHP, były także do odczytu dla innych użytkowników.

W przypadku frameworka Laravel spotkałem się z konwencją wywoływania polecenia `setfacl` dla katalogu projektu w Dockerfile 
`setfacl -Rdm o::rwx /var/www/html`.
