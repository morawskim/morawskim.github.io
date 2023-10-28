# udev

Udev zarządza sprzętem i za pomocą reguł umożliwia spersonalizowanie konfiguracji urządzenia.

Aby monitorować zmiany sprzętowe (podłączenie/odłączenie urządzenia) wywołujemy polecenie `udevadm monitor --property`

Po podłączeniu/odłączeniu urządzenia na wyjściu otrzymamy dane zdarzenia. W moim przypadku jest to fragment zdarzenia podłączenia YubiKey do portu USB.

```
[.....]
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:08.1/0000:06:00.3/usb1/1-1/1-1.2/1-1.2.4
SUBSYSTEM=usb
DEVNAME=/dev/bus/usb/001/009
DEVTYPE=usb_device
PRODUCT=1050/407/543
TYPE=0/0/0
BUSNUM=001
DEVNUM=009
SEQNUM=4708
USEC_INITIALIZED=2069506421
ID_BUS=usb
ID_MODEL=YubiKey_OTP+FIDO+CCID
ID_MODEL_ENC=YubiKey\x20OTP+FIDO+CCID
ID_MODEL_ID=0407
ID_SERIAL=Yubico_YubiKey_OTP+FIDO+CCID
ID_VENDOR=Yubico
ID_VENDOR_ENC=Yubico
ID_VENDOR_ID=1050
ID_REVISION=0543
[.....]
```

Z tym informacji możemy uzyskać ścieżkę do urządzenia w katalogu /dev - `DEVNAME=/dev/bus/usb/001/009`

Oprócz monitorowania zdarzeń, możemy także wywołać polecenie `udevadm info --query=all --name=/dev/bus/usb/001/009`, aby wyświetlić informacje o urządzeniu.
Do tworzenia reguł potrzebujemy wyświetlić atrybuty danego urządzenia, więc do powyższego polecenia dodajemy flagę `--attribute-walk` - `udevadm info --query=all --attribute-walk --name=/dev/bus/usb/001/009`

Jeśli nie znamy nazwy urządzenia USB możemy ją utworzyć. W wyniku polecenia `lsusb` przy naszym urządzeniu wyświetlą się numer szyny i urządzenia.

```
Bus 001 Device 009: ID 1050:0407 Yubico.com Yubikey 4/5 OTP+U2F+CCID
```

Ścieżka jest w formacie `/dev/bus/usb/<BUS_ID>/<DEVICE_ID>`, stąd dla tego urządzenia mamy `/dev/bus/usb/001/009`

Regułę udev tworzymy w katalogu `/etc/udev/rules.d/`. Plik z regułą musi zawierać rozszerzenie `rules`. Tworząc reguły możemy wzorować się na istniejących dostępnych w katalogu `/lib/udev/rules.d` Przykładowa reguła, która wykonuje się przy podłączaniu/odłączaniu sprzętu i loguje date do pliku, prezentuje się następująco:

```
ACTION=="add|remove", RUN+="/bin/bash -c '(date; env; echo) >> /tmp/udev.log'"
```

Usługa udev powinna przeładować zestaw reguł, ale możemy także jawnie przeładować reguły poleceniem `sudo udevadm control --reload-rules`.

Regułę możemy przetestować nim odłączymy/podłączymy urządzenie. W trybie testowym polecenia reguły nie są uruchamiane.

Na początek musimy uzyskać ścieżkę sysfs naszego urządzenia. Wywołujemy polecenie `udevadm info --query=path --name=/dev/bus/usb/001/009`.

Mając ścieżkę możemy przetestować regułę `udevadm test --action=add /devices/pci0000:00/0000:00:08.1/0000:06:00.3/usb1/1-1/1-1.2/1-1.2.4`. W wyniku  polecenia znajdziemy naszą komendę do wywołania.

>run: '/bin/bash -c '(date; env; echo) >> /tmp/udev.log''


## Xorg

Reguły udev są wywoływane z uprawnieniami konta root. Akcje którą wywołujemy nie ma dostępu do środowiska graficznego. Rozwiązaniem może być wyciągnięcie ciasteczka do serwera graficznego poleceniem `ps -f -C Xorg.bin | sed 's/.*-auth \(.*\)/\1/p' | cut -d' ' -f1 | tail -1`, a następnie ustawienie zmiennych środowiskowych XAUTHORITY na wartość z poprzedniego polecenia i DISPLAY na wartość `:0`.
Przykładowe wywołanie może wyglądać w taki sposób `XAUTHORITY=/run/sddm/xauth_PRpmLG DISPLAY=:0 kdialog --msgbox "Lorem ipsum"`
