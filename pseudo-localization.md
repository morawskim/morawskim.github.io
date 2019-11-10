# pseudo-localization

> pseudo-localization to metoda testowania oprogramowania używana do testowania aspektów internacjonalizacji oprogramowania. Zamiast tłumaczyć tekst oprogramowania na język obcy, tak jak w procesie lokalizacji, elementy tekstowe aplikacji są zastępowane zmienioną wersją oryginalnego języka.
Wikipedia https://en.wikipedia.org/wiki/Pseudolocalization

[Nordic.js 2019 • Isabela Moreira - Localization: Implementation and Testing... Locally](https://www.youtube.com/watch?v=mh_Ck6Snoyw&list=PLGP3VO5jDf8x0gh5H7dZ41F0nVDlwDMuy&index=6)

[Biblioteka JS](https://www.npmjs.com/package/pseudo-localization)

[Biblioteka PHP](https://github.com/yoannrenard/pseudolocalization)


## react-intl

Instalujemy pakiet npm `react-intl-universal-pseudo-converter`.
Ten pakiet integruje się z `react-intl`. Klucze naszych komunikatów pozostają bez żadnej modyfikacji.
Zachowane są także wszystkie parametry i formaty tłumaczeń. Jeśli w tłumaczeniu korzystamy z formatowania HTML, to znaczniki HTML zostają zignorowane. Tłumaczone jest tylko zawartość.
Pakiet `pseudo-localization` tego nie potrafi.

Następnie wywołujemy polecenie `./node_modules/.bin/react-intl-universal-pseudo-converter create -f /sciezka/do/pliku/z/tlumaczeniem/pl.json -o pseudo.locale.json`.

Przykład nowo utworzonego pliku `pseudo.locale.json`

``` javascript
{
  "Decrement": "δèçřè₥èñƭ",
  "Increment": "ïñçřè₥èñƭ",
  "Country": "Çôúñƭř¥",
  "City": "Çïƭ¥",
  "Users": "Ûƨèřƨ",
  "sm.analytics.performance": "§hôƥƥïñϱ ₥áℓℓ řáñƙïñϱ ïñ {country}",
  "All-visits": "Âℓℓ<br>Ʋïƨïƭƨ"
}
```
