# Select2 - zbudowanie własnej wersji

W jednym z projektów korzystaliśmy z biblioteki [Select2](https://select2.org/).
Potrzebowaliśmy przefiltrować opcje listy rozwijanej na podstawie przedziału dat (od–do), zamiast używać standardowego pola tekstowego do wyszukiwania.

Niestety, biblioteka Select2 nie umożliwia nadpisania domyślnego szablonu filtrowania opcji – [odpowiedzialny za to fragment](https://github.com/select2/select2/blob/595494a72fee67b0a61c64701cbb72e3121f97b9/src/js/select2/dropdown/search.js#L10) jest zakodowany na stałe.

Aby dostosować działanie filtrowania do naszych potrzeb, zdecydowałem się na modyfikację źródeł biblioteki i samodzielne jej zbudowanie.

Tworzymy plik `docker-compose.yml`:

```
services:
  nodejs:
    image: node:14.0
    working_dir: /home/node/app
    volumes:
        - ./:/home/node/app
    tty: true
    command: "bash"
```

Następnie klonujemy repozytorium Select2 i przełączamy się na odpowiednią wersję:

```
git clone https://github.com/select2/select2.git
cd select2
git checkout -b ver 4.0.13
```

Nanosimy swoje zmiany w kodzie źródłowym, pamiętając o zmianie nazwy pluginu jQuery, aby uniknąć konfliktów z innymi wersjami Select2 w projekcie.
Wracamy do katalogu wyżej - `cd ..`

Uruchamiamy kontener
```
docker compose up -d
docker compose exec nodejs bash
```

W kontenerze:
```
cd select2 && npm ci && npx grunt compile minify
```

Po zakończeniu budowania, zmodyfikowane pliki Select2 będą dostępne w katalogu `dist/`.
Można je skopiować i dołączyć do projektu jako niestandardową wersję biblioteki.
