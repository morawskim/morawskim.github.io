# certbot - snippets

## Fake LE Intermediate X1

Jeśli certyfikat jest wydany przez `Fake LE Intermediate X1` oznacza to, że połączyliśmy się z serwerem testowym do wystawiania certyfikatów SSL.
W pliku `/etc/certbot/cli.ini` komentujemy linie z adresem serwera testowego i odkomentujemy linię z adresem serwera produkcyjnego.

```
# The staging/testing server
# server = https://acme-staging.api.letsencrypt.org/directory
# The production server.
server = https://acme-v01.api.letsencrypt.org/directory
```

Certyfikat produkcyjny musi być wystawiony przez organizację Let's Encrypt.


## Generowanie certyfikatu SSL dla domeny z adresem prywatnym

```
certbot -d ssorder.work.morawskim.pl --manual --preferred-challenges dns certonly
```

Zostaniemy poproszeni o utworzenie rekordu TXT dla subdomeny `_acme-challenge.ssorder.work.morawskim.pl`.

```
Please deploy a DNS TXT record under the name
_acme-challenge.ssorder.work.morawskim.pl with the following value:

JAKAS-WARTOSC

Before continuing, verify the record is deployed.
```

Po weryfikacji certyfikat znajduje się w `/etc/certbot/archive/DOMENA`.


## Generowanie certyfikatu wildcard

Aby móc wygenerować certyfikat wildcard muszą być spełnione następujące warunki:
* certbot w wersji >= 0.22
* certyfikat musi być wygenerowany przez APIv2 (https://acme-v02.api.letsencrypt.org/directory)

Jeśli w pliku konfiguracyjnym certbota korzystamy z apiv1 to podczas wywoływania certbota możemy nadpisać ten parametr. Dodając argument `--server https://acme-v02.api.letsencrypt.org/directory`

```
certbot -d *.morawskim.pl -d morawskim.pl --manual --preferred-challenges dns certonly
```

## certonly

`certbot certonly --standalone --agree-tos --email your_email -d your_domain`

Powyższe polecenie pobierze certyfikat SSL bez wykonywania innych zmian w systemie wykorzystując wbudowany serwer HTTP.
