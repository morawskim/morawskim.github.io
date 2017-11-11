Sed - skasowanie tekstu pomiędzy dwoma frazami
==============================================

Za pomocą programu sed, możemy usunąć z pliku tekst pomiędzy dwoma frazami.

``` bash
sed -i '/zypper_update/,/}/d' *.pp
```

Powyższe polecenie skasuje taki tekst z plików pp

```
-    exec { 'zypper_update':
-        command => '/usr/bin/zypper --non-interactive --no-color update',
-        require => Class['mopensuse::zypper::refresh']
-    }
```
