# Docker - dołączanie do przestrzeni procesów kontenera

Obrazy dokera są lekkie. Nie zawierają niepotrzebnych narzędzi, działają z minimalistyczną dystrybucją np. alpine. Tym samym brakuje w nich podstawowych narzędzi do debugowania i rozwiązywania problemów. Domyślnie docker, uruchamia kontener w izolacji - oddzielnej przestrzeni procesów. Na szczęście możemy podłączyć się do tej przestrzeni z innego kontenera, który ma więcej programów. Wystarczy dodać argument `-pid "container:<name_or_id>"`. Dzięki temu z poziomu nowego kontenera, możemy debugować/śledzić procesy problematycznego kontenera.

```
docker run --rm --pid "container:ID_OR_NAME" opensuse/leap:15.0 bash
```

## Dołączanie do przestrzeni gospodarza (hosta)

```
docker run --rm --pid host opensuse/leap:15.0 bash
```
