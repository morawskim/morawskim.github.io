# Grafonnet

[Grafonnet](https://github.com/grafana/grafonnet) to biblioteka Jsonnet służąca do tworzenia dashboardów Grafany w formie kodu.

Do zbudowania dashboardu potrzebujemy dodatkowych narzędzi: [jb](https://github.com/jsonnet-bundler/jsonnet-bundler) oraz [jsonnet](https://github.com/google/go-jsonnet).

Możemy pobrać je bezpośrednio z GitHuba lub skorzystać z odpowiedniego targetu w Makefile:

```
.PHONY: setup
setup:
	wget -O/tmp/go-jsonnet.tar.gz https://github.com/google/go-jsonnet/releases/download/v0.22.0/go-jsonnet_0.22.0_linux_amd64.tar.gz
	cd /tmp && tar xvzf /tmp/go-jsonnet.tar.gz
	rm /tmp/go-jsonnet.tar.gz
	cd /tmp && mv jsonnet jsonnetfmt jsonnet-lint jsonnet-deps ~/.local/bin

	wget -O ~/.local/bin/jb https://github.com/jsonnet-bundler/jsonnet-bundler/releases/download/v0.6.0/jb-linux-amd64
```

Target `setup` pobiera wymagane narzędzia i przenosi je do katalogu `~/.local/bin`.
Katalog `~/.local/bin` powinien znajdować się w zmiennej środowiskowej `PATH`.

W katalogu, w którym będziemy tworzyć dashboard, wywołujemy polecenie `jb init`.
Następnie instalujemy bibliotekę Grafonnet `jb install github.com/grafana/grafonnet/gen/grafonnet-latest@main`.
Biblioteka zostanie pobrana do katalogu vendor.

Aby nie podawać pełnej ścieżki do biblioteki Grafonnet przy każdym imporcie, tworzymy plik `g.libsonnet` - `echo "import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet'" > g.libsonnet`.

Tworzymy plik `dashboard.jsonnet`, w którym definiujemy nasz dashboard.

Przykładowa struktura katalogu może wyglądać następująco:

```
.
├── dashboard.jsonnet
├── g.libsonnet
├── jsonnetfile.json
├── jsonnetfile.lock.json
├── Makefile
└── vendor
```

Nasz kod Jsonnet musimy "skompilować" `jsonnet -J vendor --output-file dashboard.json dashboard.jsonnet`.
Powstanie plik `dashboard.json` zawierający gotowy dashboard.
Następnie kopiujemy jego zawartość i importujemy dashboard w Grafanie.

[Dokumentacja](https://grafana.github.io/grafonnet/)
