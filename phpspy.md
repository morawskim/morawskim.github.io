# phpspy

[phpspy](https://github.com/adsr/phpspy) to profiler dla PHP 7+.

## Instalacja

W przypadku oficjalnego obrazu kontenera PHP musimy doinstalować pakiet git (`apt-get install git`).
Następnie możemy pobrać kod z repozytorium gita `git clone https://github.com/adsr/phpspy.git`.
I finalnie skompilować program poleceniem `make`.

W przypadku dystrybucji openSUSE Tumbleweed musimy mieć zainstalowane pakiety make, gcc i git.
Kolejne kroki są takie same. Na końcu możemy wywołać polecenie `make install`, aby `phpspy` został zainstalowany w katalogu `/usr/local/bin`.
Warto jednak pamiętać, że obecnie skrypty perl nie są instalowane - [Install flamegraph perl scripts as part of make install #40](https://github.com/adsr/phpspy/pull/40)

## Użycie

Jeśli przy próbie podłączenia się do istniejącego procesu PHP działającego w kontenerze otrzymujemy błąd:

> root@969dfed092c7:/# phpspy -p 1
> awk: cannot open /proc/1/maps (Permission denied)
> popen_read_line: No stdout; cmd=awk -ve=1 '/libphp[78]?/{print $NF; e=0; exit} END{exit e}' /proc/1/maps || readlink /proc/1/exe
> get_php_bin_path: Failed

To w pliku `docker-compose.yml` musimy dodać uprawnienie `SYS_PTRACE`.

```
services:
  php:
    # ...
    cap_add:
        - SYS_PTRACE
```

...

Wywołujemy polecenie `phpspy --pid=1 >traces` aby sprofilować proces PHP o PID równym 1.
Następnie tworzymy wykres `./stackcollapse-phpspy.pl <traces | ./vendor/flamegraph.pl --width 1900 >flame.svg`
i wyświetlamy w przeglądarce np. `google-chrome flame.svg`

Możemy skorzystać z skrótu `CTRL+F`, aby wyszukać interesującą nas klase/metodę.
