# Laptop i Linux

## Instalatory dystrybucji i karta nvidia

Próbując zainstalować różne dystrybucje na laptopie miałem problem z instalatorami. Po wybraniu opcji instalacji wracałem do menu wyboru (po procesie ładowania). Jednak przy dystrybucji Kubuntu wybierając opcję `Safe graphics` wszystko przebiegło bez problemu. W laptopie miałem kartę nvidia. Postanowiłem przy innej dystrybucji dodać parametr rozruchowy jądra `nomodeset`. Instalator się odpalił. Finalnie wyłączyłem sterownika nvidi poprzez parametr rozruchowy `nouveau.modeset=0` i tak zainstalowałem system. Po instalacji system wczytał się normalnie.

## Realtek 8852AE (802.11ax)

W systemie openSUSE Tumbleweed musimy dodać repozytorium [hardware](https://build.opensuse.org/project/show/hardware) i zainstalować pakiety `rtw89-firmware` i `rtw89-kmp-default`. Po ponowym uruchomieniu karta WiFi powinna być obsługiwana w systemie.

```
sudo rfkill
ID TYPE      DEVICE      SOFT      HARD
 0 wlan      phy0   unblocked unblocked
 1 bluetooth hci0   unblocked unblocked
```

## Wyłączenie beep

Sprawdzamy czy moduł jądra `pcspkr` jest załadowany, wywołując polecenie `lsmod` - `lsmod | grep pcspkr`.
Jeśli otrzymamy wynik `pcspkr                 16384  0` oznacza to, że moduł jest wczytany. Możemy tymczasowo skasować moduł poleceniem `sudo rmmod pcspkr`. Beep powinien przestać działać.
Następnie tworzymy plik `/etc/modprobe.d/blacklist.conf` i dodajemy do niego linię `blacklist pcspkr`.
Po ponownym uruchomieniu komputera, moduł `pcspkr` nie powinien się załadować, co możemy potwierdzić ponownie poleceniem `lsmod`.
