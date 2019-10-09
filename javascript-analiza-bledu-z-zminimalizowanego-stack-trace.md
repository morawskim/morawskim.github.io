# JavaScript analiza błędu z zminimalizowanego stack trace

Obecne aplikacje mają bardzo rozbudowany front. W przypadku błędu dostaniemy w konsoli informacje o przyczynie błędu. Taki błąd nie jest przysyłany na serwer co utrudnia jego naprawienie. Dodatkowo w środowiskach produkcyjnych stos błędu tyczy się zminimalizowanych plików js. Z tym wszystkim można sobie jednak poradzić.

Wpierw konfigurujemy `webpack`, aby dla builda produkcyjnego tworzył tzn. `source maps`.
W pliku `webpack.config.js` ustawiamy opcję `devtool` na wartość `hidden-source-map`.
Dzięki temu `webpack` wygeneruje nam plik `<name>.js.map` dla każdego entry point, ale plik `bundle` nie zawiera odwołania do pliku map.
Plików map nie musimy przechowywać na serwerach produkcyjnych. Wystarczy go trzymać jako artefakt procesu CI.

>hidden-source-map - Same as source-map, but doesn't add a reference comment to the bundle. Useful if you only want SourceMaps to map error stack traces from error reports, but don't want to expose your SourceMap for the browser development tools.

W kodzie musimy nasłuchiwać na błędy  JS. Obecnie możemy to zrobić nasłuchując na zdarzenie `error`.
Dodatkowo wykorzystujemy bibliotekę `error-stack-parser` do parsowania stosu wywołań funkcji.
Zamiast logować błąd przez `console.log` możemy przesłać te informacje na serwer i zarejestrować je.
Można nawet wykorzystać do tego Google Analytics.

```
window.addEventListener('error', function(e) {
    e.preventDefault(); //zapobiega uruchomieniu domyślnej procedury obsługi błedu
    const {message, filename, lineno, colno, error} = e;
    let stack = null;
    if (error && error instanceof Error) {
        stack = ErrorStackParser.parse(error) || [];
    }
    const userAgent = navigator.userAgent;
    console.error({message, filename, lineno, colno, stack, userAgent});
});
```

Kiedy pojawi się błąd, który nie zostanie obsłużony przez instrukcję `try/catch` odpali się nasza procedura i wyświetli w konsoli obiekt błędu:

```
{
  "message": "Uncaught Error: Ohhh....",
  "filename": "http://0.0.0.0:8080/dist/app.bundle.js",
  "lineno": 38,
  "colno": 20312,
  "stack": [
    {
      "columnNumber": 20312,
      "lineNumber": 38,
      "fileName": "http://0.0.0.0:8080/dist/app.bundle.js",
      "source": "    at http://0.0.0.0:8080/dist/app.bundle.js:38:20312"
    },
    {...}
  ],
  "userAgent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36"
}
```

Właściwość `stack` przechowuje stos wywołań funkcji. W tym przypadku błąd pojawił się w pliku `app.bundle.js`, lini `38` w kolumnie `20312`. Mając te dane i nasz plik `sourcemap` możemy uzyskać miejsce wystąpienia błędu.

Do tego celu potrzebujemy pakietu npm `source-map-cli`.
Wywołujemy polecenie `./node_modules/.bin/source-map  resolve  --context 20 ./public/dist/app.bundle.js.map  38 20312`. Parametr `--context` pozwala nam wyświetlić dodatkowe linie wokół linii, która spowodowała rzucenie błędu.
`./public/dist/app.bundle.js.map` to ścieżka do wygenerowanego przez `webpacka` pliku `sourcemap`. `38` i `20312` to odpowiednio linia i kolumna z naszej ramki stosu wywołań.

Uzyskamy wynik:
```
Maps to webpack:///src/actions/shoppingListActions.js:4:10

import {ADD_ITEM_TO_SHOPPING_LIST} from './constants';

export function addItemToShoppingList(name) {
    throw new Error("Ohhh....");
          ^
    return {type: ADD_ITEM_TO_SHOPPING_LIST, payload: {name}};
}
```

W pliku `src/actions/shoppingListActions.js:4:10` zrzucamy błąd `"Ohh"` i to jest przyczyna błędu.

[Demo](https://github.com/morawskim/html5-examples/tree/master/webpack/tracking-min-js-errors)

## Logowanie błędów do Google Analytics

Błąd po stronie klienta można przechwycić jak powyżej i przesłać do narzędzia GA za pomocą choćby takiego kodu: `ga('send', 'event', 'window.error', message, JSON.stringify(errorObj), undefined, { 'NonInteraction': 1 });`
