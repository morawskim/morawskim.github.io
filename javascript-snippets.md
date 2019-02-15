# javascript - snippets

## Losowa liczba z zakresu

`((max - min) * Math.random()) + min`

Np. losowa liczba z zakresu 2 i 10 będzie `8 + Math.random() + 2`


## Zastąpienie tekstu wraz z dołączeniem dopasowanego tekstu w zastępowanym ciągu znaków

`"HelloWorldFromJavaScript".replace(/[A-Z]/g, "_$&");`
Wynik to `_Hello_World_From_Java_Script`.

## Zamiana arguments na tablice

`Array.prototype.slice.call(arguments)`

## Wyświetlenie pobranej zawartości dokumentu PDF w nowym oknie

```
const file = new Blob([data], {type: 'application/pdf'});
const fileURL = URL.createObjectURL(file);
window.open(fileURL);
```
