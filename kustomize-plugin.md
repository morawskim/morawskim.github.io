# Kustomize plugin

Tworzenie pluginu Go dla Kustomize jest możliwe, ale ze względu na ograniczenia języka Go nie jest to łatwy sposób w utrzymaniu.
Kustomize i kod pluginu muszą zostać zbudowane z takimi samymi wersjami pakietów i wersją Go. [Is anyone actually using go plugins?](https://www.reddit.com/r/golang/comments/b6h8qq/is_anyone_actually_using_go_plugins/?rdt=63604)

Najlepiej jest pobrać kod źródłowy Kustomize i w nim stworzyć plugin.

Pobieramy repozytorium Kustomize `git clone https://github.com/kubernetes-sigs/kustomize.git`

Przełączamy sie do wersji np. 5.3.0 - `git checkout kustomize/v5.3.0`

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

W pliku kustomization.yml dodajemy

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

Wywołując polecenie `KUSTOMIZE_PLUGIN_HOME=$PWD/plugins ~/go/bin/kustomize build  --enable-alpha-plugins --enable-exec path/to/dir/with/overlay` powiniśmy na wyjściu zobaczyć zmodyfikowane zasoby CronJobs.

