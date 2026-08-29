# vue3-google-map

## InfoWindow i outside click

W ramach jednego z projektów dodawaliśmy mapę Google Maps, wykorzystując do tego bibliotekę `vue3-google-map`.

Projekt był w dużej mierze wykorzystywany na urządzeniach mobilnych, które nie obsługują zdarzeń związanych z najechaniem kursorem, takich jak `mouseover` czy `mouseout`.
Z tego względu zdecydowałem się wykorzystać funkcję `onClickOutside` z pakietu `@vueuse/core`.

Dzięki temu kliknięcie poza komponentem `InfoWindow` powoduje jego automatyczne zamknięcie.
Rozwiązanie to pozwoliło uzyskać zachowanie zbliżone do tego, które mieliśmy w panelu administracyjnym, gdzie ze względu na charakter projektu mogliśmy wykorzystać zdarzenia `mouseover` i `mouseout`.

Komponent `InfoWindowMapOutsideClick`:

```
<script setup lang="ts">
import { ref } from 'vue'
import { InfoWindow } from 'vue3-google-map'
import { onClickOutside } from '@vueuse/core'
import { useTemplateRef } from 'vue'

const target = useTemplateRef('target');
const infoWindowRef = ref<InstanceType<typeof InfoWindow>|null>(null)
const emit = defineEmits(['close']);

onClickOutside(target, event => {
  //infoWindowRef.value?.infoWindow?.close();
  emit('close');
}, {ignore: ['gmp-advanced-marker']});

</script>

<template>
  <InfoWindow v-bind="$attrs" ref="infoWindowRef">
    <div ref="target">
      <slot></slot>
    </div>
  </InfoWindow>
</template>

<style scoped>

</style>

```

Przykład użycia tego komponentu:

```
<AdvancedMarker v-for="(options, index) in fooMarkers"
  :key="options.key"
  :options="options.marker"
  @click="options.openInfoWindow = !options.openInfoWindow"
>
  <template #content>
    <CustomMarker :custom-marker="options.customMarker" />
  </template>
  <InfoWindowMapOutsideClick :model-value="options.openInfoWindow" @close="options.openInfoWindow = false">
    <InfoWindowFooCollection :items="options.componentProps.items" />
  </InfoWindowMapOutsideClick>
</AdvancedMarker>
```
