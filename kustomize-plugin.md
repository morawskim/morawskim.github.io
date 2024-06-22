# Kustomize plugin

Tworzenie pluginu Go dla Kustomize jest możliwe, ale ze względu na ograniczenia języka Go nie jest to łatwy sposób w utrzymaniu.
Kustomize i kod pluginu muszą zostać zbudowane z takimi samymi wersjami pakietów i wersją Go. [Is anyone actually using go plugins?](https://www.reddit.com/r/golang/comments/b6h8qq/is_anyone_actually_using_go_plugins/?rdt=63604)

Najlepiej jest pobrać kod źródłowy Kustomize i w nim stworzyć plugin.

Pobieramy repozytorium Kustomize `git clone https://github.com/kubernetes-sigs/kustomize.git`

Przełączamy się do wersji np. 5.3.0 - `git checkout kustomize/v5.3.0`

Wywołujemy polecenie `make kustomize`, a następnie przechodzimy do katalogu kustomize `cd kustomize` i wywołujemy polecenie `make build`.

Domyślnie GOPATH to `~/go` możemy to sprawdzić poleceniem `go env GOPATH`
Plik wykonywalny kustomize zostanie utworzony w katalogu `~/go/bin/`

Tworzymy plik `plugin.go` w głównym katalogu z repozytorium Kustomize i wklejamy poniższy kod.
Dla każdego zasobu CronJob ustawiamy adnotację "foo" na wartość "bar", a także modyfikujemy wartość pola "spec.schedule" ustawiając stała wartość "45 22 * * 6".

```
package main

import (
	"sigs.k8s.io/kustomize/api/resmap"
	"sigs.k8s.io/kustomize/api/types"
	"sigs.k8s.io/kustomize/kyaml/yaml"
)

type plugin struct {
	types.ObjectMeta `json:"metadata,omitempty" yaml:"metadata,omitempty" protobuf:"bytes,1,opt,name=metadata"`
}

var KustomizePlugin plugin

func (p *plugin) Config(h *resmap.PluginHelpers, c []byte) error {
	return nil
}

func (p *plugin) Transform(m resmap.ResMap) error {
	for _, res := range m.Resources() {
		if res.GetKind() == "CronJob" {
			err := res.PipeE(
				yaml.Tee(yaml.SetAnnotation("foo", "bar")),
				yaml.Lookup("spec"),
				yaml.Tee(yaml.SetField("schedule", yaml.NewScalarRNode("45 22 * * 6"))),
			)

			if err != nil {
				return err
			}
		}
	}

	return nil
}

```

Budujemy plugin poleceniem `go build -buildmode plugin -o MyPlugin.so plugin.go`
Nazwa pliku wynikowego jest istotna.  Kustomize będzie szukał pliku o nazwie `${kind}.so` próbując załadować go jako wtyczkę Go.

W pliku `kustomization.yml` dodajemy

```
transformers:
- |-
  apiVersion: mycompany.com/v1beta
  kind: MyPlugin
  metadata:
    name: myplugin
```

Tworzymy katalogi `mkdir -p plugins/mycompany.com/v1beta/myplugin` i kopiujemy do niego nasz zbudowany plugin.
Każda wtyczka otrzymuje własny dedykowany katalog o nazwie `${apiVersion}/LOWERCASE(${kind})`

Wywołując polecenie `KUSTOMIZE_PLUGIN_HOME=$PWD/plugins ~/go/bin/kustomize build  --enable-alpha-plugins --enable-exec path/to/dir/with/overlay` powinniśmy na wyjściu zobaczyć zmodyfikowane zasoby CronJobs.

## Inne rozwiązanie

Z repozytorium [kustomize v5.3.0](https://github.com/kubernetes-sigs/kustomize/tree/kustomize/v5.3.0/plugin/builtin/secretgenerator) pobieramy pliki `go.mod` i `go.sum`.

Po pobraniu plików, otwieramy plik "go.mod" i zmieniamy nazwę modułu.
Możemy także dostosować wersję kompilatora go.

Tworzymy plik z kodem pluginu (możemy wykorzystać ten sam przykład co wyżej).
Instalujemy kustomize `GOPATH=$PWD/go go install sigs.k8s.io/kustomize/kustomize/v5@v5.3.0`
Budujemy nasz plugin `GOPATH=$PWD/go go build -buildmode plugin -o MyPlugin.so main.go`
Kopiujemy plugin do dedykowanego katalogu `mkdir -p mycompany.com/v1beta/myplugin && cp MyPlugin.so mycompany.com/v1beta/myplugin/MyPlugin.so`.
Dodajemy wpis do `kustomization.yml` jak w przykładzie wyżej i odpalamy polecenie build kustomize.

[Extending Kustomize: Go Plugins (deprecated)](https://kubectl.docs.kubernetes.io/guides/extending_kustomize/go_plugins/)

## Exec KRM plugin

Plugin Exec KRM tworzy sie trochę inaczej.
Preferowanym sposobem przekształcania zasobów Kubernetesa jest użycie `kio.Pipeline` do odczytu, modyfikacji i zapisu zasobów. [Dokumentacja pakietu kio](https://pkg.go.dev/sigs.k8s.io/kustomize/kyaml/kio#section-documentation)


Przykładowe demo, które modyfikuje pole `suspend` zasobu CronJob (na podstawie konfiguracji) dostępne jest w [GitHub](https://github.com/morawskim/go-projects/tree/main/kustomize).

Do pliku `kustomization.yml` dodajemy
```
transformers:
- |-
  apiVersion: demo.morawskim.pl/v1beta
  kind: MyKRMKustomizationPlugin
  metadata:
    name: krmFunction
    annotations:
      # path is relative to kustomization.yaml
      config.kubernetes.io/function: |
        exec:
          path: ./../../plugins/mykrmplugin
  spec:
    cronJobsToDisable:
      - my-cronjob-to-suspend
    cronJobsToEnable:
      - my-cronjob-to-enable

```

[Extending Kustomize: Exec KRM functions](https://kubectl.docs.kubernetes.io/guides/extending_kustomize/exec_krm_functions/)
