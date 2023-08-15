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
