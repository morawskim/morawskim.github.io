# Dodawanie własnych rekordów DNS w Kubernetes

W jednym z projektów w moim homelabie potrzebowałem dodać dodatkowe wpisy do pliku `/etc/hosts` w konkretnym Podzie.

Dzięki temu aplikacja mogła odwoływać się do wybranych usług po nazwie, a mechanizm load balancera oparty o nagłówek Host w żądaniu HTTP poprawnie kierował ruch do odpowiedniego backendu.

W moim przypadku nie mogłem dodać odpowiednich rekordów do serwera DNS, ponieważ dostawca internetu nie udostępnia dostępu do panelu administracyjnego routera.

Plik `/etc/hosts` służy do lokalnego mapowania nazw hostów na adresy IP.
Jest sprawdzany przed wysłaniem zapytania do serwera DNS, dzięki czemu można lokalnie nadpisywać lub definiować rekordy DNS.

Kubernetes umożliwia dodanie własnych wpisów do pliku `/etc/hosts` za pomocą pola `hostAliases`.
Aby dodać własne mapowania nazw hostów, wystarczy umieścić sekcję `hostAliases` w specyfikacji Poda, np. w zasobie Deployment:

```
apiVersion: apps/v1
kind: Deployment
spec:
  template:
    spec:
      # ...
      hostAliases:
        - ip: "192.168.XXX.YYY"
          hostnames:
          - "domain.example.com"
```

[Adding entries to Pod /etc/hosts with HostAliases](https://kubernetes.io/docs/tasks/network/customize-hosts-file-for-pods/)
