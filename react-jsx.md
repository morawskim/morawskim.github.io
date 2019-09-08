# React & JSX

## Babel

Tworzymy katalog np. `react-babel-jsx` i przechodzimy do niego.

Wywołujemy polecenie `npm init` i odpowiadamy na pytania. Te polecenie wygeneruje nam plik `package.json`.

Instalujemy zależności `react` i `react-dom` poleceniem `npm install --save react react-dom`.

Instalujemy pakiet babel, preset-react i serwer http poleceniem `npm install --save-dev @babel/cli @babel/core @babel/preset-react http-server`

Tworzymy nowy plik `.babelrc` w głównym katalogu projektu (`react-babel-jsx`) o zawartości:

``` json
{
  "presets": ["@babel/preset-react"]
}
```

Babel preset to nic innego jak z góry ustalony zestaw pluginów przekształcających składnie. W tym przypadku JSX do JS.

Tworzymy katalog `src` a w nim plik `app.jsx` i wklejamy do niego kod naszego przykładowego komponentu

```
class HelloWorldComponent extends React.Component {
    render() {
        return (
            <h1>Hello {this.props.name}</h1>
        );
    }
}

ReactDOM.render(
    <HelloWorldComponent name="react & JSX world!" />,
    document.getElementById('content')
);

```

Następnie tworzymy plik `index.html`. I wklejamy poniższy kod:

```
<!DOCTYPE html>
<html>
 <head>
     <meta charset="utf-8">
     <meta name="viewport" content="width=device-width">
     <title>React JSX</title>
     <script src="/react.js" type="text/javascript" charset="utf-8"></script>
     <script src="/react-dom.js" type="text/javascript" charset="utf-8"></script>
 </head>
 <body>
     <div id="content"></div>
     <script src="/app.js" type="text/javascript" charset="utf-8"></script>
 </body>
</html>
```

Ważne jest aby nasz skrypt `app.js` był wczytywany po elemencie HTML o id `content`.
W przeciwnym przypadku dostaniemy błąd: `Invariant Violation: Target container is not a DOM element.`

W pliku `package.json` dodajemy w sekcji `scripts` nowe elementy:

``` json
"build": "babel src -d public/",
"preserver": "cp node_modules/react/umd/react.development.js ./public/react.js && cp node_modules/react-dom/umd/react-dom.development.js ./public/react-dom.js",
"server": "http-server ./public"
```

Wywołujemy polecenie `npm run build`, które przetworzy pliki JSX i stworzy pliki js w katalogu `public`.
Następnie uruchamiamy nasz serwer http poleceniem `npm run server`.

Repo gita: [https://github.com/morawskim/html5-examples/tree/master/react.js/babel-jsx](https://github.com/morawskim/html5-examples/tree/master/react.js/babel-jsx)
