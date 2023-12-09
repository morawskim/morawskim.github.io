# sed - snippets

## Dopisz linię po dopasowaniu

```
find -iname Vagrantfile -exec sed -i  -e '/"vagrant" => "1",/a\      "operatingsystemrelease" => "15.0",' {} \;
```

### Dodaj wiele linii

Wystarczy w poleceniu umieścić znak nowej linii - "\n": `sed -i'' '/^foo.*/i firstLine\nSecondLine\n' plikDoModyfikacji`

## Wyświetl zawartość elementu HTML

Podczas pracy nad jednym z projektów przestał działać formularz - nie można było go wysłać.
Był to spory formularz. Kod HTML tej strony ważył blisko 3MB. Pobrałem kod HTML i wyciąłem cały element `form` wykorzystując w tym celu polecenie sed. Nie skorzystałem z xpath, czy też z pobierania zawartości elementu (innerHTML). Chciałem uniknąć problemu z ewentualnym naprawianiem złego kodu HTML przez przeglądarkę/parsery XML.

```
sed -n '/<form/,/<\/form>/p' ./view-source_.html > forms.html
```

Nowo utworzony plik `forms.html` otworzyłem w PHPStorm. Tam zauważyłem problem.
Element `form` był zagnieżdżony w innym elemencie `form`. A po naprawieniu tego problemu, zauważyłem, że dwa zamykające znaczniki div nigdy nie były otwierane.
