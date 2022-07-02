# netshoot

`netshoot` to obraz kontenera dla Docker i Kubernetes, który zawiera wiele narzędzi do rozwiązania problemów sieciowych.
Możemy go pobrać z oficialnego repozytorium dockera podając nazwę `nicolaka/netshoot`.

[Strona projektu](https://github.com/nicolaka/netshoot)

## Polecenia

`kubectl run netshoot --rm -it --image nicolaka/netshoot`

`docker run -it --net container:<container_name> nicolaka/netshoot`
