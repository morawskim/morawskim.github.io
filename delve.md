# Delve

## Nie można odczytać danych z stdin

Delve ma problem z odczytaniem danych ze strumienia stdin - [Unable to read stdin input in debug mode #1274](https://github.com/go-delve/delve/issues/1274).

Poniższy kodu pozwala obejść ten problem.

```
if stdin := os.Getenv("STDIN"); len(stdin) != 0 {
    stdinFile, err := os.Open(stdin)
    if err != nil {
      panic(err)
    }
    os.Stdin = stdinFile
}
````


