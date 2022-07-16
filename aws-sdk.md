# AWS SDK

Dokumentacja AWS zaleca korzystanie z klasy `Aws\Sdk` jako fabryki do budowania klientów do różnych usług AWS.
W przypadku Symfony w pliku `app/config/services.yaml` możemy dodać poniższą definicję usług:

```
aws_sdk:
    class: Aws\Sdk
    arguments:
        $args:
            region: eu-central-1
Aws\CloudWatch\CloudWatchClient:
    factory: [ '@aws_sdk', 'createCloudWatch' ]
    arguments:
        - version: '2010-08-01'

```

Dzięki temu parametr konfiguracyjny `region` podajemy tylko raz.
Klient CloudWatch otrzyma współdzielona konfigurację z `Aws\Sdk` i scali ją z przekazanymi parametrami.
W tym przypadku z wersją API CloudWatch.
Dodatkowo w przypadku korzystania z wielu usług AWS wszyscy klienci usług AWS otrzymają tą samą instancję klienta HTTP.

AWS zaleca jawnie zdefiniowaną wersję API, niż korzystanie z wartości `latest`.
Dostępne wersje API dla poszczegółnych usług znajdziemy w [dokumentacji](https://docs.aws.amazon.com/aws-sdk-php/v3/api/index.html)


## Proxy

Bardzo łatwo jest przekazać wszystkie requesty do usług AWS przez serwer proxy.
W konfiguracji SDK musimy tylko ustawić klucz `http` i w nim przekazać adres serwera proxy i certyfikat SSL.
Jeśli nie zależy nam na weryfikacji certyfikatów SSL to wartość klucza `verify` ustawiamy na `false`.

```
aws_sdk:
    class: Aws\Sdk
    arguments:
        $args:
            region: eu-central-1
            http:
                verify: /path/to/proxy/ca/mitmproxy-ca.pem
                proxy: http://ip-of-mitmproxy-or-another-proxy-server:8080
```
