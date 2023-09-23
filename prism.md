# Prism

[Prism](https://github.com/stoplightio/prism) pozwala nam między innymi uruchomić pośredniczący serwer HTTP, który weryfikuje czy żądania i odpowiedzi HTTP są zgodne z dokumentacją API.
Umożliwia nam to szybkie zweryfikowanie kontraktu między klientem i serwerem.

Wchodzimy na stronę publicznego API - [https://openlibrary.org/swagger/docs](https://openlibrary.org/swagger/docs) i pobieramy plik schematu API.
Zapisujemy plik w katalogu projektu pod nazwą `openapi.json`.

Tworzymy lub dodajemy do istniejącego pliku docker-compose usługę prism:

```
version: '3'
services:
  prism:
    image: stoplight/prism:4
    command: 'proxy /tmp/openapi.json https://openlibrary.org --errors -h 0.0.0.0'
    volumes:
      - ./openapi.json:/tmp/openapi.json:ro
    ports:
      - '8080:4010'
```

Nasz serwer proxy będzie nasłuchiwał na porcie 8080.
Wykorzystując curl możemy przesłać przykładowy request `curl  'http://localhost:8080/api/books'`
W odpowiedzi otrzymamy błąd z Prism (dzięki temu że przekazaliśmy flagę --errors do polecenia startu serwera proxy)

> {"type":"https://stoplight.io/prism/errors#UNPROCESSABLE_ENTITY","title":"Invalid request","status":422,"detail":"Your request is not valid and no HTTP validation response was found in the spec, so Prism is generating this error for you.","validation":[{"location":["query"],"severity":"Error","code":"required","message":"must have required property 'bibkeys'"}]

Wysyłając poprawiony request `curl -v 'http://localhost:8080/api/books?bibkeys=ISBN%3A0201558025&format=json&jscmd=viewapi'`  otrzymamy poprawną odpowiedź z serwera API openlibrary.

W przypadku problemów możemy przekazać argument `--verboseLevel` do polecenia startującego proxy z wartością "trace", aby w logach widzieć przepływ danych między klientem, proxy i zdalnym serwerem API.

Jeśli nasz serwer API dostępny jest pod ścieżką `/api/v1`, a w dokumentacji OpenAPI końcówki nie zawierają tej ścieżki to adres serwera API przekazanego do polecenia uruchamiającego serwer proxy musi zawierać także tą ścieżkę. 
Wysyłając zapytania do Prism pomijamy basePath. Innym słowem jeśli serwer API jest dostępny pod adresem "https://example.com/api/v1" i zawiera końcówkę "GET /foo" w dokumentacji OpenAPI, to przekazany adres serwera API do Prism to "https://example.com/api/v1". Następnie uderzamy na adres Prism `http://localhost:4010/foo` - pomijając basePath.
