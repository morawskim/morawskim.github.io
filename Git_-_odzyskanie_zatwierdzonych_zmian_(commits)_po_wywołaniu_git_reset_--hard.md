Git - odzyskanie zatwierdzonych zmian (commits) po wywołaniu git reset --hard
=============================================================================

Jeśli wywołaliśmy polecenie

``` bash
git reset --hard origin/master
```

ale wcześniej zatwierdziliśmy zmiany poprzez git commit, to jesteśmy w stanie odzyskać utracone zmiany. A przynajmniej do momentu kiedy git nie wykona garbage collection.

Wpier wywołujemy polecenie git reflog

``` bash
git reflog
c7c64e5 HEAD@{0}: reset: moving to origin/master
c4c8b13 HEAD@{1}: commit: commit changes after apply patch
8d2a0d3 HEAD@{2}: commit: add php-version script and patch
000a487 HEAD@{3}: commit: add user gem bin dir to PATH env
2b4196e HEAD@{4}: commit: remove system composer's bin dirs (/usr/share/composer/) from PATH env
d551f70 HEAD@{5}: commit: climate autocompletion
0960885 HEAD@{6}: commit: enable enhancd
87838c9 HEAD@{7}: commit: cpu alias
e2e9a77 HEAD@{8}: pull origin master: Fast-forward
cdfa380 HEAD@{9}: commit: zypper search in filelist alias
cd74a8d HEAD@{10}: commit: extract tar.xz file
```

Interesuje mnie zmiana c4c8b13, więc przełączam się do tej wersji.

``` bash
git checkout c4c8b13
Note: checking out 'c4c8b13'.
```

Sprawdzam czy jestem na dobrej rewizji.

``` bash
git log --decorate
commit c4c8b134d62ef19aa20d80f50c87a88e72ce1d86 (HEAD)
Author: Marcin Morawski <marcin@morawskim.pl>
Date:   Sun May 14 11:31:12 2017 +0200

    commit changes after apply patch
```

Następnie generuje plik patch z zmianami, które utraciłem.

``` bash
git format-patch HEAD~2
0001-add-php-version-script-and-patch.patch
0002-commit-changes-after-apply-patch.patch
```

Przechodzę na gałąź master.

``` bash
git checkout master
Warning: you are leaving 2 commits behind, not connected to
any of your branches:

  c4c8b13 commit changes after apply patch
  8d2a0d3 add php-version script and patch
```

Nakładam zmiany.

``` bash
git am 000*patch
Applying: add php-version script and patch
....
```

Sprawdzam czy wszystko jest poprawnie wykonane.

``` bash
git log --oneline
58a528b commit changes after apply patch
69acd2d add php-version script and patch
c7c64e5 alias climate
19e1532 composer bash autocomplete
```