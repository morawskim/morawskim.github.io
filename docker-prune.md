# docker prune

Polecenie `docker image prune` pozwala nam skasować nieużywane obrazy. Domyślnie kasowane są tylko obrazy, które nie mają przypisanego tagu i nie są wykorzystywane przez żaden kontener.


```
❯ docker image prune
WARNING! This will remove all dangling images.
Are you sure you want to continue? [y/N] Y
Deleted Images:
deleted: sha256:09db1b62b3f5f2687e0de286f1e5c8eb8dd1915badf4caf734e4690969f9c3a8
deleted: sha256:62f809df0adf8b62fa00b38d609f283fa55925a22cb1dd26945d5f713675f398
.......

Total reclaimed space: 1.143GB
```


Prócz kasowania obrazów, możemy także skasować sieci `network prune`, kontenery `container prune` czy tez wolumeny `volume prune` - [https://docs.docker.com/config/pruning/](https://docs.docker.com/config/pruning/).