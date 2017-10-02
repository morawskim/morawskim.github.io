Wizualizacja zależności rpm z Graphviz
======================================

``` bash
rpmdep -dot vim.dot vim
dot -Tpng vim.dot -o vim.png
```
