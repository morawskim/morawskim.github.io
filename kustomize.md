# Kustomize

Obecnie Kubernetes posiada wbudowane wsparcie dla Kustomize.

[Dokumentacja](https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/)

[Przykłady](https://github.com/kubernetes-sigs/kustomize/tree/master/examples)

## Szablon

```
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: mmorawski
resources:
  - ../base/project
patchesStrategicMerge:
  - my-patch.yaml
```

## Kasowanie zasobu dołączonego przez base

W pliku patch musimy ustawić dyrektywę `$patch` na wartość `delete` i wybrać zasób do skasowania.

```
$patch: delete
apiVersion: v1
kind: <RODAJ ZASOBU>
metadata:
  name: <NAZWA>
```

Zamiast tworzyć nowy plik możemy skasować zasób bezpośrednio dodając wpis w `patchesStrategicMerge`

```
patchesStrategicMerge:
  - |-
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: my-app-deployment
    $patch: delete

```

## Zmiana tagu obrazu kontenera

Za pomocą kustomize jesteśmy w stanie podmienić obraz z base na inny.
Przykład poniżej zamienia wersję obrazu `xxxxx.dkr.ecr.eu-central-1.amazonaws.com/repository-name` na `develop-123`.
Tag zostanie podmieniony dla każdego kontenera korzystającego z tego obrazu.
Możemy także podmienić obraz - wtedy korzystamy z klucza `newName`.

[Change image names and tags](https://github.com/kubernetes-sigs/kustomize/blob/master/examples/image.md)

```
# ...

images:
  - name: xxxxx.dkr.ecr.eu-central-1.amazonaws.com/repository-name
    newTag: develop-123

```
