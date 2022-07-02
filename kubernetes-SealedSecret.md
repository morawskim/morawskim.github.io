# Kubernetes SealedSecret

W repozytorium git możemy przechowywać konfigurację klastra Kubernetes z wyjątkiem zasobu Secret. Wrażliwe dane w Secret są tylko kodowane przez algorytm base64. W żaden sposób nie są szyfrowane.
Rozwiązaniem jest zaszyfrowanie zasobów Secret poprzez przekształcenie ich w SealedSecret. które mogą być bezpiecznie przechowywane w repozytorium git. Dane są zaszyfrowane kluczem publicznym i tylko posiadając klucz prywatny jesteśmy w stanie odszyfrować dane.

[Ze strony wydań](https://github.com/bitnami-labs/sealed-secrets/releases) ściągamy plik yaml `controller.yaml` z manifestem. Następnie wywołując standardowe polecenie kubernetesa do instalacji kontrolera sealed-secret - `kubectl apply -f /sciezka/do/pobranego/pliku/yaml`.

Pobierając logi poda sealed-secrets-controller-XXXXXXX (dokładną nazwę poznamy wywołując polecenie `kubectl -n kube-system get pods`
wyświetlimy wygenerowany certyfikat (klucz publiczny) w formacie PEM - `kubectl logs -n kube-system sealed-secrets-controller-77747c4b8c-dcpbw`.
Za pomocą tego certyfikatu `kubeseal` będzie szyfrował zasoby Secret.

Przykładowy szablon zasobu Secret dla Kubernetes

```
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
  namespace: mynamespace
data:
  foo: YmFy  # encoded "bar" in base64 format
```

Zapisujemy plik pod nazwą np. `secret.yaml`.
Następnie wywołujemy polecenie `cat secret.yaml | kubeseal --controller-namespace kube-system --controller-name sealed-secrets-controller --format yaml > sealed-secret.yaml`
aby wygenerować zasób SealedSecret i zapisać go w pliku `sealed-secret.yaml`.
Następnie aplikujemy zmiany w klastrze - `kubectl apply -f sealed-secret.yaml`.
Po chwili zostanie utworzony zasób SealedSecret i Secret.
Wywołując polecenie `kubectl get secret mysecret -o jsonpath='{.data.foo}' | base64 --decode` możemy przekonać się, że Secret istnieje, a także zobaczyć odszyfrowaną wartość klucza `foo`.

W przypadku gdy SealedSecret ma być używany w wielu przestrzeniach nazw musimy dodać parametr `--scope cluster-wide` do polecenia `kubeseal`.

[Strona projektu](https://github.com/bitnami-labs/sealed-secrets)
