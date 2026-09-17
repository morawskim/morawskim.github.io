# Monorepo splitsh-lite

Monorepo to sposób organizacji kodu, w którym wiele projektów lub bibliotek jest przechowywanych w jednym repozytorium kontroli wersji.

W moim przypadku wykorzystałem to podejście do przechowywania middleware'ów dla Guzzle HTTP.

Chciałem przechowywać wszystkie middleware'y w jednym repozytorium, ale jednocześnie publikować je jako niezależne pakiety w serwisie Packagist.

Każdy middleware powinien mieć własne repozytorium tylko do odczytu, bez możliwości tworzenia zgłoszeń (Issues) i Pull Requestów.

Z podobnego podejścia korzysta Symfony.
Moje rozwiązanie bazuje na mechanizmie wykorzystywanym w repozytorium Symfony.

### Wydzielanie repozytoriów

Do wydzielania poszczególnych katalogów z monorepo do niezależnych repozytoriów Git wykorzystuję [splitsh-lite](https://github.com/splitsh/lite).

`splitsh-lite` pozwala utworzyć historię Git zawierającą wyłącznie zmiany dotyczące wskazanego podkatalogu.
W praktyce oznacza to, że z jednego monorepo możemy wygenerować osobne repozytorium zawierające np. tylko jeden middleware.

Istnieje otwarty PR umożliwiający zbudowanie obrazu kontenera - [Add Dockerfile - #75](https://github.com/splitsh/lite/pull/75)

```
FROM golang:1.22-bookworm AS builder

WORKDIR /build

RUN apt update && apt install -y pkg-config cmake

# Cache modules and git2go build
COPY go.mod go.sum ./
RUN go mod download

# Build git2go
RUN git clone https://github.com/libgit2/git2go vendor/github.com/libgit2/git2go/v34
RUN cd vendor/github.com/libgit2/git2go/v34 && git checkout v34.0.0 && git submodule update --init && make install-static
RUN mv vendor/github.com/libgit2/git2go/v34 git2go

# Copy the code
COPY .git main.go ./
COPY splitter splitter/
RUN go mod vendor
RUN rm -rf vendor/github.com/libgit2/git2go/v34
RUN mv git2go vendor/github.com/libgit2/git2go/v34

# Build
RUN go build -tags static -ldflags="-s -w -X 'main.version=$(git describe --tags)'" -o splitsh-lite ./main.go

# Prepare files for the final image
WORKDIR /dist
RUN cp /build/splitsh-lite ./splitsh-lite

# Add dependent libraries
RUN ldd splitsh-lite | tr -s '[:blank:]' '\n' | grep '^/' | xargs -I % sh -c 'mkdir -p $(dirname ./%); cp % ./%;'

# Create the runtime image
FROM scratch

COPY --from=builder /dist /
WORKDIR /data
ENTRYPOINT ["/splitsh-lite"]

```

Obraz budujemy standardowym poleceniem: `docker build -t splitsh-lite .`

Następnie możemy wydzielić konkretny katalog z monorepo.
Aby wydzielić middleware "Metrics":

```
docker run --rm -e SUDO_UID=$(id -u) -v $PWD:/data splitsh-lite --prefix=src/Mmo/GuzzleMiddleware/Metrics/ --target=refs/heads/metrics
```

Polecenie zwróci hash commitu.
W repozytorium zostanie utworzony branch metrics, zawierający historię Git ograniczoną do wskazanego katalogu:
`src/Mmo/GuzzleMiddleware/Metrics/`

Branch metrics możemy wykorzystać jako źródło dla osobnego repozytorium.

Podczas uruchamiania kontenera możemy otrzymać błąd:
> repository path '/data/' is not owned by current user

W takim przypadku należy upewnić się, że podczas uruchamiania kontenera ustawiliśmy zmienną środowiskową `SUDO_UID`:
`-e SUDO_UID=$(id -u)`.


### Repozytoria tylko do odczytu

Kolejnym krokiem jest utworzenie osobnych repozytoriów na GitHubie.

Repozytoria te powinny być traktowane jako repozytoria tylko do odczytu, które służą jako niezależne źródła pakietów publikowanych w Packagist.

Źródłem prawdy pozostaje monorepo i zmiany powinny być wprowadzane właśnie tam.

Do utworzenia repozytorium na GitHubie wykorzystujemy Terraform:

```
resource "github_repository" "php_guzzle_metrics_middleware" {
  name        = "guzzle-metrics-middleware"
  description = "A Guzzle HTTP client middleware that measures the duration of requests."
  visibility = "public"

  has_issues = false
  has_discussions = false
  has_projects = false
  has_wiki = false
  # waiting for https://github.com/integrations/terraform-provider-github/pull/3479
  #has_pull_requests = false
  topics = ["guzzle", "guzzlehttp", "prometheus-metrics", "guzzle-middleware"]
}
```

Obecnie provider terraform nie obsługuje atrybutu `has_pull_requests`.
Czekamy na scalenie PR [feat: Add pull request settings to github_repository - #3479](https://github.com/integrations/terraform-provider-github/pull/3479)


[Using Git magic for the Symfony mono-repo](https://live.symfony.com/account/replay/video/968)
