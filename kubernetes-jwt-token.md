# Kubernetes JWT token

Kubernetes przed wersją 1.22 automatycznie tworzył długoterminowe tokeny JWT umożliwiające dostęp do API.

Tworzenie długoterminowych tokenów nie jest dobrym pomysłem, ale mogą one być niezbędne jeśli migrujemy infrastrukturę do Kubernetesa, a część rzeczy ciągle działa poza K8s. W moim przypadku potrzebowałem tokenu do pobierania metryk klastra Kubernetesa.

Tworzymy service account - `kubectl create serviceaccount expose-metrics`

Następnie ClusterRole.

```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: expose-metrics
rules:
- nonResourceURLs: ["/metrics"]
  verbs: ["get"]

```

Łączymy konto serwisowe z rolą (zastępujemy `<NAMESPACE>` namespace, w której utworzyliśmy konto serwisowe) - `kubectl create clusterrolebinding expose-metrics --clusterrole expose-metrics --serviceaccount <NAMESPACE>:expose-metrics`.

Finalnie tworzymy zasób sekret, dzięki któremu K8s utworzy nam długoterminowy token JWT.

```
apiVersion: v1
kind: Secret
metadata:
  name: expose-metrics-token
  annotations:
    kubernetes.io/service-account.name: expose-metrics
type: kubernetes.io/service-account-token

```

Po utworzeniu zasobów możemy pobrać token z zasobu Secret - `kubectl get secret expose-metrics-token -o jsonpath='{$.data.token}' | base64 -d`

[Manually create an API token for a ServiceAccount](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#manually-create-an-api-token-for-a-serviceaccount)
