# docker pull - x509: certificate signed by unknown authority

Jeśli podczas pobierania obrazu z wewnętrznego repozytorium obrazów docker'a otrzymamy błąd `Error response from daemon: Get https://[DOMENA]/v2/: x509: certificate signed by unknown authority` to możemy ten problem rozwiązać dodając certyfikat do zaufanych dla doker'a. [Innym rozwiązaniem jest globalne zainstalowanie tego certyfikatu.](linux-globalne-dodanie-zaufanego-certyfikatu-ssl.md)

Plik z certyfikatem przenosimy do katalogu (jeśli nie istnieje to go tworzymy) `/etc/docker/certs.d/[DOMENA]/` pod nazwą `ca.crt`.
Po tym możemy już pobierać obrazy z tego repozytorium.
