# PHP - DateTime::createFromFormat i microtime

W projekcie mieliśmy taki kod:
``` php
$now = DateTime::createFromFormat('U.u', microtime());
$now->format('Y-m-d H:i:s.u');
```

Po pewnym czasie dostaliśmy błąd że nie można wywołać metody `format`, bo zmienna `$now` nie jest objektem.
Mogło to się zdarzyć w przypadku, gdy podano nie poprawną datę. Jak się okazało (http://php.net/manual/en/datetime.createfromformat.php#119362) funkcja `microtime` może zwrócić liczbę bez części ułamkowej.

Powiniśmy korzystać z poniższego kodu:
``` php
$now = DateTime::createFromFormat('U.u', number_format(microtime(true), 6, '.', ''));
var_dump($now->format('Y-m-d H:i:s.u'));
```

