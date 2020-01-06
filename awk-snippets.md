# awk - snippets

## filtrowanie linii

Program awk może posłużyć do filtrowania linii w pliku.
Aby wyświetlić linie, które w ostatniej kolumnie mają wartość większą od 0.1 korzystamy z polecenia:

```
awk '$(NF) >= 0.1 {print ;}' PLIK
```

Aby użyć przedostatniej kolumny to podajemy `$(NF-1)`.
Możemy też wybrać pierwszą kolumnę `$1`.


## suma

```
cat plik | awk '{s+=$1} END {print s}'
13259
```
