# Google Map

## JS Snippets

### Tworzenie mapy

```
this.map = new google.maps.Map(document.getElementById("map"), {
    center: { lat: 52.4315314, lng: 19.1255951 },
    zoom: 7,
});
```

### Fokus na pineskę

```
this.map.panTo({lat: XX.XXXX, lng: YY.YYYY});
this.map.setZoom(13);
```
