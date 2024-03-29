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
Jeśli w trakcie dodawania pliku do poczekalni (staged) otrzymamy komunikat `The following paths are ignored by one of your .gitignore files:` polecenie `git check-ignore` wyświetli dokładnie, która reguła z którego pliku `.gitignore` blokuje dodanie pliku do repozytorium.

```
> git check-ignore -v ./opensuse-15.0/yadm/rpmbuild.log
opensuse-15.0/yadm/.gitignore:3:rpmbuild.log ./opensuse-15.0/yadm/rpmbuild.log

> git check-ignore  -v ./nexus.pp
puppet/modules/.gitignore:1:*   ./nexus.pp
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

## Branche, które jeszcze nie zostały scalone

```
git branch --no-merged release-5.9.0
* feature-GOLL-2409
  feature-GOLL-1778
  feature-GOLL-1782
  feature-GOLL-2031
  feature-GOLL-2032
  feature-GOLL-2045
  feature-GOLL-2253
```

## Najnowszy wspólny przodek dwóch gałęzi Git
```
git merge-base branch2 branch3
050dc022f3a65bdc78d97e2b1ac9b595a924c3f2
```

## Przeniesienie brancha na nowy komit
```
git branch -f branch-name commit-sha
```

## Generowanie wersji paczki

Przykład
```
git describe
v0.1.1-45-gee6039a
```

Jeśli nigdy nie korzystalismy z tagowania, to musimy użyć flagi `--always`.
Wynik jednak będzie zawierał, tylko skrót hasza komita.
```
git describe —always
```

Przykład
```
git describe --always
b369748
```

## Częściowe cofnięcie poprzedniego komita
```
git show <commit> -- <path> | git apply -R
```

## Przed złączeniem zmian z innej gałęzi, chce je przejrzeć

```
git merge [nazwa-brancha] --no-commit --no-ff
```

Tym poleceniem próbujemy połączyć zmiany z gałęzi `nazwa-brancha`, ale nie zostanie utworzony żaden merge commit. Daje nam to możliwość przejrzenia jak będzie wyglądał kod po złączeniu. Po przejrzeniu kodu możemy normalnie zatwierdzić zmiany.

## Adnotacje (git blame) do poprzedniej wersji pliku

Modyfikując plik, środowiska programistyczne przestają wyświetlać kto i kiedy ostatni raz modyfikował daną linię.
Te informację mogą się przydać przy opisie błędu. Możemy je wyświetlić nie cofając się do poprzedniej wersji pliku za pomocą poniższego polecenia.

```
git blame HEAD^ -- /sciezka/do/pliku
```

## Przygotowanie archiwum z wydaniem

```
git archive master --prefix='PROJEKT/' | gzip > `git describe master`.tar.gz
```

## fetch i cherry-pick na aktualny branch

`git fetch gerrit refs/changes/25/20625/9 && git cherry-pick FETCH_HEAD`


## Lista plików, których nazwa zaczyna się od 'Dockerfile'

`git ls-files --exclude='Dockerfile*' --ignored | xargs --max-lines=1  echo`

## Wczytywanie warunkowo pliku konfiguracyjnego git'a na podstawie ścieżki repozytorium

```
[includeIf "gitdir:~/projects/client1/"]
    path = ~/.gitconfig-client1
```
