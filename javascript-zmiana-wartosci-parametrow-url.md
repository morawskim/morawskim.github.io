# JavaScript - zmiana wartości parametrów URL

Obecne przeglądarki posiadają wsparcie dla zarządzania parametrami adresu URL (query string). Za pomocą dostarczanego API możemy dodawać, modyfikować lub kasować parametry. Klasa oferująca te możliwości to `URLSearchParams`.

Korzystając z serwisu [caniuse](https://caniuse.com/#feat=urlsearchparams) możemy sprawdzić, które przeglądarki nie obsługują tego API. Dla tych przeglądarek istnieje polyfill. Musimy tylko zainstalować pakiet npm `@ungap/url-search-params` (https://github.com/ungap/url-search-params#readme).

Jeśli korzystamy z type script to potrzebujemy także pliku definicji dostępny w pakiecie `@types/url-search-params`.
Mając już wszystkie zależności możemy zacząć modyfikować nasz query string.

``` javascript
//tworzymy nowa instancję URLSearchParams, ustawiamy wartosc parametru foo na bar i ostatecznie wyswietlamy pelen adres url
const urlSearchParams = new URLSearchParams(window.location.search.slice(1));
urlSearchParams.set('foo', 'bar');
const redirectTo = new URL(window.location.href);
redirectTo.search = urlSearchParams.toString();
console.log(redirectTo.toString());
```

https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams