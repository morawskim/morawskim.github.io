# git - snippets

## Różnica między gałęziami

Lista komitów które są dostępne z gałęzi `feature-GOLL-2032` i `feature-GOLL-2253`, ale nie z obu.

```
git log --format='format:%m %h %ae %s' --left-right feature-GOLL-2032...feature-GOLL-2253
..
< 1417ec188 marcin.morawski@sensilabs.pl Merge branch 'feature-GOLL-2253' into feature-GOLL-2032
< 104e91e7b marcin.morawski@sensilabs.pl GOLL-2032 Wyl. blokady wysylania formularza umowy
...
````

## check-ignore
Polecenie check-ignore informuje nas, która reguła w pliku gitignore powoduje, że dany plik jest ignorowany.

```
git check-ignore -v ./opensuse-15.0/yadm/rpmbuild.log
opensuse-15.0/yadm/.gitignore:3:rpmbuild.log ./opensuse-15.0/yadm/rpmbuild.log
```

To polecenie analizuje też reguły z globalnego pliku .gitignore

```
git check-ignore -v .directory
/home/marcin/.config/git/ignore:3:.directory .directory

```

## .git/info/exclude
Reguły ignorowania plików przez gita umieszcza się w pliku `.gitignore`. Nie jest to jednak jedyny sposób.
Możemy to także zrobić globalnie (core.excludesfile). Prócz tego możemy dodać reguły tylko dla lokalnej kopii repozytorium.
Takie reguły dodaje się właśnie do pliku `.git/info/exclude`.


## Ignoruj zmienione pliki tylko na lokalnej maszynie

```
git update-index --skip-worktree <file>
```

Aby przestać ignorować zmiany:
```
git update-index --no-skip-worktree <file>
```

Więcej informacji
 * https://medium.com/@igloude/git-skip-worktree-and-how-i-used-to-hate-config-files-e84a44a8c859
 * https://hashrocket.com/blog/posts/ignore-specific-file-changes-only-on-current-machine-in-git
 * https://fallengamer.livejournal.com/93321.html
 * http://ideasintosoftware.com/git-tips-ignore-changes-to-a-local-file/

