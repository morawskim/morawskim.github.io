# Generowanie sourceMaps dla zewnętrznej biblioteki npm

W projekcie skorzystaliśmy z pakietu `material-table`.
Ta biblioteka miała jednak swoje ograniczenia.
Nie pozwalała nam włączyć funkcji edycji, kasowania i zaznaczania wierszy.

https://stackoverflow.com/questions/58150039/material-table-how-to-do-selectable-and-editable-table

Sprawdziłem jaką mamy zainstalowaną wersję tej biblioteki za pomocą polecenia `npm ls material-table`.
Wiedząc jaką mamy wersję (`1.51.0`) pobrałem z githuba archiwum zip z kodem źródłowym tej wersji - `wget https://github.com/mbrn/material-table/archive/v1.51.0.zip`.
Przy próbie korzystania wariacji polecenia `npm install git://github.com/mbrn/material-table.git#v1.51.0`  nie otrzymywałem kody źródłowego tej biblioteki.

Rozpakowałem archiwum z kodem źródłowym - `unzip v1.51.0.zip`.
I zainstalowałem pakiet za pomocą polecenia `npm i ./material-table-1.51.0/`.
Ta biblioteka ma zdefiniowane `peerDependiencies`, więc podczas instalacji dostałem kilka ostrzeżeń:
```
npm WARN material-table@1.51.0 requires a peer of @material-ui/core@^4.0.1 but none is installed. You must install peer dependencies yourself.
npm WARN @date-io/date-fns@1.3.11 requires a peer of date-fns@2.1.0 but none is installed. You must install peer dependencies yourself.
npm WARN @material-ui/pickers@3.2.6 requires a peer of @material-ui/core@^4.0.0 but none is installed. You must install peer dependencies yourself.
```

Doinstalowałem wymagane pakiety.
`npm` instalując lokalny pakiet tworzy dowiązanie symboliczne. Jest to bardzo wygodne, bo dzięki temu każda zmiana w kodzie jest od razu widoczna.
```
ls -la node_modules/material-table
lrwxrwxrwx 1 marcin marcin 24 10-08 17:18 node_modules/material-table -> ../material-table-1.51.0
```

Przeszedłem do nowego utworzonego katalogu `./material-table-1.51.0/` i wywołałem polecenie `npm i`.
Dzięki temu zainstalowałem wszystkie zależności.
Byłem gotowy do zbudowania biblioteki. W pliku `package.json` istniał wpis w sekcji `scripts` do budowania biblioteki, jednak nie generował on tzw. source maps. Aby babel generował sourcemaps, dodałem parametr `--source-maps both`.

Rozwiązanie nie jest idealne. Po zbudowaniu pakietu `material-design` powinniśmy skasować katalog `node_modules`. W innym przypadku możemy dostać błąd React. Webpack łączy zależności `material-table` z inną wersją React. I ponownie zainstalować wymagane pakiety `npm ci`. To pozwoli uniknąć problemu z niekompatybilnością wersji różnych pakietów npm.