# Okteto

## Przykładowy szablon manifestu

```
namespace: okteto
# the name of the Kubernetes deployment
name: podinfo
container: container-name
command: /usr/local/sbin/php-fpm --nodaemonize
# The local port to use for SSH communication with your development environment
remote: 2222
metadata:
  annotations:
    fluxcd.io/ignore: "true"
sync:
  - .:/app
persistentVolume:
  enabled: false
forward:
  - localPort:remoteService:remotePort.
reverse:
  - remotePort:localPort
secrets:
  - $HOME/.composer/auth.json:/root/.composer/auth.json:400
environment:
  XDEBUG_TRIGGER: default_no_matter
  XDEBUG_MODE: develop,debug
  PHP_IDE_CONFIG:serverName=some-name

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
