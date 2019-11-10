# CSS - przyklejony nagłówek tabeli

Często chcemy, aby nagłówek tabeli pozostawał zawsze widoczny, gdy przewijamy stronę/tabelę.
Biblioteka `material-ui` dla `React.js` umożliwia nam stworzenie przyklejonego nagłówka (sticky header).
Wystarczy ustawić tylko parę reguł CSS - https://github.com/mui-org/material-ui/blob/3e25d1b6070abc979ff4db65db16ad55e0640daa/packages/material-ui/src/TableCell/TableCell.js#L95
Obsługa `sticky` jest dostępna w nowoczesnych przeglądarkach, ale w większości przypadków tylko dla elementu `th` - [https://caniuse.com/#feat=css-sticky].

``` css
th {
  position: sticky;
  top: 0;
  background-color: #f2f2f2;
}
```

[Utworzyłem demo dla Bootstrap.](https://codepen.io/morawskim/pen/dyyjbGe?editors=1111)

[https://developer.mozilla.org/en-US/docs/Web/CSS/position](https://developer.mozilla.org/en-US/docs/Web/CSS/position)
