# linux - ustawienie strefy czasowej

## systemd/timedatectl

```
sudo timedatectl set-timezone Europe/Warsaw
```

## brak systemd

```
sudo ln -s /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
```
