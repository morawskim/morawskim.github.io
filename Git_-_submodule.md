Git - submodule
===============

Jeśli podczas klonowania projektu, nie pobraliśmy modułów zależnych (ang. submodules) to możemy je w dowolnym momencie pobrać wywołując poniższe polecenie:

``` bash
git submodule update --init --recursive
```

Kiedy chcemy zaktualizować moduły zależne to wywołujemy poniższe polecenie:

``` bash
git submodule update --recursive
```