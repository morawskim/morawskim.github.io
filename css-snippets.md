# CSS - snippets

## Tło na całą stronę

``` css
html {
    background: url(./path/to/image.jpg) no-repeat center center fixed;
    background-size: cover;
}
```

## Kolekcja efektów CSS

https://emilkowalski.github.io/css-effects-snippets/

## font-display

Aby zapewnić, że tekst będzie widoczny podczas wczytywania pliku z czcionką korzystamy z deskryptora `font-display`.

``` css
@font-face {
  font-family: ExampleFont;
  src: url(/path/to/fonts/examplefont.woff) format('woff'),
       url(/path/to/fonts/examplefont.eot) format('eot');
  font-weight: 400;
  font-style: normal;
  font-display: fallback;
}
```
https://developer.mozilla.org/en-US/docs/Web/CSS/@font-face/font-display
https://www.zachleat.com/web/google-fonts-display/

## Unikaj 100vh w przeglądarkach mobilnych

[Na blogu David, pojawił się artykuł](https://chanind.github.io/javascript/2019/09/28/avoid-100vh-on-mobile-web.html) o ograniczeniach jednostki `vh` na urządzeniach mobilnych. Przeglądarki mobilne traktują `100vh` jako wysokość ekranu bez paska adresu. David zaleca, korzystanie z JavaScript i ustawienie wysokości na wartość pobraną z `window.innerHeight`.

## Text truncate

https://github.com/twbs/bootstrap/blob/ff29c1224c20b8fcf2d1e7c28426470f1dc3e40d/scss/mixins/_text-truncate.scss#L4

```
// Text truncate
// Requires inline-block or block for proper styling

@mixin text-truncate() {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
```

## Debuging overflow

```
* {
  outline: 1px solid red;
}
```