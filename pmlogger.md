# pmlogger

W logach systemowych (journalctl) pojawiały się liczne wpisy związane z próbami uruchomienia usługi `pmlogger.service`:

```
maj 06 20:06:09 XXXXXXXXX systemd[1]: Failed to start Performance Metrics Archive Logger.
maj 06 20:06:09 XXXXXXXXX systemd[1]: pmlogger.service: Scheduled restart job, restart counter is at 58703.
maj 06 20:06:09 XXXXXXXXX systemd[1]: Stopped Performance Metrics Archive Logger.
maj 06 20:06:09 XXXXXXXXX systemd[1]: Starting Performance Metrics Archive Logger...
```

Wyświetlenie rozszerzonych logów systemd dla tej usługi za pomocą polecenia `journalctl -u pmlogger.service -xe` zwracało m.in. komunikat:

> pmlogger.service: Failed with result 'protocol'.

Usługa pmlogger zależy od działania pmcd.
Po sprawdzeniu statusu poleceniem `systemctl status pmcd`, okazało się, że usługa pmcd nie była uruchomiona.
Po jej włączeniu poleceniem `systemctl enable --now pmcd` błędy związane z `pmlogger.service` przestały się pojawiać, a usługa działa poprawnie.
