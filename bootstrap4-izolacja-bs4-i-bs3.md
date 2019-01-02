# Bootstrap4 - izolacja Bs4 i Bs3

W jednym z projektów, był wykorzystywany Bootstrap w wersji 3.x. Chcieliśmy skorzystać z komponentu card Bootstrapa4.
Aby różne wersje Boostrapa się nie gryzły, to postanowiłem ręcznie zbudować CSS dla bs4. Moja wersja dodaje selektor `.bs4` do każdej reguły Bootstrapa4. Dzięki temu, jeśli chce skorzystać z styli Bootstrapa4 to wystarczy, że w elemencie nadrzędnym dodam klasę CSS `bs4`.

Przechodzimy do nowego katalogu.

Instalujemy niezbędne pakiety npm. `yarn add bootstrap@4.2.1 node-sass@4.11.0`

Następnie tworzymy plik `bs4.scss`. I wklejamy do niego zawartość:
```
.bs4 {
    @import 'node_modules/bootstrap/scss/bootstrap';
}
```

Możemy teraz zbudować nasz plik CSS `./node_modules/.bin/node-sass --output-style expanded --precision 6 bs4.scss dist/css/bs4.css`

Po zbudowaniu powstanie katalog `dist/css` i w nim znajduje się plik `bs4.css`.

Następnie zastępujemy wszystkie wystąpienia selektora `.bs4 html` wywołując komendę `sed -i -e 's/.bs4 html/.bs4/g' ./dist/css/bs4.css`

Musimy także zastąpić selektor `.bs4 body` - `sed -i -e 's/.bs4 body/.bs4/g' ./dist/css/bs4.css`

Mamy gotowy plik CSS, który możemy podać procesowi minimalizacji/kompresji.
