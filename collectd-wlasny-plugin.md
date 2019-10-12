# collectd własny plugin do monitorowania

Usługa `collectd` służy do monitorowania parametrów serwera takich jak procesor, pamięć itp.
Prócz pokaźniej listy pluginów (https://collectd.org/wiki/index.php/Table_of_Plugins) możemy tworzyć własne pluginy.

W konfiguracji `/etc/collectd/collectd.conf` dodajemy linię do wczytywania pluginu exec `LoadPlugin exec`.

Następnie definiujemy ustawienia dla pluginu `exec`.

```
<Plugin exec>
  Exec "user:grupa" "/usr/local/bin/custom-collectd-plugin"
</Plugin>
```

Jeśli chcemy przekazać dodatkowe argumenty robimy to po ścieżce do skryptu np. `Exec "user" "/path/to/another/binary" "arg0" "arg1"`.
Więcej informacji na stronie pluginu exec - https://collectd.org/wiki/index.php/Plugin:Exec

Tworzymy plik `/usr/local/bin/custom-collectd-plugin` i nadajemy mu uprawnienia do wykonywania dla wybranego użytkownika.
Nasz skrypt jest prosty, zwraca wielkość katalogu `/tmp` ignorując podkatalogi do których nie mamy dostępu.

```
#!/bin/bash
set -euo pipefail

HOSTNAME="${COLLECTD_HOSTNAME:-$(hostname -f)}"
INTERVAL="${COLLECTD_INTERVAL:-10}"

while sleep "$INTERVAL"; do
    VALUE=$(du -sb /tmp 2> /dev/null | cut -f1)
    echo "PUTVAL $HOSTNAME/own-plugin/gauge-tmp interval=$INTERVAL N:$VALUE"
done
```

`gauge` to typ. Obsługiwane typy przez `collectd` są przechowywane w pliku `/usr/share/collectd/types.db`.

https://collectd.org/wiki/index.php/Naming_schema

https://collectd.org/documentation/manpages/types.db.5.shtml

https://collectd.org/wiki/index.php/Plugin:haproxy-stat.sh


W systemie powinniśmy widzieć nasz działający skrypt, a dane będą zapisywane:
```
> ps -ef | grep custom-collectd
nobody   25755 25734  0 11:42 ?        00:00:00 /bin/bash /usr/local/bin/custom-collectd-plugin
```
