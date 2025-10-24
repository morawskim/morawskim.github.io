# KVM/libvirt - przekazanie urządzenia USB do maszyny wirtualnej (usb-host)

Celem było przekazanie do maszyny wirtualnej urządzenia USB — Zigbee USB Dongle.

Najpierw wyświetlamy listę urządzeń USB, aby poznać vendor ID oraz product ID - `lsusb`

```
...
Bus 003 Device 005: ID 10c4:ea60 Silicon Labs CP210x UART Bridge
.....
```

W katalogu `/etc/libvirt` tworzymy plik zigbee.xml o następującej zawartości:

```
<hostdev mode="subsystem" type="usb" managed="yes">
  <source>
    <vendor id="0x10c4"/>
    <product id="0xea60"/>
  </source>
</hostdev>
```


Sprawdzamy działające maszyn wirtualne - `virsh -c qemu:///system list`

```
Id   Name               State
----------------------------------
 1    vm-ubuntu-k8s      running
......
````

Próbujemy przekazać urządzenie do maszyny: - `virsh -c qemu:///system  attach-device vm-ubuntu-k8s --file /etc/libvirt/zigbee.xml --persistent`

Otrzymałem błąd:

>error: Failed to attach device from /etc/libvirt/zigbee.xml
error: internal error: unable to execute QEMU command 'device_add': 'usb-host' is not a valid device model name

Wyświetlamy konfigurację kontrolerów USB w maszynie: `virsh -c qemu:///system dumpxml  vm-ubuntu-k8s | grep -i usb -A2`

```
  <controller type='usb' index='0' model='piix3-uhci'>
      <alias name='usb'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x2'/>
    </controller>
```

Tworzymy plik /etc/libvirt/usb-controller.xml o treści:

```
<controller type='usb' model='qemu-xhci'/>
```

Następnie dołączyłem nowy kontroler do maszyny: `virsh  -c qemu:///system  attach-device  vm-ubuntu-k8s /etc/libvirt/usb-controller.xml --live --persistent`


Problem nadal występował.
Sprawdziłem dostępne modele urządzeń USB w QEMU: `qemu-system-x86_64 -device help | grep usb` nie zwracało w wyniku `usb-host`.

Wynik nie zawierał usb-host, co oznaczało, że QEMU nie ma wkompilowanego modułu obsługi usb-host.host.
W systemie openSUSE Leap 15 moduł ten dostarcza pakiet `qemu-hw-usb-host`.

Po ponownym sprawdzeniu: `qemu-system-x86_64 -device help | grep usb`, otrzymałem.

>name "usb-host", bus usb-bus
name "usb-hub", bus usb-bus
name "ich9-usb-ehci1", bus PCI
name "ich9-usb-ehci2", bus PCI
name "ich9-usb-uhci1", bus PCI
name "ich9-usb-uhci2", bus PCI
name "ich9-usb-uhci3", bus PCI
name "ich9-usb-uhci4", bus PCI
name "ich9-usb-uhci5", bus PCI
name "ich9-usb-uhci6", bus PCI
name "nec-usb-xhci", bus PCI
name "piix3-usb-uhci", bus PCI
name "piix4-usb-uhci", bus PCI
name "usb-ehci", bus PCI
name "usb-bot", bus usb-bus
name "usb-mtp", bus usb-bus, desc "USB Media Transfer Protocol device"
name "usb-storage", bus usb-bus
name "usb-uas", bus usb-bus
name "usb-net", bus usb-bus
name "usb-braille", bus usb-bus
name "usb-ccid", bus usb-bus, desc "CCID Rev 1.1 smartcard reader"
name "usb-kbd", bus usb-bus
name "usb-mouse", bus usb-bus
name "usb-serial", bus usb-bus
name "usb-tablet", bus usb-bus
name "usb-wacom-tablet", bus usb-bus, desc "QEMU PenPartner Tablet"
name "usb-audio", bus usb-bus
name "u2f-passthru", bus usb-bus, desc "QEMU U2F passthrough key"
name "usb-redir", bus usb-bus


Dzięki temu, że usb-host stało się dostępne urządzenie mogło zostać poprawnie przekazane do maszyny wirtualnej.

W maszynie wirtualnej urządzenie było już widoczne po stronie USB, ale nie pojawiało się w /dev np. `/dev/ttyUSB0`.
Urządzenie wymagało sterownika cp210x.
W systemie gościa załadowałem moduł: `modprobe cp210x`.
Jeśli moduł nie jest dostępny, należy zainstalować pakiet z dodatkowymi modułami jądra: `apt-cache search linux-modules-extra-$(uname -r)`
Po instalacji i ponownym załadowaniu modułu urządzenie pojawiło się w katalogu /dev.
