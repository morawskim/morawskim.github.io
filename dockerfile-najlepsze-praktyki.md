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
