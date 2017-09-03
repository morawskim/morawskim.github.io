Bash - odwołanie do argumentów poprzedniego polecenia
=====================================================

Pracując w powłoce bash możemy odwołać się do argumentów przekazanych w poprzedniej komendzie.

Przykład odwołania do ostatniego parametru.

``` bash
vim a.txt
git add !$
# git add a.txt
```

Przykład odwołania do pierwszego parametru.

``` bash
ls a.txt b.txt
ls -la !:1
# ls -la a.txt
```