Bash - uruchomienie powłoki bez wczytywania plików profile i bashrc
===================================================================

Wywołując poniższe polecenie uruchomimy powłokę bash, bez wczytywania lokalnych i globalnych plików bashrc i profile.

``` bash
env -i bash --norc --noprofile
```