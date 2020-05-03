# Nowoczesny CSS

## clip-path, animation, transform, background-size

[W przykładzie](https://codepen.io/morawskim/full/WNQjXpz) skorzystałem z kilku nowych funkcji CSS.

Za pomocą właściwości `clip-path` możemy określić kształt, do którego zostanie przycięty interesujący nas element HTML.
Wykorzystałem tą właściwość do przycięcia tła. Istnieje generator `clip-path` [Clippy](https://bennettfeely.com/clippy/), który pozwala nam skopiować gotowy kod kształtów lub tworzyć nowe.

Za pomocą słowa kluczowego `@keyframes` i właściwości `animation` tworzymy animacje z poziomu CSS. `@keyframes` umożliwia precyzyjną kontrolę nad przebiegiem animacji w porównaniu do `transition`.

`Transform` umożliwia dokonywanie przekształceń elementu takich jak przesunięcie, obrót, skalowanie, pochylenie.

## background-clip, linear-gradient, text-shadow, outline, scale

[W edytorze online](https://codepen.io/morawskim/full/eYpGVGZ) zbudowałem efekt powiększenia zdjęć po najechaniu. Dodatkowo korzystając z właściwości [background-clip](https://developer.mozilla.org/en-US/docs/Web/CSS/background-clip) stworzyłem efekt gradientu w nagłówku.

## Karta

[W edytorze online](https://codepen.io/morawskim/full/YzyrLPX) zbudowałem kartę. Składa się ona z dwóch stron. Po najechaniu na nią myszką karta obróci się i pokaże się tylna część. Do wyśrodkowania elementu w poziomie i w pionie wykorzystałem flexbox. W Internecie jest wiele generatorów flexbox, jak choćby [Flexy Boxes](https://the-echoplex.net/flexyboxes/), czy [Flexbox Generator](https://loading.io/flexbox/). Pozostałe wykorzystane właściwości CSS to `box-decoration-break` i `perspective`.
