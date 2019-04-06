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
