# Golang

## Static analysis

`govulncheck` - zgłasza znane podatności w wykorzystywanych pakietach Go. 
Instaluejmy narzędzie poprzez wydanie polecenia `go install golang.org/x/vuln/cmd/govulncheck@latest`.
Następnie możemy przeskanować projekt wydając polecenie `~/go/bin/govulncheck .`

`fieldalignment` -  służy do wykrywania struktur, które można zoptymalizować przemieszczając pola w strukturze - `go get -tool golang.org/x/tools/go/analysis/passes/fieldalignment/cmd/fieldalignment/`

## Pakiety

| Pakiet | Opis |
| - | - |
| [golangci-lint](https://github.com/golangci/golangci-lint) | Fast linters Runner for Go |
| [Testify](https://github.com/stretchr/testify) | A toolkit with common assertions and mocks that plays nicely with the standard library |
| [apitest](https://github.com/steinfletcher/apitest) | A simple and extensible behavioural testing library for Go. You can use api test to simplify REST API, HTTP handler and e2e tests. |

## Obrazy Docker

| Obraz | Opis |
|-|-|
| `gcr.io/distroless/static-debian11` | Obraz do uruchomienia statycznych plików binarnych |
| `cgr.dev/chainguard/static:latest` | Obraz do uruchomienia statycznych plików binarnych |
| `cgr.dev/chainguard/go` | Obraz do budowania aplikacji Go. **UWAGA** [Od 16 Sierpnia 2023 użytkownicy bez subskrypcji będą w stanie pobierać obrazy tylko z tagiem](https://www.chainguard.dev/unchained/scaling-chainguard-images-with-a-growing-catalog-and-proactive-security-updates) `latest` lub `latest-dev`. |
| `golang:1.20` | [Oficjalny obraz Go](https://hub.docker.com/_/golang) |

Przykładowy Dockerfile

Kontener do budowania aplikacji Go musiałem odpalić z uprawnieniami root, inaczej otrzymywałem błąd z uprawnieniami.
Ten problem został już zgłoszony [File permission errors trying to build with go image #16](https://github.com/chainguard-images/go/issues/16)

```
FROM golang:1.20 as build
WORKDIR /work

COPY . .
RUN CGO_ENABLED=0 go build -o hello .

FROM cgr.dev/chainguard/static:latest
COPY --from=build /work/hello /hello
CMD ["/hello"]
```

## Debugging & hot reloading

Okteto dostarcza dedykowany obraz kontenera dla programistów aplikacji go `okteto/golang:1.19`.
Jeśli korzystamy z okteto to w pliku `okteto.yaml` musimy dodać uprawnienie SYS_PTRACE do kontenera, a także przekierować ruch z portu 2345 (delve będzie na nim nasłuchiwać).
Te zmiany są niezbędne, aby działał debugger delve. Warto także utworzyć wolumen do przechowywania pobranych pakietów go, czy zbudowanego kodu aplikacji - te zmiany przyśpieszą pierwszy build.

```
forward:
  - 2345:2345
# persist the Go cache
volumes:
  - /go
  - /root/.cache
securityContext:
  capabilities:
    add:
      - SYS_PTRACE
```

Podłączamy się do kontenera i jeśli nie mamy zainstalowanych pakietów air i delve to je instalujemy. [Istnieje komentarz](https://github.com/cosmtrek/air/issues/76#issuecomment-1233993470) że instalacja wersji "latest" powoduje problemy między air i delve i zaleca się instalowanie konkretnych wersji tych pakietów - `go install github.com/cosmtrek/air@v1.40.4 && go install github.com/go-delve/delve/cmd/dlv@v1.9.1`

Wywołujemy polecenie `air init` w katalogu z projektem. W utworzonym pliku `.air.toml` zmieniamy polecenie do budowania kodu `cmd = 'go build -gcflags "all=-N -l" -o ./tmp/main .'`.
Dodajemy flagi dla kompilatora go. Przykład jest dla go w wersji 1.10+ - [Attach to running Go processes with the debugger](https://www.jetbrains.com/help/go/attach-to-running-go-processes-with-debugger.html#step-2-build-the-application). Ustawiamy także klucz full_bin - `full_bin = "dlv exec --continue --accept-multiclient --listen=:2345 --headless=true --api-version=2 --check-go-version=false --only-same-user=false --log ./tmp/main"`. Jeśli zmienimy ścieżkę pliku wykonywalnego `./tmp/main` musimy dostosować te dwa polecenia.

Następnie w Goland dodajemy nową konfigurację "Go Remote".
Obecnie mogą pojawić się [pewnie niedogodności między Goland, dlv i air](https://github.com/cosmtrek/air/issues/76).

Z moich testów wychodzi, że przy modyfikacji kodu Goland traci połączenie z dlv i musimy cały czas klikać w ikonę "Debug", albo skorzystać z skrótu `[SHIFT] + [F9]`.
Niemniej jednak od czasu do czasu możemy otrzymać w konsoli air błąd "bind: address already in use".
Dodatkowo jeśli Goland wyświetli komunikat, że nie może znaleźć pliku to być może, zbudowaliśmy aplikację bez tych wymaganych flag kompilatora.

W przypadku prostych aplikacji zamiast korzystać z air możemy skorzystać z [gow](https://github.com/mitranim/gow).

Do monitorowania co wykonują funkcje goroutine możemy skorzystać z [grmon](https://github.com/bcicen/grmon)
