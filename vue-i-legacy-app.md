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
