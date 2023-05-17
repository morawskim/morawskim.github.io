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

## JSON patch i SealedSecret

Korzystając z JSON patch możemy w łatwy sposób zmodyfikować zasoby Kubernetesa.
W tym przypadku dodajemy kolejny zaszyfrowany sekret do zasobu SealedSecret.

```
patches:
  - path: secret.json
    target:
      kind: SealedSecret
      name: my-secrets
```

W pliku `secret.json` korzystamy z operatora "add" do dodania nowego elementu:

```
[
  { "op": "add", "path": "/spec/encryptedData/MY_PASSWORD", "value": "encrypted-value" }
]
```

Możemy także w pliku `kustomization.yaml` skorzystać z inline patch definition:

```
patches:
  - patch: |-
      - op: add
        path: /spec/encryptedData/MY_PASSWORD
        value: encrypted-value
    target:
      kind: SealedSecret
      name: my-secrets
```

Plik zasobu przed wprowadzeniem zmian:

```
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  annotations:
    sealedsecrets.bitnami.com/cluster-wide: "true"
  name: my-secrets
spec:
  encryptedData:
    MY_SECRET: encrypted-value
  template:
    data: null
    metadata:
      annotations:
        sealedsecrets.bitnami.com/cluster-wide: "true"
      name: my-secrets
    type: Opaque
```

Diff po wprowadzonych zmianach:
```
@@ -7,6 +7,7 @@
 spec:
   encryptedData:
     MY_SECRET: encrypted-value
+    MY_PASSWORD: encrypted-value
   template:
     data: null
     metadata:
```

[Kustomize JSON Patching](https://github.com/kubernetes-sigs/kustomize/blob/master/examples/jsonpatch.md)

[RFC JavaScript Object Notation (JSON) Patch](https://www.rfc-editor.org/rfc/rfc6902)

[Kubernetes: kustomize transformations with patchesJson6902](https://fabianlee.org/2022/04/15/kubernetes-kustomize-transformations-with-patchesjson6902/)


## Dodanie wolumenu z plikiem konfiguracyjnym

Za pomocą Kustomize możemy dodać wolumen do bazowego manifestu Deployment. W moim przypadku wykorzystałem to do skonfigurowania dodatkowych parametrów rabbitmq.
W przypadku, gdy bazowy deployment nie zawiera żadnych wolumenów/punktów montowania to musimy skorzystać z opcji patchesStrategicMerge. W przeciwnym przypadku korzystamy z Json6902 patch. Jeśli się pomylimy i spróbujemy za pomocą Json6902 zmodyfikować taki deployment to otrzymamy błąd:

> error: add operation does not apply: doc is missing path: "/spec/template/spec/volumes/-": missing value

Wynika to z działania Json6902, który nie obsługuje dodawania elementu do tablicy, jeśli klucz `volumes` nie istnieje.

Poniżej diff z różnicą pliku manifestu Deploymentu po zaaplikowaniu Json6902.


```
--- old	2023-05-17 16:25:06.391865049 +0200
+++ new	2023-05-17 18:07:24.464157688 +0200
@@ -1424,6 +1424,8 @@
         volumeMounts:
         - mountPath: /etc/nginx/conf.d
           name: nginx-config
+        - mountPath: /etc/app/conf.d
+          name: my-extra-configuration
       nodeSelector:
         kubernetes.io/arch: arm64
@@ -1440,6 +1442,12 @@
       - configMap:
           name: app-config
         name: app-config-volume
+      - configMap:
+          items:
+          - key: my-config.conf
+            path: my-config.conf
+          name: app-my-config
+        name: my-extra-configuration
```

### patchesStrategicMerge

```
patches:
  - target:
      group: apps
      version: v1
      kind: Deployment
      name: rabbitmq
    patch: |-
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: rabbitmq
      spec:
        template:
          spec:
            volumes:
              - name: my-rabbitmq-conf
                configMap:
                  name: rabbitmq-my-config
                  items:
                    - key: my-config.conf
                      path: "my-config.conf"
            containers:
              - name: rabbitmq
                volumeMounts:
                  - name: my-rabbitmq-conf
                    mountPath: /etc/rabbitmq/conf.d
```

### Json6902

```
patches:
  - target:
      group: apps
      version: v1
      kind: Deployment
      name: app-deployment
    patch: |-
      - op: add
        path: /spec/template/spec/volumes/-
        value:
          name: my-extra-configuration
          configMap:
            name: app-my-config
            items:
              - key: my-config.conf
                path: "my-config.conf"
      - op: add
        path: /spec/template/spec/containers/0/volumeMounts/-
        value:
          name: my-extra-configuration
          mountPath: /etc/app/conf.d
```

[Kubernetes: kustomize transformations with patchesStrategicMerge](https://fabianlee.org/2022/04/18/kubernetes-kustomize-transformations-with-patchesstrategicmerge/)
