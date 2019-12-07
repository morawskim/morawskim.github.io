# Bash snippets

## !$ vs $_

```
echo hello > /dev/null
echo !$
/dev/null
```

```
echo hello > /dev/null
echo $_
hello
```

## Here string

```
cat <<< 'hi there'
hi there
```

## Lista wszystkich sekwencji klawiszy powiązanych z poleceniami powłoki

```
bind -X
"\C-t": "fzf-file-widget"
```

### Pojedynczy cudzysłów w ciągu pojedynczego cudzysłowu

Przy jednym z zadaniu musiałem stworzyć plik js do zakładania nowego konta użytkownika w bazie danych MongoDB.
Skrypt ten wykorzystywany jest w procesie provisioningu.
[config9](https://config9.com/linux/bash/how-to-escape-single-quotes-within-single-quoted-strings/) przedstawia rozwiązanie tego problemu - zastępujemy każdy znak `'` ciągiem `'\''`.
Dodatkowo dostępny jest skrypt perl, który robi to za nas.
Finalnie moje polecenie wyglądało w taki sposób: `docker-compose exec mongodb bash -c 'echo use benchmark > script.js && echo '\''db.createUser({user: "benchmark", pwd: "benchmark", roles: [ { role: "readWrite", db: "benchmark" } ]});'\'' >> script.js'`
