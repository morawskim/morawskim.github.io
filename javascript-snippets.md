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

## Sprawdzenie czy wartość jest liczbą całkowitą

Do sprawdzenia czy wartość jest liczbą całkowitą można użyć metody `Number.isInteger()`.
Jeśli metoda nie istnieje możemy skorzystać z poniższej funkcji:

```
console.log(12 % 1 === 0);
true

console.log(12.34 % 1 === 0);
false
```

Dostępne są także inne implementacje np. https://developer.mozilla.org/pl/docs/Web/JavaScript/Referencje/Obiekty/Number/isInteger#Polyfill