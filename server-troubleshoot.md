# Server troubleshoot

## Wysokie zużycie CPU - Ubuntu 20.04 LTS, docker swarm i cloud-init

Na serwerze Ubuntu w chmurze, obciążenie CPU było bardzo wysokie (https://gorgon.service.eu.newrelic.com/image/bea6410d-8c73-48da-a42a-099c99a4eddc?type=line).
Wywołując polecenie `top` można było zauważyć wiele działających procesów `cloud-init`.
Jest to znany błąd między kontenerami docker, a cloud-init - [Multiple instances of /usr/bin/cloud-init using a lot of CPU](https://askubuntu.com/questions/1376496/multiple-instances-of-usr-bin-cloud-init-using-a-lot-of-cpu)
W moim przypadku miałem zainstalowaną wersję `21.3`. Za aktualizowałem pakiet do najnowszej wersji `apt-get install cloud-init`.
Po aktualizacji obciążenie CPU spadło. Dodatkowo jeden z kontenerów ciągle był resetowany.
Wyeliminowanie problemu z resetowanym kontenerem rozwiązało całkowicie problem.
