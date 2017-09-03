Git force push & pull
=====================

Podczas wysyłania zmian na zdalne repo, w przypadku gdy zmodyfikowaliśmy historię brancha musimy użyć opcji "force".

``` bash
git push origin --force branch_name
```

Na innej maszynie pobieramy kod z gita w następujący sposób:

``` bash
git pull --force
git reset origin/branch_name --hard
```