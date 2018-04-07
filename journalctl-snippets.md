# journalctl - snippets

## Pokaż wszystkie wiadomości dla określonego pliku wykonywalnego
```
journalctl /usr/sbin/mysqld
```

## Pokaż wiadomości dla określonej jednostki użytkownika
```
journalctl _SYSTEMD_USER_UNIT=offlineimap-oneshot.service
```
