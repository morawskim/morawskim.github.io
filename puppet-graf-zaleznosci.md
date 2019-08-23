# Puppet - graf zależności

Puppet umożliwia wygenerowanie pliku `.dot`, który będzie zawierać powiązania zasobów dla manifestu.

``` bash
puppet apply /sciezka/do/manifestu.pp --noop --graph
```

Puppet powinien wygenerowany plik zapisać w katalogu `/var/lib/puppet/state/graphs/`
Możemy także zmienić katalog dodając parametr ` --graphdir=<sciezka>`.

Plik `dot` możemy przekształcić do pliku png.
``` bash
dot -Tpng /var/lib/puppet/state/graphs/relationships.dot -o $HOME/relationships.png
```
