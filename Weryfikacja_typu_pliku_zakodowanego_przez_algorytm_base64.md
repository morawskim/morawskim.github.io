Weryfikacja typu pliku zakodowanego przez algorytm base64
=========================================================

Aby sprawdzić typ pliku zakodowanego przez base64 nie musimy tworzyć pliku tymczasowego. Możemy posłużyć się poniższym polecenim

``` bash
base64 -d ./Projekty/base64Encdode | file  -
/dev/stdin: PDF document, version 1.4
```

Jeśli chcemy wyświetlić mime type pliku do polecenia file dodajemy parametr "-i".

``` bash
base64 -d ./Projekty/base64Encdode | file -i  -
/dev/stdin: application/pdf; charset=unknown
```

Jeśli nasz plik jest wielokrotnie zakodowany przez różne filtry, a polecenie nie obsługuje czytania z stdin, to jako ścieżkę do pliku możemy podać "/dev/stdin"

``` bash
base64 -d ./Projekty/base64Encdode | base64 -d /dev/stdin | file  -
/dev/stdin: PDF document, version 1.4
```