# React, typescript i HoC

W projekcie wykorzystaliśmy bibliotekę [material-table](https://material-table.com/).
Jak się okazało ta biblioteka nie obsługuje jednocześnie edycji/kasowania wiersza i zaznaczania:

https://stackoverflow.com/questions/58150039/material-table-how-to-do-selectable-and-editable-table

https://github.com/mbrn/material-table/issues/1107

Mając widzę co i gdzie trzeba zmienić postanowiłem utworzyć HoC dla komponentów `MTableFilterRow` i `MTableHeader`. Komponenty te przyjmują odpowiednio `hasActions` i `showActionsColumn` w props.
Określają one czy komponent powinien wyrenderować kolumnę akcji.

Plik definicji typescript dla tej biblioteki nie eksportuje definicji propsów dla tych dwóch komponentów.
Nie możemy, więc ograniczyć przekazanych parametrów.

```
import React from 'react';

const withActionColumns = <P extends object>(Component: React.ComponentType<P>) => {
    class WithActionColumn extends React.Component<P> {
        render() {
            return <Component {...this.props as P} hasActions={true}/>;
        }
    }

    return WithActionColumn;
};

export default withActionColumns;
```

Dzięki przypisaniu na stałe wartości true do atrybutu `hasActions` `material-table` zawsze wyrenderuje naszą kolumnę akcji. Podobny HoC utworzyłem dla `MTableHeader`.

W przypadku gdyby biblioteka `material-table` dostarczała plik definicji propsów dla komponentów wtedy w deklaracji naszego HoC moglibyśmy użyć `<P extends MTableHeaderProps>` zamiast `<P extends object>`.

Typ `React.ComponentType<P>` to alias na klasowy lub funkcyjny komponent - `type ComponentType<P = {}> = ComponentClass<P> | FunctionComponent<P>;`.


https://medium.com/@jrwebdev/react-higher-order-component-patterns-in-typescript-42278f7590fb
