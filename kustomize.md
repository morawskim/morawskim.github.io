# Kustomize

Obecnie Kubernetes posiada wbudowane wsparcie dla Kustomize.

[Dokumentacja](https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/)

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
