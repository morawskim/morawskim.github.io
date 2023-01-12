# Go linters

## govulncheck

Govulncheck zgłasza znane podatności w kodzie Go.
W celu instalacji wydajemy standardowe polecenie `go install golang.org/x/vuln/cmd/govulncheck@latest`.
Następnie możemy wywołać polecenie `govulncheck .`, aby przeskanować roboczy katalog pod kątem znanych podatności.

Przykładowa definicja joba dla GitLab CI/CD:

```
govulncheck:
  stage: qa
  image: golang:1-bullseye
  script:
    - go install golang.org/x/vuln/cmd/govulncheck@latest
    - govulncheck .
  allow_failure: true
```

## golangci-lint

Obecnie istnieje otwarte [zgłoszenie](https://github.com/golangci/golangci-lint/issues/3094), aby dodać vulncheck jako linter.

Przykładowa definicja joba dla GitLab CI/CD:

```
golangci-lint:
  stage: qa
  image: golangci/golangci-lint:v1.50.1
  script:
    - golangci-lint run
```

Przykładowy plik konfiguracyjny:

```
linters:
  # Enable specific linter
  # https://golangci-lint.run/usage/linters/#enabled-by-default
  enable:
    - asasalint
    - asciicheck
    - bidichk
    - bodyclose
    - containedctx
    - contextcheck
    - cyclop
    - decorder
    - depguard
    - dogsled
    - dupl
    - dupword
    - durationcheck
    - errcheck
    - errchkjson
    - errname
    - errorlint
    - execinquery
    - exhaustive
#    - exhaustivestruct
#    - exhaustruct
    - exportloopref
    - forbidigo
    - forcetypeassert
    - funlen
#    - gci
    - gochecknoglobals
    - gochecknoinits
    - gocognit
    - goconst
    - gocritic
    - gocyclo
    - godot
    - godox
    - goerr113
    - gofmt
#    - gofumpt
    - goheader
#    - goimports
#    - gomnd
    - gomoddirectives
    - gomodguard
    - goprintffuncname
    - gosec
    - gosimple
    - govet
    - grouper
    - importas
    - ineffassign
    - interfacebloat
    - interfacer
    - ireturn
    - lll
    - loggercheck
    - maintidx
    - makezero
    - maligned
    - misspell
    - nakedret
    - nestif
    - nilerr
    - nilnil
    - nlreturn
    - noctx
    - nolintlint
    - nonamedreturns
    - nosprintfhostport
    - paralleltest
    - prealloc
    - predeclared
    - promlinter
    - reassign
    - revive
    - staticcheck
    - stylecheck
    - tagliatelle
    - tenv
    - testableexamples
    - testpackage
    - thelper
    - tparallel
    - typecheck
    - unconvert
    - unparam
    - unused
    - usestdlibvars
    - varnamelen
    - whitespace
#    - wrapcheck
#    - wsl

linters-settings:
  tagliatelle:
    # Check the struct tag name case.
    case:
      # `camel` is used for `json` and `yaml` (can be overridden)
      # Default: {}
      rules:
        # Any struct tag type can be used.
        # Support string case: `camel`, `pascal`, `kebab`, `snake`, `goCamel`, `goPascal`, `goKebab`, `goSnake`, `upper`, `lower`
        json: snake
        yaml: snake
  varnamelen:
    # Optional list of variable names that should be ignored completely.
    # Default: []
    ignore-names:
      - err
      - ch
    ignore-decls:
      - c echo.Context
      - t testing.T
      - e error
```
