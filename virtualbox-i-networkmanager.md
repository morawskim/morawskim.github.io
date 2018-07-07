# Virtualbox i NetworkManager

Jeśli naszą konfiguracją sieciową zarządza NetworkManager i korzystamy z interfejsów host-only na VirtalBox,
to pewnie natrafimy na problem, że po wznowieniu komputera po uśpieniu interfejs maszyny wirtualnej się nie podniesie.

Tak wygląda interfejs host-only przed uśpieniem w systemie gospodarza.
```
7: vboxnet1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
link/ether 0a:00:27:00:00:01 brd ff:ff:ff:ff:ff:ff
inet 192.168.33.1/24 brd 192.168.33.255 scope global vboxnet1
valid_lft forever preferred_lft forever
inet6 fe80::800:27ff:fe00:1/64 scope link 
valid_lft forever preferred_lft forever
```

Po wznowieniu:
```
7: vboxnet1: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast state DOWN group default qlen 1000
link/ether 0a:00:27:00:00:01 brd ff:ff:ff:ff:ff:ff
```

Dodatkowo w logach NetworkManager mamy:
```
cze 20 19:05:27 linux-lenovo NetworkManager[1235]: <warn> (vboxnet1): failed to find device 7 'vboxnet1' with udev
cze 20 19:05:27 linux-lenovo NetworkManager[1235]: <info> (vboxnet1): new Ethernet device (carrier: OFF, driver: 'vboxnet', ifindex: 7)
cze 20 19:08:21 linux-lenovo NetworkManager[1235]: <info> keyfile: add connection in-memory (646162b9-a7b6-4882-982a-8115156bcc35,"vboxnet1")
cze 20 19:08:21 linux-lenovo NetworkManager[1235]: <info> (vboxnet1): device state change: unmanaged -> unavailable (reason 'connection-assumed') [10 20 41]
cze 20 19:08:21 linux-lenovo NetworkManager[1235]: <info> (vboxnet1): device state change: unavailable -> disconnected (reason 'connection-assumed') [20 30 41]
cze 20 19:08:21 linux-lenovo NetworkManager[1235]: <info> (vboxnet1): Activation: starting connection 'vboxnet1' (646162b9-a7b6-4882-982a-8115156bcc35)
cze 20 19:08:21 linux-lenovo NetworkManager[1235]: <info> (vboxnet1): device state change: disconnected -> prepare (reason 'none') [30 40 0]
cze 20 19:08:21 linux-lenovo NetworkManager[1235]: <info> (vboxnet1): device state change: prepare -> config (reason 'none') [40 50 0]
cze 20 19:08:21 linux-lenovo NetworkManager[1235]: <info> (vboxnet1): device state change: config -> ip-config (reason 'none') [50 70 0]
cze 20 19:08:21 linux-lenovo NetworkManager[1235]: <info> (vboxnet1): device state change: ip-config -> ip-check (reason 'none') [70 80 0]
cze 20 19:08:21 linux-lenovo NetworkManager[1235]: <info> (vboxnet1): device state change: ip-check -> secondaries (reason 'none') [80 90 0]
cze 20 19:08:21 linux-lenovo NetworkManager[1235]: <info> (vboxnet1): device state change: secondaries -> activated (reason 'none') [90 100 0]
cze 20 19:08:21 linux-lenovo NetworkManager[1235]: <info> (vboxnet1): Activation: successful, device activated.
cze 20 19:08:21 linux-lenovo NetworkManager[1235]: <info> (vboxnet1): link connected
cze 20 19:10:53 linux-lenovo NetworkManager[1235]: <info> (vboxnet1): device state change: activated -> unmanaged (reason 'sleeping') [100 10 37]
cze 20 19:10:53 linux-lenovo NetworkManager[1235]: <info> (vboxnet1): link disconnected
```

Jednak na maszynie wirtualnej ciągle mamy przypisany adres IP na interfejsie:
```
2: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
link/ether 08:00:27:6a:66:5a brd ff:ff:ff:ff:ff:ff
inet 192.168.33.10/24 brd 192.168.33.255 scope global eth1
valid_lft forever preferred_lft forever
inet6 fe80::a00:27ff:fe6a:665a/64 scope link 
valid_lft forever preferred_lft forever
```

Ten problem jest opisany w zgłoszeniu - https://www.virtualbox.org/ticket/13873

Musimy utworzyć plik `/etc/NetworkManager/conf.d/vbox.conf`.
O zawartości:
```
[keyfile]
unmanaged-devices=interface-name:vboxnet*
;linja wyzej nie dziala na opensuse 42.2
unmanaged-devices=interface-name:vboxnet0;interface-name:vboxnet1;interface-name:vboxnet2
```

Po ponownym uruchomieniu komputera, NetworkManager nie będzie zarządzał interfejsami `vboxnet*`.
Dzięki temu po wznowieniu systemu, ciągle będziemy mogli się podłączyć do systemu gościa przez interfejs host-only.

```
nmcli dev status
URZĄDZENIE         TYP       STAN           POŁĄCZENIE
br-a516fc5c7f13    bridge    połączono      br-a516fc5c7f13
docker0            bridge    połączono      docker0
wlan0              wifi      połączono      RADEK_NETWORK
C8:D1:0B:F2:F8:E3  bt        rozłączono     --
eth0               ethernet  niedostępne    --
vboxnet0           ethernet  niezarządzane  --
vboxnet1           ethernet  niezarządzane  --
vboxnet2           ethernet  niezarządzane  --
vboxnet3           ethernet  niezarządzane  --
lo                 loopback  niezarządzane  --
```
