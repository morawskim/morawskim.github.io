# minikube

Po instalacji `minikube` dodatek `metrics-server` nie jest domyślnie włączony. Możemy się o tym przekonać wywołując polecenie `minikube addons list | grep metrics`.
Dodatkowo wywołując polecenie `kubectl api-resources | grep metrics` na naszym klastrze otrzymamy brak wyników, co sugeruje braku wsparcia dla metryk w klastrze. (Inny sposobem jest wykorzystanie polecenie `kubectl get apiservices` i szukanie także frazy `metrics`)

Włączamy metryki poleceniem - `minikube addons enable metrics-server`. Po chwili wywołując ponownie polecenie `kubectl api-resources | grep metrics` zobaczymy:
```
nodes metrics.k8s.io/v1beta1 false NodeMetrics
pods metrics.k8s.io/v1beta1 true PodMetrics
```

Możemy już korzystać z polecenia `kubectl top`.

`minikube image load <obraz-do-prezslania>` - Załaduj obraz do minikube

### Network policy

Domyślna implementacja CNI (Container Network Interface) [nie obsługuje NetwokPolicy](https://minikube.sigs.k8s.io/docs/handbook/network_policy/).
Możemy włączyć implementacje calico uruchamiając klaster z parametrem cni - `minikube start --cni calico`
Domyślnie nie istnieje żadna polityka blokująca dostęp do podów - musimy więc ją utworzyć.


```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  creationTimestamp: null
  labels:
    app: foo
  name: networkpolicy
spec:
  podSelector:
    matchLabels:
      app: foo
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: bar
      ports:
        - port: 80
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
spec:
  podSelector: {}
  policyTypes:
  - Ingress
```

## Apiserver

Api serwera Kubernetesa działa na podzie `kube-apiserver-minikube` w przestrzeni nazw `kube-system`. Możemy pobrać definicję tego poda korzystając z standardowego polecenia `kubectl get pod -n kube-system kube-apiserver-minikube -o yaml`.

Dostępne argumenty modyfikujące działanie API, możemy wyświetlić wywołując polecenie `kubectl exec -n kube-system kube-apiserver-minikube -it -- kube-apiserver -h`

Podczas startu minikube możemy [zmodyfikować lub dodać argumenty serwera API](https://minikube.sigs.k8s.io/docs/handbook/config/#modifying-kubernetes-defaults) - `minikube start --extra-config=apiserver.KEY=VALUE`, gdzie `KEY` to argument a `VALUE` to wartość.

Możemy także wyświetlić tylko polecenie i argumenty serwera API `kubectl get pod -n kube-system kube-apiserver-minikube -o custom-columns=cmd:.spec.containers[].command`.
