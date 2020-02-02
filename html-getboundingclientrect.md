#HTML - getBoundingClientRect

Za pomocą biblioteki jQuery mogliśmy pobrać przesunięcie elementu (ang. offset) względem początku strony.
W kodzie źródłowym jQuery możemy znaleźć metodę `offset` -
https://github.com/jquery/jquery/blob/d0ce00cdfa680f1f0c38460bc51ea14079ae8b07/src/offset.js#L91

Wcześniej potrzebna była pętla przez elementy DOM do korzenia i sumowanie wartości offsetTop każdego elementu. Ta metoda miała swoje ograniczenia (nie brała pod uwagę np. przekształceń CSS).
Obecnie do tego celu wykorzystuje się metodę getBoundingClientRect - https://caniuse.com/#feat=getboundingclientrect

Metoda `getBoundingClientRect` elementu DOM zwraca pozycję względem viewport, a nie dokumentu. Musimy więc dodać przesunięcie do wyniku.

```
function getElementOffset(el) {
  const rect = el.getBoundingClientRect();

  return {
    top: rect.top +  (window.pageYOffset || document.documentElement.scrollTop),
    left: rect.left + (window.pageXOffset || document.documentElement.scrollLeft),
  };
}
```

Istnieje także hook dla biblioteki React - https://github.com/tranbathanhtung/usePosition/blob/master/index.js
