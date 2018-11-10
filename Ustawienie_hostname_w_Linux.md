# linux - ustawienie hostname

## systemd/hostnamectl

```
sudo hostnamectl set-hostname NOWY_HOSTNAME
```
Zmiany będą widoczne od razu.


## brak systemd

```
sudo vim /etc/HOSTNAME
```
Wymagany jest restart maszyny.
