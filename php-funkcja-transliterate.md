PHP - funkcja transliterate
==================

Poniżej funckja PHP, która korzysta z rozszerzenia php-intl w celu przekształcenia tekstu do znaków ASCII.

```
function transliterate($text) {
    return transliterator_transliterate('Any-Latin; Latin-ASCII; [\u0080-\uffff] remove', $text);
}
```
I tak dla tekstu 'Pójdźże, kiń tę chmurność w głąb flaszy' zostanie zwrócony ciąg znaków `Pojdzze, kin te chmurnosc w glab flaszy`.
