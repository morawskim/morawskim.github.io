# opensuse leap 42.2 - docker i suse firewall

W opensuse leap 42.2 po uruchomieniu komputera wszystkie odpalone kontenery nie mają dostępu do sieci.
Należy zresetować usługę docker. Po tym kontenery będą mieć dostęp do sieci.
Aby na stałe rozwiązać ten problem musimy edytować plik jednostki `docker.service`. 
I dodać, aby usługa `docker.service` uruchamiała się po usłudze `SuSEfirewall2.service`.
Jak to jest zrobione w opensuse leap 42.3.

Opensuse leap 42.2 - docker.service
```
..
After=network.target containerd.socket containerd.service
Requires=containerd.socket containerd.service
...
```

Opensuse leap 42.3 - docker.service
```
...
After=network.target containerd.socket containerd.service lvm2-monitor.service SuSEfirewall2.service
Requires=containerd.socket containerd.service
...
```
