# microk8s

## refresh-certs

Próbując wdrożyć nową aplikację (poleceniem `kubectl apply -k prod`) otrzymałem komunikat:

> error: error validating "prod": error validating data: failed to download openapi: Get "https://127.0.0.1:16443/openapi/v2?
timeout=32s": tls: failed to verify certificate: x509: certificate has expired or is not yet valid: current time 2025-01-19
T14:32:09+01:00 is after 2025-01-15T14:38:14Z; if you choose to ignore these errors, turn validation off with --validate=fa
lse

Możemy zignorować walidację certyfikatu x509 dodając flagę `--insecure-skip-tls-verify`
Jednak docelowo należy wygenerować nowe certyfikaty dla serwera i API.

Logujemy się na maszynę, gdzie mamy zainstalowany microk8s i wywołujemy polecenie `sudo microk8s refresh-certs -c`
W moim przypadku otrzymałem:

>The CA certificate will expire in 3281 days.
The server certificate will expire in -4 days.
The front proxy client certificate will expire in -4 days

Generujemy nowe certyfikaty poleceniami:

`sudo microk8s refresh-certs -e server.crt`
`sudo microk8s refresh-certs -e front-proxy-client.crt`


Następnie sprawdzamy czy faktycznie certyfikaty zostały wygenerowane `sudo microk8s refresh-certs -c`

> The CA certificate will expire in 3281 days.
The server certificate will expire in 364 days.
The front proxy client certificate will expire in 364 days.

Komunikacja z API Kubernetes przez narzędzie kubectl nie powinno już zwracać błędów z nieważnym certyfikatem x509.

## Aktualizacja klastra z jednym węzłem

Na maszynie z Ubuntu miałem zainstalowany klaster Kubernetes w postaci pakietu snap microk8s.
Aby zaktualizować wersję Kubernetesa, należy wykonać polecenie: `sudo snap refresh microk8s --channel=1.32/stable`
Dostępne wersje Kubernetesa można sprawdzić poleceniem: `snap info microk8s`

Podczas aktualizacji Kubernetesa nie są automatycznie aktualizowane włączone dodatki microk8s.
Listę aktualnie włączonych dodatków można wyświetlić poleceniem: `microk8s status`

Przykładowy wynik:
>microk8s is running
high-availability: no
  datastore master nodes: 127.0.0.1:19001
  datastore standby nodes: none
addons:
  enabled:
    dns                  # (core) CoreDNS
    #....
  disabled:
    cert-manager         # (core) Cloud native certificate management
    # ....

Aby zaktualizować dodatki, należy je najpierw wyłączyć (`microk8s disable <add-on>`), a następnie ponownie włączyć (`microk8s enable <add-on>`).

[Upgrading MicroK8s](https://canonical.com/microk8s/docs/upgrading)

## Snippets

Lista obrazów kontenerowych zapisanych w wbudowanym rejestrze microk8s - `microk8s ctr images ls`
