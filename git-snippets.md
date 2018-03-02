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
