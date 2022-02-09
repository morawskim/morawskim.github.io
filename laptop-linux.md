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

## Włączenie numlock podczas logowania

Dla środowiska graficznego KDE Plsasma musimy uruchomić `System Settings`. Następnie w sekcji `Hardware` kliknąć w `Input Devices` i przejść do zakładki `Keyboard`. W sekcji `NumLock on Plasma Startup` wybieramy opcję `Turn on`.
Pewną niedogodnością tego rozwiązania jest fakt, że numlock działa dopiero po zalogowaniu się do systemu.

[Activating numlock on bootup](https://wiki.archlinux.org/title/Activating_numlock_on_bootup)
[Enable Numlock on Login](https://help.ubuntu.com/community/NumLock)

## Firewalld

Po instalacji i konfiguracji `firewalld` możemy wyświetlić konfigurację strefy - `firewall-cmd --list-all-zones`.
Za pomocą NetworkManager możemy przypisać sieć WIFI do odpowiedniej strefy. Możemy także wywołać polecenie `firewall-cmd --zone=internal --change-interface=<INTERFACE> --permanent`.

## KDE

### Dolphin

Wciskamy `[ctrl]+[shift]+[,]` aby otworzyć okno "preferences".
Z menu po lewej klikamy w pozycję "General" i wybieramy zakładkę "Behaviour".
W sekcji "View" zaznaczamy opcję "Remember display style for each folder" i zapisujemy zmiany.

### KWin

Plasma 5.24 ułatwia nam wykorzystanie mocy wielu wirtualnych pulpitów poprzez nowy efekt "Overview".
Ciągle jest w fazie beta, więc musimy go włączyć ręcznie - `System Settings` -> `Workspace Behavior` -> `Desktop Effects`. Szukamy efektu `Overview` i go włączamy.
Aktywujemy ten efekt poprzez wciśnięcie kombinacji klawiszy `Meta (Windows key) + w`.

[Plasma 5.24 - Overview](https://kde.org/pl/announcements/plasma/5/5.24.0/#zarz%C4%85dzanie-oknami)

[KDE Plasma 5.24 - New overview effect](https://www.youtube.com/watch?v=i1GLKYqm_CM)
