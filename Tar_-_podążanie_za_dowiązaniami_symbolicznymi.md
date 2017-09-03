Tar - podążanie za dowiązaniami symbolicznymi
=============================================

Jeśli chcemy utworzyć archiwum tar.gz, które zawiera także pliki wskazywane przez dowiazania symboliczne, to musimy dodać parametr "-h" lub "−−dereference".

```
−h, −−dereference

podąża za dowiązaniami symbolicznymi; archiwizuje pliki, na które one wskazują
```

Przykład

``` bash
tar -vzchf file.tar.gz ./DIR
```