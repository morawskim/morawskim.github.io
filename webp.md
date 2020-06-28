# webp

`webp` to nowoczesny otwarty format obrazów. Jest konkurentem dla starszego formatu jpeg. Obecnie obsługiwany jest przez [niecałe 80% użytkowników](https://caniuse.com/#feat=webp). Aby obsłużyć pozostałych użytkowników, musimy  serwować obrazki także w formacie png/jpeg.

Korzystając z elementu `picture`, możemy obsłużyć wiele różnych formatów obrazków. [Obecnie jest on dobrze wspierany przez przeglądarki.](https://caniuse.com/#feat=picture) Wykorzystując elementy podrzędne `source` jesteśmy w stanie kontrolować, z którego zasobu pobrać obrazek w oparciu o rozdzielczość, media queries lub  wsparcie dla określonego formatu obrazu. Na stronie [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/picture) mamy opisane zasady działania i przykłady.

```
<picture>
    <source srcset="/assets/img/logo@2x.webp" type="image/webp" />
    <source srcset="/assets/img/logo@2x.png" type="image/png" />
    <img src="/assets/img/logo@2x.png" alt="COMPANY NAME" width="190"/>
</picture>
```

W przypadku odwołania się do obrazków w arkuszach CSS, mamy większy problem. CSS nie posiada wbudowanej możliwości wykrycia obsługiwanych formatów obrazów. Musimy skorzystać z biblioteki js [Modernizr](https://modernizr.com/). Jej zadaniem jest wykrywanie dostępności funkcji HTML5 i CSS3 w przeglądarkach. Ustawia ona odpowiednie klasy CSS na elemencie `html`, które informują nas, czy dana funkcja jest obsługiwana czy nie. W przypadku wsparcia dla formatu `webp` będzie to ustawienie klas CSS ` webp webp-alpha webp-animation webp-lossless`.

W SCSS tworzymy domieszkę (ang. mixin) `webp-supported`.
```
@mixin webp-supported {
  .webp & {
    @content;
  }
}
```

Następnie w selektorach, gdzie korzystano z obrazków dodawałem domieszkę np.
```
@include webp-supported {
  background-image: url('../img/footer.webp');
}
```

## Konwersja

Do konwersji obrazków z formatu png/jpeg do webp możemy wykorzystać narzędzie `cwebp`. Aby przekonwertować wiele obrazów na raz, możemy skorzystać z poniższego skryptu dla powłoki Bash -`for file in *; do cwebp "$file" -q 80 -o "${file%.*}.webp"; done`

W PHP wykorzystując bibliotekę `rosell-dk/webp-convert` możemy przekonwertować obrazek do formatu webp.

Chcąc korzystać z rozszerzenia PHP `GD` musimy się upewnić, czy posiada wsparcie dla formatu `webp`.

``` php
var_dump(function_exists('imagewebp'));
// bool(false) false === brak wsparcia dla webp
```

Możemy też skorzystać z funkcji `gd_info`.
``` php
var_dump(gd_info());
array(13) {
  ["GD Version"]=>
  string(26) "bundled (2.1.0 compatible)"
  ["FreeType Support"]=>
  bool(true)
  ["FreeType Linkage"]=>
  string(13) "with freetype"
  ["T1Lib Support"]=>
  bool(true)
  ["GIF Read Support"]=>
  bool(true)
  ["GIF Create Support"]=>
  bool(true)
  ["JPEG Support"]=>
  bool(true)
  ["PNG Support"]=>
  bool(true)
  ["WBMP Support"]=>
  bool(true)
  ["XPM Support"]=>
  bool(true)
  ["XBM Support"]=>
  bool(true)
  ["WebP Support"]=>
  bool(false)
  ["JIS-mapped Japanese Font Support"]=>
  bool(false)
}
```
