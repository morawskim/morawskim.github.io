Hieradata - wartość nil
=======================

Zawartość pliku yaml

```
---
test_nil: ~
```

Polecenie do pobrania wartości klucza test_nil

``` bash
hiera  -c `pwd`/hiera.yaml test_nil
nil
```