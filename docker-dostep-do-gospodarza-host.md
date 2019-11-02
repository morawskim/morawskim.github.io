# docker - dostęp do gospodarza (host)

W niektórych systemach operacyjnych docker obsługuje specjalną nazwę domeny `host.docker.internal`, która wskazuje na maszynę gospodarza. Jednak docker for linux nie obsługuje tej funkcji - https://github.com/docker/for-linux/issues/264

W wątku tym pojawiło się wiele rozwiązań tego problemu.
Najlepszym rozwiązaniem jest użycie adresu IP `172.17.0.1`, ponieważ nie wymaga żadnej konfiguracji. Przez ten adres możemy połączyć się z maszyną gospodarza.

Adres `172.17.0.1` jest przypisany do interfejsu `docker0`. Można to sprawdzić wywołując polecenie `ip a s docker0`.

```
5: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 02:42:9b:34:7f:82 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever

```
