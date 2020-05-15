# webpack4 - css modules

Style CSS są globalne. Dodając wiele arkuszy styli możemy doprowadzić do konfliktów między nazwami klas CSS. W efekcie nasza aplikacja nie będzie wyglądać tak jak chcemy. Dzięki `css modules` możemy zapomnieć o konfliktach nazw klas CSS.

Dzięki `css modules` możemy stylować nasze komponenty React czy Angular nie powodując efektów ubocznych.
W pliku js dołączamy plik css - `import styles from './styles';`.
Dzięki temu zmienna `styles` przechowuje obiekt (mapę powiązań), gdzie klucz to nazwa klasy CSS, a wartość to wygenerowana automatycznie nowa nazwa klasy CSS. Dzięki temu możemy przypisać unikalną klasę CSS naszemu komponentowi.
Prosty przykład:
```
document.getElementById('bar').innerHTML =
  `<h1 class="${styles.title}">
     Bar element with CSS class title
   </h1>`;
```

## Style globalne i modułowe
Aby w projekcie korzystać z styli globalnych i modułowych musimy w konfiguracji `webpack` dodać dwa loadery css.
Jeden loader z parametrem konfiguracyjnym `modules`, będzie przetwarzał pliki `*.css` tylko z katalogu `src/js`.
Drugi nie generujący modułowych css sprawdza tylko katalog `src/css`. Możemy zastosować inny algorytm, ale ten się sprawdza.

[Przykładowa konfiguracja webpack i css-loader](https://github.com/morawskim/html5-examples/tree/master/webpack/css-loader)

[css-loader](https://github.com/webpack-contrib/css-loader)

[What are CSS Modules and why do we need them?](https://css-tricks.com/css-modules-part-1-need/)
