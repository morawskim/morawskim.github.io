Git - usunięcie pliku z kontroli gita
=====================================

Przez pomyłkę można dodać do gita zbędne pliki. Choćby plik z logiem. Zawsze taki plik można skasować z systemu kontroli wersji. Wystarczy wydać poniższe polecenie. Po jego wywołaniu należy dodać plik do .gitignore, aby przypadkiem znów go nie dodać do gita.

``` bash
git rm --cached log/application.log
```