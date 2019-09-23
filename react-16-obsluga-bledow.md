# React 16+ - obsługa błędów (error boundary)

Do wersji 16 biblioteka React miała problem z obsługą błędów w komponencie.
W nowej wersji wprowadzono koncepcję granic błędów (ang. error boundary).
Granice błędów to komponenty reactowe, które przechwytują błędy javascript komponentów potomków.
A następnie logują je i wyświetlają zastępczy interfejs UI.
Aby komponent klasowy stał się granicą błędu musi definiować najlepiej dwie metody: `static getDerivedStateFromError()` i/lub `componentDidCatch()`.
`static getDerivedStateFromError()` używamy do wyrenderowania zastępczego UI po rzuceniu błędu, a `componentDidCatch()`, aby zalogować informacje o błędzie.

Dodanie koncepcji granicy błędów powoduje zamianę zachowania nieobsłużonych błędów. Od teraz błędy, które nie zostały obsłużone za pomocą granicy błędów, spowodują odmontowanie całego drzewa komponentów.

Przykładowy komponent granicy błędów z dokumentacji React
```
class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(error) {
    // Zaktualizuj stan, aby następny render pokazał zastępcze UI.
    return { hasError: true };
  }

  componentDidCatch(error, errorInfo) {
    // Możesz także zalogować błąd do zewnętrznego serwisu raportowania błędów
    logErrorToMyService(error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      // Możesz wyrenderować dowolny interfejs zastępczy.
      return <h1>Something went wrong.</h1>;
    }

    return this.props.children;
  }
}
```

Po zdefiniowaniu komponentu granicy błędu używamy go jak normalnego komponentu:
```
<ErrorBoundary>
    <MyWidget />
</ErrorBoundary>
```


* https://pl.reactjs.org/docs/error-boundaries.html

* https://reactjs.org/blog/2017/07/26/error-handling-in-react-16.html

* [Przykład tworzenia i użycia granicy błędów z wykorzystaniem Reacta 16](https://codepen.io/gaearon/pen/wqvxGa?editors=0010)


## Stos wywołań komponentów

Jeśli biblioteka React podczas wyświetlania błędu w konsoli nie podaje nazw plików komponentu i linii, oznacza to że nie mamy włączonego pluginu babel `@babel/plugin-transform-react-jsx-source`. Tak jak poniżej:

```
The above error occurred in the <ListItem> component:
    in ListItem (created by GroceryList)
    in ul (created by GroceryList)
    in GroceryList
```
Docelowo:
```
The above error occurred in the <ListItem> component:
    in ListItem (at GroceryList.jsx:11)
    in ul (at GroceryList.jsx:7)
    in GroceryList (at app.js:6)
```

Jeśli korzystamy z webpacka i `@babel/preset-react` możemy go włączyć tylko dla środowiska developerskiego.
Ustawiając parametr `development` na wartość `true`. Jak poniżej.

```
....
// require packages @babel/core babel-loader @babel/preset-react
{
test: /\.jsx?$/,
exclude: /(node_modules|bower_components)/,
use: {
    loader: 'babel-loader',
    options: {
        presets: [
            '@babel/preset-env',
            [
                '@babel/preset-react',
                {development: process.env.NODE_ENV !== 'production'}
            ]
        ]
    }
}
....
```

https://github.com/morawskim/html5-examples/commit/577b336e51102e1321be788aa1525e81d3bcb77c
