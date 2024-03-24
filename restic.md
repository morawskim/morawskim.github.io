# Restic

Restic tworzy kopie zapasowe plików i przechowuje je w "repozytoriach", które są zabezpieczone hasłem.
Obsługuje wiele silników np. S3 czy SFTP.

Korzystając z restic, musimy niemal zawsze podawać parametr z adresem do repozytorium, albo
możemy przechowywać tą wartość w zmiennej środowiskowej `RESTIC_REPOSITORY`.

Tworzymy repozytorium, które przechowuje dane w AWS S3 `restic init -r s3:s3.amazonaws.com/<bucket-name> init`
Podczas tworzenia nowego repozytorium zostaniemy poproszeni o hasło.
Jeśli nie chcemy go podawać przy każdej operacji z repozytorium, możemy hasło przechowywać w zmiennej środowiskowej `RESTIC_PASSWORD`.

Możemy przetestować tworzenie kopii zapasowej z danych stdin `echo "aa" | restic -r s3:s3.amazonaws.com/<bucket_name>/<path> backup --stdin --stdin-filename test` (jeśli wcześniej wyeksportowaliśmy zmienną `RESTIC_REPOSITORY` możemy pominąć parametr `-r`)

Jeśli nie ustawiliśmy zmiennej środowiskowej 'RESTIC_PASSWORD' to otrzymamy błąd:
> Fatal: cannot read both password and data from stdin

W przypadku otrzymania błędu:

> Fatal: unable to open config file: Stat: Head https://<bucket-name>.s3.dualstack.us-east-1.amazonaws.com/<path>/config: 301 response missing Location header
Is there a repository at the following location?

prawdopodobnie nie mamy wyeksportowanej zmiennej `AWS_DEFAULT_REGION`/`AWS_REGION` (nie mamy skonfigurowanego awscli).
Inne rozwiązanie to przekazanie regionu przy wywołaniu restic: `-o s3.region="eu-central-1"`

Możemy zamontować zawartość ostatniej utworzonej kopii w katalogu `~/mnt` poleceniem `restic -r s3:s3.amazonaws.com/<bucket-name>/<path> mount ~/mnt`

## Dockerfile

Możemy skorzystać z gotowego obrazu [Tools to create backup of mysql and store it in AWS S3](https://hub.docker.com/r/morawskim/restic-aws-backup). 

Albo zbudować własny:

```
FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get -y install \
        mysql-client restic pigz \
        --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
```
