# React hooks vs class components

## componentDidMount i componentDidUpdate vs useEffect

W komponencie klasowym implementując metody `componentDidMount` i `componentDidUpdate` możemy reagować po każdym wyświetleniu komponentu. Taki sam efekt można uzyskać w komponentach funkcyjnych korzystając z hooka `useEffect`.
Pomijamy parametr z listę zależności - `useEffect(() => console.log("after render"));`

## componentDidMount vs useEffect

W komponencie klasowym implementując metodę `componentDidMount` możemy osiągnąć efekt jednorazowego wykonania kodu po wyrenderowaniu komponentu. Taki sam efekt można uzyskać w komponentach funkcyjnych korzystając z hooka `useEffect`. Jako listę zależności podajemy pustą tablicę - `useEffect(() => console.log("only once"), []);`

## componentDidUpdate vs useEffect

W komponencie klasowym implementując metodę `componentDidUpdate` możemy reagować kiedy stan lub props komponentu uległy zmianie. Taki sam efekt można uzyskać w komponentach funkcyjnych korzystając z hooka `useEffect`.
W liście zależności musimy podać obserwowaną zmienną stanu lub props - `useEffect(() => console.log("updated"), [props.categoryId]);`

## componentWillUnmount vs useEffect

W komponencie klasowym implementując metodę `componentWillUnmount` możemy dokonać porządków przed finalnym usunięciem komponentu z DOM. Taki sam efekt można uzyskać w komponentach funkcyjnych korzystając z hooka `useEffect`. Musimy w funkcji wywołania zwrotnego przekazanej do hooka zwrócić funkcję, która zostanie uruchomiona przed skasowaniem komponentu.

``` javascript
useEffect(() => {
    console.log("init");
    return () => {
        console.log("cleanup");
    }
}, []);
```

## useState vs useReducer

Preferuje używanie hooka `useReducer` niż `useState` gdy:
* w stanie chce przechowywać typ złożony (obiekt lub tablica)
* nowy stan wyliczany jest na podstawie poprzedniego stanu
* musimy skorzystać z logiki biznesowej
