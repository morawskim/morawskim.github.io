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
