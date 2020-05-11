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

[W edytorze online](https://codepen.io/morawskim/full/YzyrLPX) zbudowałem kartę. Składa się ona z dwóch stron. Po najechaniu na nią myszką karta obróci się i pokaże się tylna część. Na urządzeniach, które nie obsługują efektu "hover" wyświetlany jest dodatkowy przycisk za pomocą media queries.  Do wyśrodkowania elementu w poziomie i w pionie wykorzystałem flexbox. W Internecie jest wiele generatorów flexbox, jak choćby [Flexy Boxes](https://the-echoplex.net/flexyboxes/), czy [Flexbox Generator](https://loading.io/flexbox/). Pozostałe wykorzystane właściwości CSS to `box-decoration-break` i `perspective`.

## Modal dialog (backdrop filter)

Nowa właściwość CSS `backdrop-filter` pozwala nam uzyskać [kilka efektów](https://developer.mozilla.org/en-US/docs/Web/CSS/backdrop-filter). Skorzystałem z efektu rozmycia do zbudowania [okna modalnego](https://codepen.io/morawskim/full/jObxvJr). [Firefox nie obsługuje tej właściwości, jeśli nie włączymy odpowiednich flag w konfiguracji](https://caniuse.com/#feat=css-backdrop-filter). Za pomocą reguły `@supports` [(tzw. at rules)](https://developer.mozilla.org/en-US/docs/Web/CSS/@supports) możemy określić style dla elementu, które zostaną zastosowane jeśli przeglądarka internetowa interpretuje zapis, który podaliśmy w nawiasie. W tym przypadku przeglądarka obsługująca właściwość `backdrop-filter` rozmyje nam tło pod warstwą okna modalnego, a także zwiększy przezroczystość warstwy tła.

## CSS selection

Za pomocą selektor `::selection` ustawiamy style do części dokumentu, który został zaznaczony przez użytkownika. W regule możemy korzystać tylko z określonych właściwości CSS. Są to `color`, `background` i `text-shadow`. Reguła `user-select` umożliwia nam kontrolowanie, czy zawartość danego element możemy zaznaczyć. Elementy `button` domyślnie mają ustawioną tą właściwość na wartość `none` przez co nie możemy zaznaczyć tekstu na tych elementach. Ustawiając tą właściwość na wartość `all` umożliwiamy zaznaczenie całej zawartości tekstowej.

[Demo](https://codepen.io/morawskim/full/WNQXNXx)
