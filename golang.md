# Golang

## Static analysis

`govulncheck` - zgłasza znane podatności w wykorzystywanych pakietach Go. 
Instaluejmy narzędzie poprzez wydanie polecenia `go install golang.org/x/vuln/cmd/govulncheck@latest`.
Następnie możemy przeskanować projekt wydając polecenie `~/go/bin/govulncheck .`

## Obrazy Docker

| Obraz | Opis |
|-|-|
| `cgr.dev/chainguard/static:latest` | Obraz do uruchomienia statycznych plików binarnych |
| `cgr.dev/chainguard/go:1.19` | Obraz do budowania aplikacji Go |

Przykładowy Dockerfile

Kontener do budowania aplikacji Go musiałem odpalić z uprawnieniami root, inaczej otrzymywałem błąd z uprawnieniami.
Ten problem został już zgłoszony [File permission errors trying to build with go image #16](https://github.com/chainguard-images/go/issues/16)

```
FROM cgr.dev/chainguard/go:1.19 as build
USER root

WORKDIR /work

COPY . .
RUN CGO_ENABLED=0 go build -o hello .

FROM cgr.dev/chainguard/static:latest
COPY --from=build /work/hello /hello
CMD ["/hello"]
```
