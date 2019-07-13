# Bash - jak określić plik gdzie zdefiniowano funkcję

``` bash
$ shopt -s extdebug
$ declare -F quote
quote 169 /home/marcin/.profile.d/functions.bash
```

``` bash
$ bash --debugger
$ declare -F quote
quote 169 /home/marcin/.profile.d/functions.bash
```
