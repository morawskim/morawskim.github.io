# Kubernetes

## Pojęcia

Terminy orkiestracja (ang. orchestration) i planowanie (ang. scheduling) są często używane jako synonimy. Orkiestracja oznacza koordynację i sekwencjonowanie różnych działań na rzecz wspólnego celu (podobnie do pracy muzyków w orkiestrze). Planowanie oznacza zarządzanie dostępnymi zasobami i przypisywanie prac tam, gdzie można je najbardziej wydajnie uruchomić. (Nie należy mylić z planowaniem w sensie zaplanowanych zadań, które są wykonywane o ustalonych porach).

"Podnoszenie banalnych ciężarów" - to termin ukuty w Amazon, który oznacza całą ciężką pracę i wysiłek związany z instalowaniem oprogramowania i zarządzaniem nim, utrzymaniem infrastruktury itd. W tej pracy nie ma nic specjalnego, w każdej firmie wygląda tak samo. Kosztuje pieniądze, zamiast przynosić dochód.

`headless service` - opcja do definiowania lokalnych nazw domenowych z klastra do systemów zewnętrznych. Tworzona jest usługa `ClusterIP`, ale bez selektora etykiet, więc nigdy nie będą dopasowywane kapsuły. Zamiast tego usługa jest wdrażana z zasobem punktu końcowego (ang. endpoint), która bezpośrednio wymienia adresy IP, które usługa powinna rozwiązywać.

## Porady

* Cindy Sridharan inżynier i twórca systemów rozproszonych oszacował, że koszt utrzymania inżyniera, który konfiguruje (od zera do wersji produkcyjnej) Kubernetes, wynosi około miliona dolarów. - https://twitter.com/copyconstruct/status/1020880388464377856

