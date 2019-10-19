# Zastana aplikacja PHP i webpack HMR

W przeszłości aplikacje PHP nie posiadały złożonej logiki na frontendzie.
Obecnie to się zmienia. Czasy prostych skryptów jQuery minieły.
Dziś coraz częsciej chcemy do zastanej aplikacji PHP dodać złożony front.
Jeśli aplikacja była budowana od początku jako SPA, wtedy nie musimy się martwić o ciagłe przeładowywanie strony.
Podobny efekt (choć z ograniczeniami) możemy uzyskać i dla hybdrydowej aplikacji.

W pliku konfiguracyjnym webpack `webpack.config.js` musimy wprowadzić kilka zmian.

Nasz plik wejściowy (entry point) musi zawierać dodatkowo dwa skrypty:
```
[
  './assets/js/app.js',
  'webpack/hot/dev-server',
  'webpack-dev-server/client?http://localhost:8765/'
]
```

`http://localhost:8765/` to adres naszego `webpack-dev-server`.

W kluczu `output` dodajemy `publicPath: 'http://localhost:8765/'`.
Określa on adres url, gdzie dostępne są nasze spakowane pliki js/css.
Cały klucz `output` wygląda tak:
```
output: {
    path: path.resolve(__dirname, 'public', 'dist'),
    filename: '[name].bundle.js',
    publicPath: 'http://localhost:8765/dist/'
  },
```

Następnie konfigurujemy `webpack-dev-server`.
```
devServer: {
    contentBase: "./public",
    host: '0.0.0.0',
    port: 8765,
    hot: true,
},
```

`contentBase` to nasz `DOCUMENT_ROOT` z apache. Ważne jest ustawienie opcji `hot` na `true`.
Musimy jeszcze skonfigurować sekcję `plugins`.
Na górze pliku konfiguracyjnego importujemy pakiet npm `webpack` do zmiennej - `const webpack = require('webpack');`
Dodajemy w sekcji `plugins` plugin `new webpack.HotModuleReplacementPlugin()`.

Po tych zmianach po przejściu na stronę `index.php` powiniśmy dostać w logach konsoli takie coś:
```
[WDS] Hot Module Replacement enabled.
app.bundle.js:1 [WDS] Live Reloading enabled.
app.bundle.js:1 [WDS] Hot Module Replacement enabled.
app.bundle.js:1 [WDS] Live Reloading enabled.
```

Musimy jeszcze w naszym `entry point` (app.js) dodać:
```
if (module.hot) {
  module.hot.accept();
}
```
Dzięki temu strona nie zostanie przeładowana, a zmiany będą widoczne. Ma to jednak swoje skutki uboczne.
W większości przypadków chcemy przeładować całą stronę. Inaczej musielibyć obslugiwać przypadki modyfikacji DOM. Np. przypisanie zdarenia do elementu DOM zostanie wywołane wielokrotnie.

Teraz jak wejdziemy na stronę `index.php` z innego portu dostaniemy błąd: `Access to XMLHttpRequest at 'http://localhost:8765/dist/8bda870823a320ae31cf.hot-update.json' from origin 'http://127.0.0.1:3456' has been blocked by CORS policy: No 'Access-Control-Allow-Origin' header is present on the requested resource.`

Do konfiguracji `devServera` dodajemy:

```
headers: {
    'Access-Control-Allow-Origin': '*'
}
```

Po zresetowaniu `webpack-dev-server` i odświeżeniu strony nasze zmiany w plikach js powinny być widoczne.

```
[WDS] App updated. Recompiling...
app.bundle.js:1 [WDS] App hot update...
app.bundle.js:1 [HMR] Checking for updates on the server...
app.bundle.js:1 [WDS] App hot update...
[HMR] Updated modules:
app.bundle.js:1 [HMR]  - 34
app.bundle.js:1 [HMR] Consider using the NamedModulesPlugin for module names.
app.bundle.js:1 [HMR] App is up to date.
```

[Demo](https://github.com/morawskim/php-examples/tree/master/legacy-app-webpack-hot)

https://www.javascriptstuff.com/webpack-hmr-tutorial/

https://www.javascriptstuff.com/understanding-hmr/
