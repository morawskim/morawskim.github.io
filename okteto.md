# Okteto

## Przykładowy szablon manifestu

### PHP

```
namespace: okteto
# the name of the Kubernetes deployment
name: podinfo
container: container-name
command: /usr/local/sbin/php-fpm --nodaemonize
metadata:
  annotations:
    fluxcd.io/ignore: "true"
    kustomize.toolkit.fluxcd.io/reconcile: disabled
sync:
  - .:/app
persistentVolume:
  enabled: false
forward:
  - localPort:remoteService:remotePort
reverse:
  - remotePort:localPort
secrets:
  - $HOME/.composer/auth.json:/root/.composer/auth.json:400
environment:
  XDEBUG_TRIGGER: default_no_matter
  XDEBUG_MODE: develop,debug
  PHP_IDE_CONFIG:serverName=some-name

```

### Go

```
namespace: default
# the name of the Kubernetes deployment
name: some-name
image: okteto/golang:1
command: bash

metadata:
  annotations:
    fluxcd.io/ignore: "true"
    kustomize.toolkit.fluxcd.io/reconcile: disabled

persistentVolume:
  enabled: true
volumes:
  - /go
sync:
  - .:/usr/src/app

securityContext:
  capabilities:
    add:
      - SYS_PTRACE

forward:
  - 2345:2345
```

## Problemy z synchronizacją plików

Aby ręcznie wymusić synchronizację plików musimy się zalogować do interfejsu webowego Syncthing. Wywołujemy polecenie `okteto status --info`. Otrzymamy wynik podobny do poniższego:

```
 i  Using okteto @ minikube as context
 i  Local syncthing url: http://0.0.0.0:43463
 i  Remote syncthing url: http://0.0.0.0:40777
 i  Syncthing username: okteto
 i  Syncthing password: 63c787e7-3a16-4f6a-9c74-02ffc3533e44
 ✓  Synchronization status: 100.00%
```
Otwieramy w przeglądarce adres wyświetlony przy `Local syncthing url` i logujemy się podając `Syncthing username` i `Syncthing password` i klikamy w przycisk `Rescan All`. Możemy także zobaczyć ostatnio zmodyfikowane pliki klikając w przycisk `Recent Changes`.

## Wolumeny

Wolumeny pozwalają nam przechowywać trwale dane np. pamięć podręczna composera.
Do pliku manifestu okteto dodajemy:
```
volumes:
    - /root/.composer/cache
```

`persistVolume.enabled` musi mieć wartość true, jeśli używamy wolumenów.

## Notatki

* Za pomocą polecenia `okteto context` możemy wybrać z którego kontekstu kubectl ma korzystać okteto. Wywołując polecenie `okteto up` widzimy z którego kontekstu korzysta okteto `Using mmorawski @ arn:aws:eks:eu-central-1:139536746838:cluster/k8s-dev9 as context`. Aby wyświetlić wszystkie dostępne konteksty dla kubectl wywołujemy polecenie `kubectl config get-contexts`.

* W manifeście okteto możemy korzystać z parametru `autocreate` (domyślnie `false`) kiedy deployment nie istnieje w klastrze kubernetes. Może to być przydatne jako obejście dla aplikacji, które nie zostały jeszcze w pełni przeniesione do Kubernetesa.

* Obecnie okteto 2.4 (i wcześniejsze wersje) mają problem z przekierowaniem portów w przypadku gdy usługa nasłuchuje tylko na interfejsie z adresem IPv6.

* W pliku manifestu możemy skorzystać z parametru `imagePullPolicy`. Domyślna wartość to `Always`. Ustawiając wartość `IfNotPresent` możemy ograniczyć liczbę requestów do API Docker hub w przypadku deploymentów z ściśle określonym tagiem obrazu, który jest immutable.