* Praca (w ECS for Kubernetes w chmurze AWS) nie przebiega tak płynnie jak w przypadku Google Kubernetes Engine - [GKE vs AKS vs EKS](https://hasura.io/blog/gke-vs-aks-vs-eks-411f080640dc/)

* Zawsze określaj żądania zasobów i limity dla swoich kontenerów. Pomaga to aplikacji Kubernetes odpowiednio planować swoje Pody i zarządzać nimi.

* Dobrą praktyką jest tworzenie dedykowanej końcówki dla sondy żywotności np. `/health`.

* Sondy gotowości powinny zwracać tylko status HTTP `200 OK`. Chociaż Kubernetes uważa oba kody stanu 2xx i 3xx za poprawne, to usługi load blancera - nie. Jeśli korzystasz z zasobu Ingress w połączeniu z modułem load balancera w chmurze, a Twoja sonda gotowości zwraca np. kod 301 (przekierowanie), moduł load balancera może oznaczyć pody jako niesprawne. Upewnij się, że Twoje sondy gotowości zwracają tylko kod statusu 200.

* Podczas wdrażania Kubernetes przed uruchomieniem następnego Poda czeka, aż każdy nowy Pod będzie gotowy. Jeśli wadliwy kontener natychmiast ulegnie awarii, spowoduje to zatrzymanie procesu wdrożenia, ale jeśli do czasu wystąpienia awarii minie kilka sekund, wszystkie jego repliki mogą zostać wdrożone przed wykryciem problemu.
Aby tego uniknąć, możesz ustawić wartość dla pola `minReadySeconds` w kontenerze. Kontener lub Pod nie będą uważane za gotowe, dopóki sonda gotowości nie będzie gotowa przez `minReadySeconds` sekund (domyślnie 0).

* Dla aplikacji o kluczowym znaczeniu dla firmy ustaw PodDisruptionBudget, aby upewnić się, że zawsze jest wystarczająca liczba replik do utrzymania usługi nawet wtedy, gdy eksmitowane są Pody.

* Dobrą zasadą jest to, że węzły powinny być na tyle duże, aby uruchomić przynajmniej pięć typowych Podów, utrzymując proporcję zasobów osieroconych na poziomie około 10% lub mniej. Jeśli węzeł może uruchomić 10 lub więcej Podów, osierocone zasoby będą poniżej 5%.

* Dobrą praktyką jest poprzedzanie niestandardowych adnotacji nazwą domeny firmy np. example.com, aby uniknąć kolizji z innymi adnotacjami, które mogą mieć tę samą nazwę.

* Obiekty Job Kubernetes to Pody, które uruchamiają się jeden raz i nie są ponownie uruchamiane. Jednak obiekty Job nadal istnieją w bazie danych Kubernetes, a gdy pojawi się znaczna liczba zakończonych zadań, może to mieć wpływ na wydajność interfejsu API.

* Węzeł główny dla małych klastrów (do około pięciu węzłów) powinien mieć co najmniej jeden wirtualny procesor i 3-4 GB pamięci, przy czym większe klastry wymagają więcej pamięci i procesorów dla każdego węzła master.

* Opcja `kubectl --dry-run=client` , w połączeniu z `-o YAML` (aby uzyskać format YAML na wyjściu) pozwala używać poleceń imperatywnych do generowania manifestów Kubernetes; podczas tworzenia plików manifestów dla nowych aplikacji zyskujemy dużą oszczędność czasu.

* Dobrą praktyką jest zawsze ustawianie readOnlyRootFilesystem, chyba że kontener naprawdę musi zapisywać do plików.

* Kontekst bezpieczeństwa poda securityContext: runAsUser, runAsNonRoot i allowPrivilegeEscalation

* Jeśli np. węzeł utraci dostęp do sieci, Kubernetes automatycznie dodaje skazę `node.kubernetes.io/unreachable`. Normalnie spowodowałoby to, że kubectl usunąłby wszystkie pody z węzła. Możesz jednak zechcieć utrzymać działanie niektórych Podów, mając nadzieję, że sieć wróci w rozsądnym czasie. Aby to zrobić, możesz dodać do tych Podów tolerancję, pasującą do skazy `unreachable`.

* Warto posiadać kilka różnych rozmiarów węzłów (RAM i CPU).

* Aktualizacja typu Rolling Update (RollingUpdate) oznaczają zero przestojów (aktualizacja poda po podzie), podczas gdy Recreate to szybka opcja aktualizacji wszystkich podów naraz. Istnieje również kilka innych opcji, które możesz dostosować, aby uzyskać dokładnie takie zachowanie, jakiego potrzebujesz w swojej aplikacji.

* Na początku dobrymi etykietami mogą być: nazwa aplikacji, nazwa komponentu i wersja, ale ważne jest odróżnienie etykiet dołączonych dla własnej wygody od etykiet, których Kubernetes używa do mapowania relacji między obiektami.

* Jedna z wad mechanizmu RBAC polega na tym, że zasoby muszą istnieć przed zastosowaniem reguł, więc w tym przypadku przed utworzeniem roli i wiązania ról muszą istnieć przestrzeń nazw i konto usługi.

## Przypdatne polecenia

`kubectl create configmap demo-config --from-file=config.yaml` - utworzenie ConfigMap bezpośrednio z pliku YAML

`kubectl describe pod -n kube-system -l component=kube-apiserver | grep encryption`
jeśli nie widzisz flagi experimental-encryption-provider-config szyfrowanie in-rest nie jest włączone.
Jeśli używasz Google Kubernetes Engine lub innych zarządzanych usług Kubernetes, Twoje dane są szyfrowane przy użyciu innego mechanizmu i nie zobaczysz tej flagi.

`kubectl describe pod -n kube-system -l component=kube-apiserver` - sprawdza czy funkcja RBAC jest włączona w wyniku powinno być `--authorization-mode=Node,RBAC`. Jeśli nie zawiera RBAC, to RBAC nie jest włączony dla klastra.

Możemy sprawdzić logi serwera API z zablokowanymi wywołaniami API
wywołując polecenie `kubectl logs -n kube-system -l component kube-apiserver | grep "RBAC DENY"`

Komenda `kubectl get componentstatues` (lub w skórcie `kubectl get cs`) podaje informacje o stanie zdrowia komponentów sterowania kubernetes

`kubectl top nodes/pod` pokaże CPU oraz ilość pamięci każdego węzła/poda oraz ilość aktualnie używanego

`kubectl debug -it <pod-name> --image=busybox --target=<pod-name>` - debugowanie kontenera, który jest distroless (nie zawiera powłoki) poprzez dołączenie nowego kontenera do działającego poda. Nie wszystkie środowiska uruchomieniowe kontenera obsługują tą funkcję. Przykłady użycia polecenia debug dostępne są także w [dokumentacji](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#debug).

`kubectl get events -A --sort-by=.metadata.creationTimestamp` - wyświetlenie zdarzeń klastra (wszystkie przestrzenie nazw) posortowanych po dacie utworzenia

`kubectl get events --sort-by=".lastTimestamp"` - wyświetlenie zdarzeń klastra posortowanych po dacie ostatniego wystąpienia

`kubectl cluster-info dump` - wyświetla obecny stan klastra

`kubectl set image deployment/DEPLOYMENT_NAME -n=MY_NAMESPACE CONTAINER_NAME=xxxx.dkr.ecr.eu-central-1.amazonaws.com/image:new-tag` - Za pomocą tej komendy aktualizujemy obraz kontenera `CONTAINER_NAME` do `xxxx.dkr.ecr.eu-central-1.amazonaws.com/image:new-tag` działającego w zasobie deployment `DEPLOYMENT_NAME` w przestrzeni nazw `MY_NAMESPACE`.
Korzystając z polecenia `kubectl -n MY_NAMESPACE get deployments` możemy pobrać wszystkie zasoby deployment z przestrzeni nazw `MY_NAMESPACE`.

`kubectl create job --from=cronjob/<name of cronjob> <name of this run>` - Utworzenie nowego zasobu job z zasobu cronjob.

`kubectl -n <namespace> auth can-i --list --as system:serviceaccount:<namespace>:<service account name>` - wyświetla uprawnienia dla danego konta usługi

## minikube

Po instalacji `minikube` dodatek `metrics-server` nie jest domyślnie włączony. Możemy się o tym przekonać wywołując polecenie `minikube addons list | grep metrics`.
Dodatkowo wywołując polecenie `kubectl api-resources | grep metrics` na naszym klastrze otrzymamy brak wyników, co sugeruje braku wsparcia dla metryk w klastrze. (Inny sposobem jest wykorzystanie polecenie `kubectl get apiservices` i szukanie także frazy `metrics`)

Włączamy metryki poleceniem - `minikube addons enable metrics-server`. Po chwili wywołując ponownie polecenie `kubectl api-resources | grep metrics` zobaczymy:
```
nodes metrics.k8s.io/v1beta1 false NodeMetrics
pods metrics.k8s.io/v1beta1 true PodMetrics
```

Możemy już korzystać z polecenia `kubectl top`.

`minikube image load <obraz-do-prezslania>` - Załaduj obraz do minikube

## Narzędzia

[Descheduler for Kubernetes](https://github.com/kubernetes-sigs/descheduler)

[An Auditing System for Kubernetes.](https://k8guard.github.io/)

[Copper - to narzędzie do sprawdzania manifestów Kubernetes przed ich wdrożeniem oraz oznaczenia typowych problemów lub egzekwowania niestandardowych zasad.](https://github.com/cloud66-oss/copper)

[Narzędzie chaoskube jest proste w instalacji i konfiguracji oraz idealne do rozpoczęcia zabaw z inżynierią chaosu.](https://github.com/linki/chaoskube)

[kube-shell](https://github.com/cloudnativelabs/kube-shell) - An integrated shell for working with the Kubernetes CLI w okienku wyświetla możliwe uzupełnienia dla każdego polecenia

[stern - Multi pod and container log tailing for Kubernetes](https://github.com/wercker/stern) - Stern śledzi dzienniki ze wszystkich podów, których nazwa pasuje do wyrażenia regularnego. Jeśli pod zawiera wiele kontenerów, Stern pokaże dla każdego z nich osobne dzienniki poprzedzone ich nazwą.

[clair Vulnerability Static Analysis for Containers](https://github.com/quay/clair)

[Kompose Go from Docker Compose to Kubernetes](https://github.com/kubernetes/kompose)

[Validate your Kubernetes configuration files, supports multiple Kubernetes versions](https://github.com/instrumenta/kubeval) - kubeval is a tool for validating a Kubernetes YAML or JSON configuration file.

[rainbow deploys](https://github.com/bdimcheff/rainbow-deploys) - are like Blue/Green deploys, but instead of just two environments, there are an infinite number of colors. Kubernetes makes this pretty easy to do.

## Książki

John Arundel i Justin Domingus, _Kubernetes - rozwiązania chmurowe w świecie DevOps. Tworzenie, wdrażanie i skalowanie nowoczesnych aplikacji chmurowych_, Helion
