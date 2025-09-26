# Vue

## Dynamiczne komponenty

W projekcie zintegrowanym z Google Maps dodawane były pinezki (ang. markers).
Pinezka posiadała własne okno informacyjne (info window), które służy do wyświetlania szczegółowych informacji po kliknięciu w pinezkę.

W zależności od typu pinezki, do wyświetlenia zawartości info window używany był inny komponent Vue. Pozwalało to na dostosowanie wyglądu do konkretnego typu obiektu.

Najpierw importujemy odpowiednie komponenty.
Przy każdej pinezce w strukturze danych zapisujemy referencję do komponentu, który ma zostać użyty w info window.
W miejscu, gdzie renderujemy zawartość info window, korzystamy z komponentu`<component>` z ustawionym atrybutem `:is` oraz przekazujemy dane przez `v-bind`:

```
<script setup lang="ts">
// ...
import InfoWindowSupplier from "./InfoWindowSupplier.vue";
// ...
const createSupplierMarkers = (data: Array<SupplierMarkerData>) => {
  const markers = [] as Array<{marker: {}, infoWindow: any, componentProps: {}}>;
  // ...
  data.forEach(item => {
    markers.push({
      marker: {
        position: {lat: item.lat, lng: item.lng},
        // ...
      },
      infoWindow: InfoWindowSupplier,
      componentProps: {
        data: item,
      },
    })
  });

  return markers;
};
</script>

<template>
  <GoogleMap
       ....
      :zoom="8"
      ref="mapRef"
  >
    <Marker v-for="(item, index) in supplierMarkers"
            :key="index"
            :options="item.marker"
    >
      <InfoWindow>
        <component :is="item.infoWindow" v-bind="item.componentProps" />
      </InfoWindow>
    </Marker>
  </GoogleMap>
</template>

<style scoped>

</style>

```
