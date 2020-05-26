# React - memo

`React.memo` to funkcja, która służy do optymalizacji wydajności renderowania funkcyjnych komponentów. Wynik jest przechowywany w pamięci i zwracany, jeśli jest wywoływany z takimi samymi właściwościami (props). `React.memo` zapobiega wywoływaniu funkcji renderującej. Jeśli komponent używa hooków `useState` lub `useContext`, nadal będzie się aktualizował przy zmianie stanu lub kontekstu. `React.memo` wprowadza pewien narzut. Warto rozważyć czy jest to korzystne rozwiązanie, gdy właściwości często się zmieniają, lub musimy przechowywać w pamięci duże struktury danych. Podstawowe użycie wygląda następująco: musimy owinąć komponent funkcji w funkcję React.memo.

``` javascript
const MyComponent = React.memo(function MyComponent(props) {
  /* renderuj korzystając z właściwości */
});
```

Domyślnie, wykonywane jest jedynie płytkie porównanie obiektów przekazanych we właściwościach. Aby zastosować własny mechanizm porównujący, przekazujemy naszą funkcję jako drugi argument.

``` javascript
function MyComponent(props) {
  /* renderuj korzystając z właściwości */
}
function areEqual(prevProps, nextProps) {
  /*
  zwróć true, jeśli przekazując nextProps, komponent zwróciłby
  taki sam rezultat, jak po przekazaniu prevProps;
  w innym przypadku zwróć false
  */
}
export default React.memo(MyComponent, areEqual);
```

[React.memo](https://pl.reactjs.org/docs/react-api.html#reactmemo)

## useMemo

Hook `useMemo` zwraca zapamiętaną wartość. Hook ten obliczy ponownie zapamiętaną wartość tylko wtedy, gdy zmieni się któraś z zależności. Dzięki temu, jesteśmy w stanie uniknąć kosztownych obliczeń przy każdym renderowaniu komponentu.

``` javascript
const memoizedValue = useMemo(() => computeExpensiveValue(a, b), [a, b]);
```

[useMemo](https://pl.reactjs.org/docs/hooks-reference.html#usememo)


## useCallback

Hook `useCallback` zwraca zapamiętaną funkcję zwrotną (callback). Hook zwróci zapamiętana wersję funkcji, która zmieni się tylko wtedy, gdy zmieni się któraś z zależności. Z tego hooka najczęściej korzystamy, gdy do komponentu podrzędnego przekazujemy funkcję obsługi zdarzenia.

``` javascript
const memoizedCallback = useCallback(
  () => {
    doSomething(a, b);
  },
  [a, b],
);
```

[useCallback](https://pl.reactjs.org/docs/hooks-reference.html#usecallback)
