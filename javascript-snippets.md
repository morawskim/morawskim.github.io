# javascript - snippets

## Losowa liczba z zakresu

`((max - min) * Math.random()) + min`

Np. losowa liczba z zakresu 2 i 10 będzie `8 + Math.random() + 2`


## Zastąpienie tekstu wraz z dołączeniem dopasowanego tekstu w zastępowanym ciągu znaków

`"HelloWorldFromJavaScript".replace(/[A-Z]/g, "_$&");`
Wynik to `_Hello_World_From_Java_Script`.
