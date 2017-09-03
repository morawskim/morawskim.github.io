Kopiowanie repozytorium SVN
===========================

Jeśli chcemy przekopiować na serwer pliki bez plików VCS możemy użyć poniższego polecenia

``` bash
rsync --exclude=.svn/ -v -r /sciezka/do/repo/ /gdzie/zapisac/
```

Możemy też zastosować opcję -C, która automatycznie ignoruje pliki VCS (SVN, GIT, CVS).

Inne ciekawe opcje rsync:

```
--dry-run przebieg próbny. Wyświetla tylko pliki, które zostaną skopiowane.

-P --progress --partial  The first of these gives you a progress bar for the transfers and the second allows you to resume interrupted transfers

-z compress

-C, --cvs-exclude auto-ignore files in the same way CVS does

-a archive  It stands for "archive" and syncs recursively and preserves symbolic links, special and device files, modification times, group, owner, and permissions.

--exclude=".svn,.git"
```