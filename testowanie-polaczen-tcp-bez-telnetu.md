# Testowanie połączeń TCP bez telnet'u

Jeśli chcemy sprawdzić połączenie sieciowe, ale nie mamy zainstalowanego programu telnet to możemy użyć powłoki bash.

``` bash
$ timeout 5 bash -c 'cat < /dev/null > /dev/tcp/www.google.com/8080'; echo $?
124
```

``` bash
$ timeout 5 bash -c 'cat < /dev/null > /dev/tcp/www.google.com/80'; echo $?
0
```
