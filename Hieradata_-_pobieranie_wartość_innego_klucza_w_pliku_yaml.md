Hieradata - pobieranie wartość innego klucza w pliku yaml
=========================================================

Zawartość pliku yaml

```
---
mysql::client::package_name: 'mariadb-tools'
test: "%{hiera('mysql::client::package_name')}"
```

Polecenie do pobrania wartości klucza test z pliku yaml

``` bash
hiera -c /tmp/vagrant-puppet/hiera.yaml test
mariadb-tools
```