# React MUI - Nadpisanie motywu zakładki (Tab Theme)

Korzystając z biblioteki material design dla `react.js`, nie mogłem nadpisać klas CSS komponentu `<Tab>`.
Natrafiłem na [wątek na forum stackoverflow](https://stackoverflow.com/questions/51958068/how-to-override-selected-color-in-theme-override-for-material-ui-for-react). Jedna z odpowiedzi kierowała do [dema online](https://codesandbox.io/s/mj9x1zy4j9), które z najnowszą wersją biblioteki mui nie działa. Trafiłem także na problem na [githubie](https://github.com/mui-org/material-ui-pickers/issues/833). Nowsza wersja  biblioteki wymaga innej składni. Wyświetla także w konsoli błąd i podaje rozwiązanie:

```
Material-UI: the `MuiTab` component increases the CSS specificity of the `selected` internal state.
You can not override it like this:

{

  "root": {

    "&:hover": {

      "backgroundColor": "#f8bbd0",

      "color": "#c2185b"

    }

  },

  "selected": {

    "backgroundColor": "#ffe0b2",

    "color": "#f57c00",

    "&:hover": {

      "backgroundColor": "#c8e6c9",

      "color": "#388e3c"

    }

  }

}


Instead, you need to use the $ruleName syntax:

{

  "root": {

    "&$selected": {

      "backgroundColor": "#ffe0b2",

      "color": "#f57c00",

      "&:hover": {

        "backgroundColor": "#c8e6c9",

        "color": "#388e3c"

      }

    }

  }

}


https://material-ui.com/r/pseudo-classes-guide
```

Istnieje także [demo online](https://codesandbox.io/s/w71yvp96ml), które korzysta z nowej składki i nadpisuje domyślne style komponentu `<Tab>`.
