# journalctl, rsyslog i openSuSE 15

Przy próbie wywołania polecenia `sudo journalctl -b 1` w systemie openSuSE 15 otrzymałem poniższy błąd:

```
Specifying boot ID or boot offset has no effect, no persistent journal was found.
```

Sprawdziłem w konfiguracji `/etc/systemd/journald.conf` jaka journal przechowuje logi.

```
[Journal]
#Storage=auto
```

Wartość `auto` oznacza, że jeśli katalog `/var/log/journal` istnieje to journal będzie zapisywać dane na dysku. W przeciwnym przypadku dane przepadną po restarcie maszyny.
Katalog ten powinien mieć także ustawioną grupę `systemd-journal`.

Postanowiłem zainstalować pakiet `systemd-logger`. Wcześniej jednak usunąłem rsyslog. Pakiet ten zawiera potrzebny katalog.

```
rpm -ql systemd-logger 
/var/log/README
/var/log/journal
```
