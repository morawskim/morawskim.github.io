Git - dodanie tylko zmodyfikowanych plików do poczekalni (staged)
=================================================================

Jeśli w naszym katalogu roboczym mamy zarówno zmodyfikowane pliki jak i nieśledzone tak jak poniżej.

``` bash
git status .
On branch master
Your branch is up-to-date with 'origin/master'.
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   benchmark.pp

Untracked files:
  (use "git add <file>..." to include in what will be committed)

        test.pp
```

To możęmy dodać tylko zmodyfikowane pliki do poczekalni (ang. staged).

``` bash
git add -u .
```

Ponowne wywołanie polecenia git status, potwierdza że tylko zmodyfikowane pliki zostały dodane do poczekalni.

``` bash
git status .
On branch master
Your branch is up-to-date with 'origin/master'.
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        modified:   benchmark.pp

Untracked files:
  (use "git add <file>..." to include in what will be committed)

        test.pp
```