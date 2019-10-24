# eslint

## eslint i react

O integracji między `eslint` i `react` pisałam [tutaj](react-i-eslint.md).

## Reguła no-undef

W projekcie wykorzystywałem eslint do statycznej analizy kodu java script.
W jednym z pliku wykorzystywałem funkcję `ga` z Google Analytics.
Podczas sprawdzania plików przez `eslint` dostałem błąd:

```
13:5 error 'ga' is not defined no-undef
```

[Dokumentacja tej reguły](https://eslint.org/docs/rules/no-undef) prezentuje rozwiązanie. Wystarczy dodać komentarz w pliku (na górze):

```
/* global ga */
```

Dzięki temu `eslint` nie będzie zwracał błędu, że funkcja `ga` jest niezdfiniowana.

