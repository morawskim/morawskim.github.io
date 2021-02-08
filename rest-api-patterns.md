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

## Webhook

Webhooki możemy zabezpieczyć wykorzystując jedną z poniższych metod:

* biała lista adresów IP (trudne w utrzymaniu)
* wysyłanie tajnego tokenu w nagłówku zadania HTTP
* szyfrowanie i podpisywanie żądania HTTP
* użycie certyfikatów x509
