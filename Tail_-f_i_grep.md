Tail -f i grep
==============

Polecenia tail i grep są bardzo często wykorzystywane do analizy logów. Może je ze sobą połączyć w taki sposób, że nowe wpisy do pliku będą filtrowane przez grep'a.

``` bash
tail -f /path/to/file | grep --line-buffered pattern
```