# Vue i legacy app

## Vue i znacznik &lt;template&gt;

W projekcie, który wykorzystywał jQuery, dodano bibliotekę Vue i zaczęto budować komponenty Vue.
Pojawił się problem, bo w niektórych miejsach wykorzystywany był znacznik HTML `<template>`.
Zamontowana aplikacja Vue w nadrzędnych elemencie, widząc znacznik template, traktowała go jako część komponentu i "kasowała" jego zawartość.
Rozwiązaniem tego problemu bazuje na [Updating arrays of elements with function refs in Vue 3](https://gist.github.com/AlexVipond/d0f82933f3451c9b1ed021a942817eb5).

```
import {createApp as vueCreateApp, ref, onMounted} from "vue/dist/vue.esm-bundler.js";

export function createApp() {
    return vueCreateApp({
        // Allows proper handling of template elements in Vue.js mount point
        // It assumes that each ignored template element has exactly one child element
        // https://gist.github.com/AlexVipond/d0f82933f3451c9b1ed021a942817eb5

        setup() {
            const ignoredTemplates = ref([]);
            const ignoredTemplateRef = (el) => {
                ignoredTemplates.value.push(el);
            }

            onMounted(() => {
                ignoredTemplates.value.forEach(el => {
                    if (el.content) {
                        el.content.append(el.firstElementChild);
                    }
                });
            });

            return { ignoredTemplateRef };
        }
    });
}
```

Ciągle jednak w aplikacji musimy wyszukać znaczniki `template` i dodać do nich atrybut `:ref` np. - `<template data-elem="progress-template" :ref="el => ignoredTemplateRef(el)">`

## jQuery i Vue

Po zamontowaniu aplikacji Vue, dodanie komponentu Vue przez jQuery nie powoduje jego wyświetlenia.
Tylko aplikacja Vue może dodawać nowe komponenty.
Jednym z rozwiązań tego problemu jest publikowanie zdarzenia przez jQuery i odebranie go w komponencie.
W tym celu korzystamy z hooków `onMounted` do nasłuchiwania na zdarzenia i `onBeforeUnmount`.
W jQuery korzystamy z metody `trigger` do publikowania zdarzenia - `$element.trigger('nazwaZdarzenia', ['arg1', 'arg2']);`

## nextTick i Bootstrap Tooltip

W Vue 3 zmiany w danych nie powodują natychmiastowej aktualizacji DOM.
Problem pojawia się, gdy po zmianie danych (np. po pobraniu danych z API) próbujemy wykonać operacje na DOM, np. zainicjalizować tooltipy.

Jeśli Vue jeszcze nie zdążył wyrenderować elementów, inicjalizacja nie zadziała poprawnie, bo biblioteka nie znajdzie odpowiednich węzłów w DOM.

Rozwiązaniem jest użycie `nextTick()`, które pozwala poczekać, aż Vue zakończy aktualizację DOM po zmianach danych.

[Vue nextTick()](https://vuejs.org/api/general.html#nexttick)

```
import { useFetch } from '@vueuse/core'
import { nextTick } from "vue";
// ....

const fetchData = async () => {
  // ...
  await nextTick();
  TooltipHelper.initTooltips();
};

```

## Renderowanie TR przy użyciu komponentu

W jednym z projektów legacy, w którym stopniowo przechodziliśmy na Vue, tabela z danymi były renderowane po stronie PHP:

```
<table class="table table-striped align-middle">
    <thead>
        <tr>
            <thFirma></th>
            <th>Oddział</th>
            <th>Domyślny</th>
            <th>&nbsp</th>
        </tr>
    </thead>
    <tbody>
        <?php foreach ($rows as $item) : ?>
            // .....
        <?php endforeach; ?>
    </tbody>
</table>
```

W pewnym momencie pojawiła się potrzeba dodania filtrowania wierszy, ponieważ w niektórych przypadkach liczba renderowanych wierszy zbliżała się do 50.
Naturalnym rozwiązaniem wydawało się dodanie komponentu Vue jako kolejnego wiersza tabeli:

```
<table class="table table-striped align-middle">
    <thead>
        <tr>
            <thFirma></th>
            <th>Oddział</th>
            <th>Domyślny</th>
            <th>&nbsp</th>
        </tr>
        <my-filter-row :items='<?= JsonHelper::encodeForView($dataForFilters) ?>'></my-filter-row>
    </thead>
    // ..
```

Niestety komponent nie renderował się wewnątrz tabeli — przeglądarka umieszczała element poza strukturą tabeli.

Problem wynika z tego, w jaki sposób przeglądarka parsuje HTML.
Komponent Vue `<my-filter-row>` jest z punktu widzenia parsera HTML niestandardowym elementem.
Tymczasem niektóre elementy HTML mają określone reguły dotyczące tego, gdzie mogą występować.

Vue opisuje ten problem w dokumentacji w sekcji [Element Placement Restrictions ](https://vuejs.org/guide/essentials/component-basics.html#element-placement-restrictions). To ograniczenie dotyczy in-DOM templates (czyli template'ów, które są parsowane bezpośrednio przez przeglądarkę jako HTML).

Rozwiązaniem jest użycie prawidłowego elementu HTML i wskazanie komponentu Vue za pomocą atrybutu `is`:

```
<table class="table table-striped align-middle">
    <thead>
        <tr>
            <thFirma></th>
            <th>Oddział</th>
            <th>Domyślny</th>
            <th>&nbsp</th>
        </tr>
        <tr is="vue:my-filter-row" :items='<?= JsonHelper::encodeForView($dataForFilters) ?>'></tr>
    </thead>
    // ....
```

[Vuejs doesn't render components inside HTML table elements](https://stackoverflow.com/questions/50759981/vuejs-doesnt-render-components-inside-html-table-elements)
