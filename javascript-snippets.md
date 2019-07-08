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

``` javascript
function isFloat(x) {
 return Number.isFinite(x) && !Number.isInteger(x);
}
isFloat(4.2); // true
isFloat(4); // false
isFloat(NaN); // false
isFloat(Infinity); // false
```

## String.charAt i unicode

Obsługa znaków unicode w javascript nie jest doskonała. Jeśli będziemy korzystać z metody `String.charAt` zamiast znaku, możemy dostać dziwny symbol `�`. W celu rozwiązania tego problemu możemy skorzystać z metod `String.codePointAt` i `String.fromCodePoint`.

``` javascript
[...'\ud83d\udc0e\ud83d\udc71\u2764']
  .map(cp => cp.normalize().codePointAt(0))
  .map(cp => String.fromCodePoint(cp))
  .join('')
```

Więcej informacji:

* [https://ponyfoo.com/articles/es6-strings-and-unicode-in-depth#unicode](https://mathiasbynens.be/notes/javascript-unicode)
* [https://mathiasbynens.be/notes/javascript-unicode](https://mathiasbynens.be/notes/javascript-unicode)
* [You Don't Know JS: ES6 & Beyond](https://books.google.pl/books?id=rec6CwAAQBAJ&lpg=PA77&ots=RMU7j2_slj&dq=ecmascript%203%20charAt%20unicode&hl=pl&pg=PA77#v=onepage&q=ecmascript%203%20charAt%20unicode&f=false)
