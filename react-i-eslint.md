# React i eslint

Statyczne analizatory kodu potrafią wyłapywać błędy.
Mając już zainstalowaną bibliotekę `React`, możemy doinstalować `eslint` i plugin react do eslint - `npm i --save-dev eslint eslint-plugin-react`

Następnie generujemy plik konfiguracyjny dla eslint wywołując polecenie `npx eslint --init`

Odpowiadamy na pytania. Jeśli jako format pliku konfiguracyjnego wybraliśmy `js` to utworzony został plik `.eslintrc.js`.

W tym momencie jeśli wywołamy polecenie `eslint --ext .jsx --ext .js src/` dostaniemy błędy związane z składnią.

Musimy zainstalować pakiet `babel-eslint` - `npm i --save-dev babel-eslint`.

Następnie skonfigurować `eslint`, aby korzystał z nowo zainstalowanego pakietu do parsowania kodu.
Robimy to ustawiając w pliku konfiguracyjnym właściwość `parser` na wartość `babel-eslint`.

Ładujemy także domyślne zestawy reguł. Klucz `extends` powinien być tablicą:
```
"extends": [
    "eslint:recommended",
    "plugin:react/recommended",
],
```

Jeśli teraz wywołamy polecenie eslint to otrzymamy błąd `Warning: React version not specified in eslint-plugin-react settings. See https://github.com/yannickcr/eslint-plugin-react#configuration .`

W obecnej wersji (w przyszłości ma to się zmienić) musimy ręcznie ustawić wersję React'a, albo skorzystać z wartości `detect`. Wtedy wersja React'a zostanie automatycznie określona.

```
"settings": {
    "react": {
        "version": "detect",
    },
}
```

Teraz wywołując polecenie `eslint --ext .jsx --ext .js src/` sprawdzamy kod Reacta.

[Przykładowa integracja](https://github.com/morawskim/html5-examples/tree/master/react.js/eslint)

## Dodatkowe reguły react

W rekomendowanym zestawie reguł React'a nie ma włączonej reguły `react/no-access-state-in-setstate`.
Ta reguła pozwala uniknąć błędu:

>Z racji tego, że zmienne this.props i this.state mogą być aktualizowane asynchronicznie, nie powinno się polegać na ich wartościach przy obliczaniu nowego stanu.

W pliku konfiguracyjnym eslint np. `.eslintrc.js` do właściwości `rules` dodajemy jako klucz nazwę reguły, a jako wartość podajemy `error`. Dzięki temu te problemy będziemy traktować jako błąd.
Finalnie powinniśmy mieć coś takiego:
```
"rules": {
        "react/no-access-state-in-setstate": "error",
    },
```

W przypadku znalezienia błędu dostaniemy błąd `Use callback in setState when referencing the previous state  react/no-access-state-in-setstate`.