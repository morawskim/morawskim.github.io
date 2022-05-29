# Flux

## Pojęcia

Workload - pojęcie odnoszące do dowolnego zasobu klastra odpowiedzialnego za tworzenie kontenerów - w kubernetesie to są obiekty takie jak Deployment, DaemonSet, StatefulSet czy CronJob.

## Polecenia

`fluxctl sync --k8s-fwd-ns FluxNamespace` - synchronizacja klastra z repozytorium git. Możemy także wyeksportować zmienną środowiskową `FLUX_FORWARD_NAMESPACE=FluxNamespace` zamiast korzystać z parametru `--k8s-fwd-ns`

`fluxctl list-workloads -n namespace` - lista workloads zarządzanych przez fluxa.

`fluxctl list-images -w namespace:deployment/podinfo` - wyświetla obrazy dostępne dla danego workload

`kubectl logs -n flux deploy/flux -f` - wyświetla logi fluxa (zakładamy że flux działa w przestrzeni nazw `flux` i zasób deployment nazywa się flux).

## Szablon zasobu Deployment z flux

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: podinfo
  namespace: demo
  labels:
    app: podinfo
  annotations:
    fluxcd.io/automated: "true"
    fluxcd.io/tag.podinfod: semver:~1.3
spec:
  selector:
    matchLabels:
      app: podinfo
  template:
    metadata:
      labels:
        app: podinfo
    spec:
      containers:
      - name: podinfod
        image: stefanprodan/podinfo:1.3.2
        ports:
        - containerPort: 9898
          name: http
        command:
        - ./podinfo
        - --port=9898
```
