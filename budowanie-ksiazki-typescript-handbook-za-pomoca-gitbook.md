# Budowanie książki TypeScript Handbook za pomocą gitbook

Do zbudowania książki z plików Markdown potrzebny jest pakiet npm `gitbook`. Prócz niego do zbudowania wersji mobi musiałem zainstalować także pakiet npm `svgexport`.

1. Klonujemy repozytorium `git@github.com:Microsoft/TypeScript-Handbook.git`


2. Tworzymy plik `book.json` w głównym katalogu projektu.
Wklejamy do niego poniższą zawartość:

```
{
    "root": "pages",
    "structure": {
        "summary": "SUMMARY.md"
    }
}
```

Parametr `root` to ścieżka gdzie znajdują się pliki należące do książki.
`structure.summary` to plik z spisem treści.
Szczegółowy opis tych parametrów można znaleźć na stronie https://toolchain.gitbook.com/config.html

3. Kopiujemy plik README.md do katalogu `./pages`

4. Tworzymy plik `pages/SUMMARY`
Do wygenerowania spisu treści Możemy posłużyć się poniższymi poleceniami:

Rozdział "What's new"
```
find -maxdepth 1 -name '*.md' | sort | cut -c3- | rev | cut -c4- | rev | sed -E 's/(.*)/\* \[\1]\(release notes\/\1\.md\)/'
```

Rozdział "Declaration files"

```
find -maxdepth 1 -name '*.md' | sort | cut -c3- | rev | cut -c4- | rev | sed -E 's/(.*)/\* \[\1]\(declaration files\/\1\.md\)/'
```

Musimy jednak ręcznie posortować wpisy.

5. Mając to wszystko możemy urochmić serwer.

```
gitbook serve
```

Otwierając link `http://localhost:4000` w przeglądarce zobaczymy naszą książkę.


## Generowanie pdf
Aby wygenerować książkę w formacie PDF odpalamy poniższe polecenie w głównym katalogu projektu
```
gitbook pdf ./ ./mybook.pdf
```

## Generowanie epub
Aby wygenerować książkę w formacie epub odpalamy poniższe polecenie w głównym katalogu projektu
```
gitbook epub ./ ./mybook.epub
```


## Generowanie mobi
Aby wygenerować książkę w formacie mobi odpalamy poniższe polecenie w głównym katalogu projektu

```
gitbook mobi ./ ./mybook.mobi
```

