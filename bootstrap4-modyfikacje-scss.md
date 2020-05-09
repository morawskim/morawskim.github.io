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

W naszym głównym pliku `scss` w którym importujemy pliki cząstkowe musimy wczytać naszą konfigurację zmiennych przed wczytaniem plików bootstrap. Jak w przykładzie poniżej. Dzięki temu nie musimy nadpisywać klas bootstrapa własnymi, tylko dostosować style bootstrapa do projektu.

```
@import './abstracts/variables';

// te importy powinismy zdefiniowac w pliku `./vendors/bootstrap`
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

Chcąc zbudować responsywną stronę w oparciu o framework Bootstrap warto zapoznać się z domieszkami z pliku [scss/mixins/_breakpoints.scss](https://github.com/twbs/bootstrap/blob/v4.3.1/scss/mixins/_breakpoints.scss). W nim mamy zdefiniowane domieszki `media-breakpoint-only`, `media-breakpoint-up`, czy `media-breakpoint-down`. Pozwalają one zbudować nam własne responsywne komponenty. Plik źródłowy zawiera komentarze, wyjaśniające co dokładniej dana domieszka robi. Framework Bootstrap definiuje kilka punktów `breakpoint`, czyli rozdzielczość podczas których uruchamiana jest reguła media queries. Bootstrap 4 definiuje następujące punkty breakpoint (zmienna `grid-breakpoints`):

* xs: 0
* sm: 576px
* md: 768px
* lg: 992px
* xl: 1200px

W zależności czy budujemy stronę z zasadą "mobile first" czy "desktop first", to korzystamy z różnej domieszki. W przypadku "mobile first" korzystamy z domieszki `media-breakpoint-up`, a nasze reguły media queries umieszczamy w pliku od najmniejszej rozdzielczości do największej. W przypadku podejścia "desktop first" korzystamy z domieszki `media-breakpoint-down` i reguły umieszczamy od największej rozdzielczości do najmniejszej.

[Demo online](https://codesandbox.io/s/bootstrap-scss-with-overrides-iq9m9?file=/scss/main.scss)
