# Ubuntu

## netplan

Na jednym ze swoich serwerów zainstalowałem serwerową edycję Ubuntu.
Domyślna konfiguracja interfejsu sieciowego `netplan get` wyglądała następująco:

```
network:
  version: 2
  ethernets:
    eno1:
      dhcp4: true
```

Serwer obsługiwał mDNS, więc dynamiczny adres IP nie był problemem.
Jednak maszyny wirtualne znajdowały się w osobnej sieci.

Aby uzyskać dostęp do usługi Open WebUI z maszyny wirtualnej, musiałem dodać dodatkowy adres IP do interfejsu sieciowego.

Utworzyłem nowy plik `99-custom.yaml` o następującej zawartości:

```
network:
  version: 2
  ethernets:
    eno1:
      addresses:
        - 192.168.50.201/24
```

Za pomocą polecenia `netplan get` można sprawdzić scaloną konfigurację Netplan.

Następnie wywołałem polecenie: `netplan try --timeout 30` aby przetestować zmiany.
Pingi działały zarówno po adresie przydzielonym przez DHCP, jak i po statycznym adresie IP.
Dzięki temu mogłem bezpiecznie zastosować konfigurację poleceniem: `netplan apply`

[Configuring networks](https://documentation.ubuntu.com/server/explanation/networking/configuring-networks/#)

[Netplan documentation](https://netplan.readthedocs.io/en/stable/)

### Wake-on-LAN

Obsługa Wake-on-LAN jest konfigurowana bezpośrednio w netplanie.
Domyślnie WoL jest wyłączony, dlatego należy jawnie włączyć odpowiednią opcję dla interfejsu sieciowego.

Aby włączyć Wake-on-LAN, należy ustawić parametr: `wakeonlan: true`
Przykładowa konfiguracja:

```
network:
  version: 2
  ethernets:
    eno1:
      wakeonlan: true
      # ...
```

## Brak mikrofonu Bluetooth w ustawieniach dźwięku

System Ubuntu 24.04 LTS wykrywał słuchawki Bluetooth, jednak w ustawieniach dźwięku nie było możliwości wyboru mikrofonu.
Ta wersja systemu korzysta z PulseAudio.
Rozwiązaniem okazało się przejście na PipeWire.

Zainstalowałem wymagane pakiety - `sudo apt install pipewire`.
Następnie zrestartowałem system.

Za pomocą polecenia `pactl info` (wymagany pakiet pulseaudio-utils) możemy sprawdzić czy korzystamy z PipeWire.

> ...
> Server Name: PulseAudio (on PipeWire 1.0.5)
> ....

Po tej zmianie w ustawieniach dźwięku pojawiła się możliwość wyboru mikrofonu Bluetooth i urządzenie zaczęło działać poprawnie.

[Bluetooth headset mic not working/detected in Ubuntu 20.04](https://atish3604.medium.com/solved-bluetooth-headset-mic-not-working-detected-in-ubuntu-20-04-86a5236444d0)
