Git clone wraz z modułami zależnymi
===================================

Domyślnie git nie pobiera modułów zależnych podczas klonowania. Musimy jawnie poinformować git'a, aby je pobrał.

Podczas klonowania musimy dodać dodatkowy parametr "recursive" jak w poniższym przykładzie.

``` bash
git clone --recursive git@github.com:morawskim/puppet_configuration.git
```

W przypadku, kiedy mamy już pobrane repozytorium, moduły zależne można dociągnąć korzystając z polecenia:

``` bash
git submodule update --init --recursive
```