# TS2339: Property does not exist on type

W projekcie korzystałem z biblioteki React.js i TypeScript.
Biblioteka `material-table` oferuje funkcjonalność zaznaczania wierszy tabeli.
Jednak potrzebowałem domyślnie zaznaczyć wybrane wiersze. Aby to zrobić musimy w ustawieniach komponentu `MaterialTable` przekazać do właściwości `selectionProps` funkcję (https://material-table.com/#/docs/features/selection).

[material-table](https://github.com/mbrn/material-table/blob/7d54de1725d0df1abfc6ddbef5d02a4abf10eced/src/components/m-table-body-row.js#L46) przekaże naszej funkcji model. Aby zaznaczyć wiersz musimy ustawić właściwość `<model>.tableData.checked` na wartość `true`. Jednak jeśli zrobimy to w taki sposób jak poniżej:

```
selectionProps: (data: OurModel) => {
    data.tableData.checked = true;
}
```
Dostaniemy błąd `TS2339: Property 'tableData' does not exist on type`.
Dzięki [Intersection Types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#intersection-types) możemy rozwiązać ten problem. Intersection type łączy wiele typów w jeden. Dzięki temu do istniejącego typu (interfejsu/klasy) możemy dodać nowe właściwości. Oznacza to, że nowy typ będzie miał wszystkie właściwości wszystkich typów. Typy łączymy za pomocą symbolu `&`.

`material-table` w swoim pliku definicji dla TypeScript nie deklaruje właściwości `tableData` - https://github.com/mbrn/material-table/blob/7d54de1725d0df1abfc6ddbef5d02a4abf10eced/types/index.d.ts.
Jednak możemy to zrobić po swojej stronie.
Tworzymy interfejsy:
```
interface MaterialTableRowState {
    checked?: boolean
}

interface MaterialTableRowTableData {
    tableData: MaterialTableRowState
}
```

Następnie możemy zdefiniować funkcję anonimową dla `selectionProps`, która będzie mieć sygnaturę `(data: OurModel & MaterialTableRowTableData): void`. Nasz błąd zniknie, a dodatkowo środowiska programistyczne będą nam podpowiadać klucze w obiekcie `tableData`. Komponent `material-table` przechowuje swój stan w naszym modelu, co powoduje pewne skutki uboczne.

