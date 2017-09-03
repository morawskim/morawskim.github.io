Bash - pipe
===========

Podczas tworzenia potoków korzystamy z znaku '|'. Jednak istnieje też inny symbol. Jest to |&. Jeśli użyjemy '|&' to wyjścia stderr i stdout zostaną przekazane do drugiego polecenia. Jest to skrócony zapis

``` bash
command1 2>&1 | command2
```

Więcej informacji [<https://www.gnu.org/software/bash/manual/bash.html#Pipelines-1>](/https://www.gnu.org/software/bash/manual/bash.html#Pipelines-1 "wikilink")