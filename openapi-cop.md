# Weryfikacji wywołań API z schematem OpenAPI (openapi-cop)

Pakiet npm openapi-cop pozwala nam sprawdzić poprawność żądania HTTP w oparciu o schemat OpenAPI. W przypadku gdy request nie jest zgodny z specyfikacją OpenAPI otrzymamy błąd.

Jednak obecna wersja uniemożliwia nam przekazanie ruchu do serwera API, który w swojej nazwie zawiera myślnik albo kropkę np. `my-api.lvh.me`, lub nasłuchuje na porcie poniżej 1000. [Istnieje na to zgłoszenie](https://github.com/EXXETA/openapi-cop/issues/248).

Utworzyłem [PR](https://github.com/EXXETA/openapi-cop/pull/321), który to naprawia. Do momentu akceptacji możemy zainstalować bibliotekę za pomocą polecenia:
`npm install morawskim/openapi-cop#248-url-regex`

## cypress

Cypress może korzystać z serwera proxy. Umożliwia nam to integrację Cypress z openapi-cop i weryfikowanie czy komunikacja HTTP jest zgodna z schematem OpenAPI. Podczas uruchamiania Cypress musimy ustawić zmienną środowiskową `HTTP_PROXY`. Przykładowe wywołanie w kontenerze dockera może wyglądać następująco `docker run --env HTTP_PROXY=http://127.0.0.1:8888 --network=host --ipc=host --rm -it -v $(PWD)/e2e:/e2e -w /e2e cypress/included:6.6.0 --config video=false --env configFile=docker`.

Możemy natrafić na problem `Error: Parse Error: Content-Length can't be present with chunked encoding`.
Istnieje [zgłoszenie dla pakietu express.js](https://github.com/expressjs/express/issues/2893), ale nie jest to problem z tą biblioteką. Musimy ręcznie modyfikować kod `express.js` (`node_modules/express/lib/response.js`), albo `openapi-cop` (`node_modules/openapi-cop/build/src/app.js`).

Możemy także natrafić na problem [operationId is not being treated as optional](https://github.com/EXXETA/openapi-cop/issues/4). Obecnie nie ma żadnego rozwiązania, prócz generowanie dla każdej końcówki REST API identyfikator `operationId`.
