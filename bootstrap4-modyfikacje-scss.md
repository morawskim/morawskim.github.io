# bootstrap4 - modyfikacje SCSS

Instalując pakiet `bootstrap` otrzymamy pliki `scss`, które możemy zmodyfikować.
Wystarczy, że utworzymy plik cząstkowy (partial) np. `partials/_variables.scss`.
W tym pliku nadpisujemy zmienne bootstrapa. Aby zmienić odstępy domyślnych klas (p-[0-5], m-[0-5]) wystarczy zmodyfikować zmienną `$spacers` tak jak poniżej:

```
$spacer: 1rem !default;
$spacers: () !default;
$spacers: map-merge(
    (
            0: 0,
            1: ($spacer * .25),
            2: ($spacer * .5),
            3: $spacer,
            4: ($spacer * 1.5),
            5: ($spacer * 2)
    ),
    $spacers
);
```
Dostępne zmienne bootstrapa są zdefiniowane w pliku `~bootstrap/scss/variables`.
Możemy zmieniać zmienne kolorów `$body-color` czy też `$red`.

W naszym głównym pliku `scss` w którym importujemy pliki cząstkowe musimy wczytać naszą konfigurację zmiennych przed wczytaniem plików bootstrap. Jak w przykładzie poniżej:

```
@import 'partials/_variables';

@import '~bootstrap/scss/variables';
@import '~bootstrap/scss/functions';
@import '~bootstrap/scss/mixins';

@import "~bootstrap/scss/utilities/sizing";
@import "~bootstrap/scss/utilities/text";
@import "~bootstrap/scss/utilities/borders";
@import "~bootstrap/scss/bootstrap-grid";
@import "~bootstrap/scss/card";
@import "~bootstrap/scss/forms";
@import "~bootstrap/scss/input-group";
@import "~bootstrap/scss/popover";
```

Dzięki temu nie musimy nadpisywać klas bootstrapa własnymi, tylko dostosować style bootstrapa do projektu.
[Demo online](https://codesandbox.io/s/bootstrap-scss-with-overrides-iq9m9?file=/scss/main.scss)
