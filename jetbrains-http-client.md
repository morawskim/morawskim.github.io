# JetBrains HTTP Client

## Generowanie request body za pomocą skryptu

Pracując z API, często musimy podstawiać do żądania wartości, które już istnieją w bazie danych i są ze sobą powiązane.

Przykładowo, chcemy utworzyć zamówienie dla konkretnego klienta.
W takim przypadku możemy pobrać produkty z bazy danych, a następnie wykorzystać je do zbudowania request body.

JetBrains HTTP Client umożliwia wykonywanie skryptów JavaScript przed wysłaniem żądania.
Nie jest to jednak pełny runtime Node.js.
Dostępne jest jedynie wybrane API.

Z moich testów wynikało, że polecenia uruchamiane przez `execSync()` domyślnie wykonują się z katalogu domowego użytkownika, a nie z katalogu projektu.
Chciałem więc ustalić ścieżkę do pliku HTTP i na jej podstawie wyznaczyć katalog roboczy.

Próbowałem użyć standardowego kodu:

```
import { fileURLToPath } from 'url';
const filename = fileURLToPath(import.meta.url);
```

Niestety otrzymałem błąd:

> Error: File not found at path specified: 'url'


Postanowiłem sprawdzić, jakie obiekty są dostępne w globalnej przestrzeni nazw.

```
console.log(Object.getOwnPropertyNames(globalThis).sort())
```

W wyniku otrzymałem między innymi:

```
[
  "$auth",
  "$env",
  "$exampleServer",
  "$historyFolder",
  "$isoTimestamp",
  "$projectRoot",
  "$random",
  "$randomInt",
  "$timestamp",
  "$uuid",
  "AggregateError",
  "Array",
  "ArrayBuffer",
  "Atomics",
// ....
```

Moją uwagę przykuł klucz `$projectRoot`.
Okazało się, że to funkcja zwracająca katalog główny projektu, czyli dokładnie to, czego potrzebowałem.

[JavaScript API supported by HTTP Client](https://www.jetbrains.com/help/idea/javascript-api-supported-by-http-client.html)

```
### Generate request body from command
< {%
    const requestBody = execSync("docker compose exec app /path/to/script/to/generate/request/body", {
        cwd: $projectRoot(),
    })
    // request.variables.set("requestBody", JSON.stringify(requestBody));
    request.variables.set("requestBody", requestBody);
%}
POST https://httpbin.io/post
Content-Type: application/json

{{requestBody}}
```
