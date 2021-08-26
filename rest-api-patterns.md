# REST API patterns

## Filtrowanie

Często spotykaną metodą filtrowania po atrybutach są nawiasy kwadratowe np. `price[gte]=80&price[lte]=100`. Zapomocą funkcji PHP `parse_str` możemy przekształcić ciąg znaków w tablicę - [http://sandbox.onlinephpfunctions.com/code/e560be2f22942766451358db85bb3c4fc09b11f9](http://sandbox.onlinephpfunctions.com/code/e560be2f22942766451358db85bb3c4fc09b11f9). Możemy więc zaimplementować dla atrybutu różne operatory jak np. `gt` ale też `contains` czy `after` dla dat. Framework API Platform korzysta z tego rozwiązania.

Przykładowy schemat OpenAPI do opisu parametrów z nawiasami kwadratowymi (do sprawdzenia na stronie [https://editor.swagger.io/#](https://editor.swagger.io/)

```
openapi: 3.0.1
info:
  title: Parameters with square brackets
  description: |
    Example of usage parameter with square brackets in OpenAPI
  version: 1.0.0
servers:
- url: https://httpbin.org/
paths:
  /get:
    get:
      parameters:
        - in: query
          name: price
          schema:
            type: object
            properties:
              lt:
                type: integer
                example: 100
              gt:
                type: integer
                example: 80
          style: deepObject
      responses:
        200:
          description: Success response dump all headers and query string parameters
          content: {}

```


[LHS BracketsPermalink](https://www.moesif.com/blog/technical/api-design/REST-API-Design-Filtering-Sorting-and-Pagination/#lhs-brackets)

[Range Filter](https://api-platform.com/docs/core/filters/#range-filter)

## Dobre praktyki

* Końcówki powinny zwracać dane w formacie umożliwiającym rozszerzenie (dodanie metadanych np. informacji o łącznej liczbie elementów). Dane powinny być opakowane w obiekt. [Wrap collection in object](https://github.com/allegro/restapi-guideline#wrap-collection-in-object)

* Ograniczajmy korzystanie z typu boolean dla pól reprezentujących status (np. isPublished). Wartość logiczna uniemożliwia dodanie dodatkowych statusów.

* Nie stosujmy "magicznych liczb" (np. dla pól status), a zamiast nich korzystajmy z kodów w formie łańcucha znaków.

* [Zagnieżdżajmy obce relacje](https://github.com/allegro/restapi-guideline#nesting-foreign-resources-relations)

* Nie powinniśmy umieszczać w parametrach ścieżki ani w query string wrażliwych danych

* Klient HTTP powinien traktować każdy nierozpoznany kod status HTTP jako odpowiednik kodu statusu x00 klasy np. "201 Created" traktujemy jak "200 OK"

* Włączmy kompresje dla protokołu HTTP1.1 (i persistent connection), a najlepiej migrujmy do protokołu HTTP2

* Zasób REST powinien być rzeczownikiem w formie mnogiej [Resource Name](https://github.com/allegro/restapi-guideline#name)

* Tworząc końcówki batch musimy zwracać status i błędy/ostrzeżenia dla wszystkich elementów z żądania. Możemy wykorzystać kod HTTP 207 (MULTI Status) [Zalando HTTP 207](https://opensource.zalando.com/restful-api-guidelines/#152)

* RPC bardziej pasuje w przypadku stateless API, zaś REST do stateful API.

* Prostota nie oznacza ograniczenie ilości końcówek REST, bo najczęściej taki ruch przesuwa złożoność w kierunku skomplikowanego wywołania końcówki.

* Powinniśmy zawsze mieć na uwadze wsteczną kompatybilność. Końcówki projektujemy tak, aby łatwo je rozbudować w przyszłości - nie naruszając wstecznej kompatybilności.

* Identyfikatory/Tokeny możemy kodować wykorzystując [Crockford Base32](https://en.wikipedia.org/wiki/Base32). Najpopularniejsza wariacja nie zawiera liczb 0 i 1, ponieważ mogą się mylić z znakami "O" i "I".

* Dobrą praktyką jest zagnieżdżanie zasobów, gdy kasowanie rodzica ma kasować wszystkie podrzędne relacje, albo ustawienie zasad bezpieczeństwa na elemencie nadrzędnym mają "spływać" także na dzieci.

* Podczas generowania identyfikatora, w celu uniknięcia kolizji, wciąż najlepszym rozwiązaniem jest używanie wystarczająco długiego identyfikatora relatywnie do liczby tworzonych zasobów i korzystanie z niezawodnych i kryptograficznie bezpiecznych generatorów liczb losowych.

* Własne metody używają metody POST  i separatora ":", aby zadeklarować akcję. Konwencja nazewnicza jest podobna do standardowych metod `<Verb><Noun>` np. "/api/messages/1:clone" [Custom methods](https://cloud.google.com/apis/design/custom_methods)

* Jakikolwiek sposób, który znacząco zmienia podstawowe zachowanie metody API jest bardzo złym pomysłem. W ten sposób bardzo utrudniamy sobie monitorowanie i egzekwowanie celów SLA na poziomie usług.

* Ponawianie żądań odbywa się stosunkowo szybko po wystąpieniu awarii, zwykle kilka sekund po pierwotnym żądaniu. Dobrym punktem wyjścia dla zasad wygasania pamięci podręcznej z przetworzonymi identyfikatorami żądania jest około 5 minut, ale także resetowanie tego licznika przy każdym dostępie do buforowanej wartości. Jeśli mamy trafienie w pamięci podręcznej oznacza to, że żądanie zostało ponowione i w przypadku kolejnych niepowodzeń chcemy zachować taką samą politykę wygaśnięcia jak przy pierwszych próbach.

* Żądania mogą zakończyć się niepowodzeniem w dowolnym momencie, dlatego jeśli nie otrzymamy potwierdzonej odpowiedzi z API, nie ma możliwości upewnienia się, czy żądanie zostało przetworzone, czy nie.

## Webhook

Webhooki możemy zabezpieczyć wykorzystując jedną z poniższych metod:

* biała lista adresów IP (trudne w utrzymaniu)
* wysyłanie tajnego tokenu w nagłówku zadania HTTP
* szyfrowanie i podpisywanie żądania HTTP
* użycie certyfikatów x509

[OpenApi Webhook example](https://github.com/OAI/OpenAPI-Specification/blob/master/examples/v3.1/webhook-example.yaml)

## Asynchroniczność

Definicja interfejsów Operation i OperationError z JJ Geewax, _API Design Patterns_, Manning

```
interface Operation<ResultT, MetadataT> {
  id: string;
  done: boolean;
  result?: ResultT | OperationError;
  metadata?: MetadataT;
}

interface OperationError {
  code: string;
  message: string;
  details?: any;
}
```

## Bezpieczeństwo

* [deserialization vulnerability](https://cheatsheetseries.owasp.org/cheatsheets/Deserialization_Cheat_Sheet.html)
    * jeśli to możliwe korzystamy z formatu JSON
    * zezwalamy tylko na klasy z białej listy


* [session fixation](https://owasp.org/www-community/attacks/Session_fixation)
    * Zawsze generujemy nowy identyfikator sesji, po uwierzytelnieniu użytkownika
    * Identyfikator sesji przesyłamy tylko przez cookie

* [ABAC](https://en.wikipedia.org/wiki/Attribute-based_access_control)
    * ABAC to alternatywa dla RBAC (role-based access control)
    * Decyzje dotyczące kontroli dostępu są podejmowane dynamicznie dla każdego żądania API przy użyciu atrybutów podzielonych w cztery kategorie:
        * atrybuty podmiotu (zalogowanego użytkownika)
        * atrybuty dotyczące zasobu, do którego uzyskiwany jest dostęp
        * atrybuty dotyczące akcji, którą użytkownik próbuje wykonać (edycja, kasowanie)
        * atrybut dotyczący środowiska lub kontekstu (np. pora dnia, dzień tygodnia)

* capability token
    * Często wykorzystywany do współdzielenia dostęp do dokumentu/zasobu
    * Nie wymaga konta

* Macaroons to rodzaj tokenu kryptograficznego, który można używać do reprezentowania możliwości i innych uprawnień autoryzacyjnych. Można dołączyć nowe obostrzenia do tokenu, które ograniczają sposób, w jaki można go używać.

* Nigdy nie podążamy za przekierowaniami HTTP
