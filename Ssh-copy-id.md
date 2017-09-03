Ssh-copy-id
===========

Jeśli możemy zalogować się do zdalnego systemu poprzez protokół SSH wykorzystując swoją nazwę użytkownika i hasło, to możemy do takiego systemy przesłać swój klucz publiczny. Dzięki temu zyskamy możliwość logowania bez podawania hasła (jeśli nasz klucz prywatny nie wymaga podania hasła).

``` bash
ssh-copy-id morawskim@debian.vagrant
```

Po wywołaniu tego polecenia, powinniśmy być wstanie zalogować się do zdalnego systemu bez podawania hasła. Polecenie te kopiuje nasz klucz publiczny i zapisuje go do pliku ~/.ssh/authorized_keys na zdalnym serwerze.