## Kubernetes szablony zasobów

## Kubernetes RBAC

W poniższym pliku powinniśmy zastąpić wartości:

* przestrzeń nazw `mynamespace`
* nazwę roli `pods-readonly-role`
* nazwę konta usługi `ro-pods-sa`
* nazwę zasobu RoleBinding `pods-radonly-role-binding`

Wywołując polecenie `kubectl auth can-i list pods --as=system:serviceaccount:mynamespace:ro-pods-sa -n mynamespace`
możemy się upewnić czy utworzone konto serwisowe ma uprawnienia do wykonania akcji "list" na zasobie "pods" w przestrzeni nazw "mynamespace".
Wywołując te polecenie przed przypisaniem roli do konta otrzymamy wartość "no".

Dodatkowo możemy uruchomić tymczasowy pod `kubectl run -n mynamespace -it --image=fedora:32 --restart=Never --overrides='{ "spec": { "serviceAccount": "ro-pods-sa" }  }' test`, który będzie działał z uprawnieniami utworoznego konta serwisowego.
W uruchomionej powłoce instalujemy klienta kubernetesa - `dnf install kubernetes-client`.
Następnie możemy wywołać polecenia do sprawdzenia czy nasz pod ma wymagane uprawnienia do API Kubernetesa.
`kubectl get pods`:
```
NAME    READY   STATUS    RESTARTS   AGE
test   1/1     Running   0          75s
```

Próbując pobrać usługi - `kubectl get services` otrzymamy błąd dostępu:

>Error from server (Forbidden): services is forbidden: User "system:serviceaccount:mynamespace:ro-pods-sa" cannot list resource "services" in API group "" in the namespace "mynamespace"

```
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pods-readonly-role
  namespace: mynamespace
rules:
  - apiGroups:
      - "*"
    resources:
      - pods
    verbs:
      - get
      - list
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ro-pods-sa
  namespace: mynamespace
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pods-radonly-role-binding
  namespace: mynamespace
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: pods-readonly-role
subjects:
- kind: ServiceAccount
  name: ro-pods-sa
  namespace: mynamespace

```
