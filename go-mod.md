# Go mod

## Instalacja modułu z własnego repozytorium

Jeśli w projekcie korzystamy z zewnętrznej biblioteki open source poprzez Go modules, może się zdarzyć że chcemy użyć wersji z własnego forku, na przykład kiedy chcemy przetestować nasze zmiany przed wysłaniem PR do opiekunów tej biblioteki.

W moim przypadku chciałem podmienić moduł `github.com/reugn/go-quartz` swoim forkiem, gdzie stworzyłem interfejs LoggerAdapter, aby zintegrować go-quartz z pakietem slog.
Prócz adresu forku, potrzebujemy SHA zatwierdzenia z naszymi zmianami - w moim przypadku było to "de0de4f73b2939462ad97bc9f9a56cd36876b2eb". Mając te dwie informacje wystarczy wywołać polecenie `go mod edit -replace github.com/reugn/go-quartz=github.com/morawskim/go-quartz@de0de4f73b2939462ad97bc9f9a56cd36876b2eb`.
Następnie wywołujemy polecenie `go mod tidy` w wyniku działania tego polecenia powinniśmy zobaczyć, że pakiet `go-quartz` został pobrany z forku:
> go: downloading github.com/morawskim/go-quartz v0.7.1-0.20230619154153-de0de4f73b29

Od tego momentu, nasz projekt będzie korzystał z mojej wersji pakietu go-quartz.
