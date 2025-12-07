# OpenWRT

## VirtualBox

1. Tworzymy adapter host-only: `VBoxManage hostonlyif create`. W wyniku dostaniemy nazwę utworzonego interfejsu:
>Interface 'vboxnet0' was successfully created
1. Konfigurujemy adresację dla utworzonej sieci: `VBoxManage hostonlyif ipconfig vboxnet0 --ip 192.168.56.1 --netmask 255.255.255.0`
1. Sprawdzamy, czy serwer DHCP jest utworzony i włączony dla tej sieci: `VBoxManage list dhcpservers`.
1. Jeśli DHCP jest aktywny, usuwamy serwer DHCP z utworzonej sieci: `VBoxManage dhcpserver remove --ifname vboxnet0`
1. Tworzymy nową maszynę wirtualną: `VBoxManage createvm --name "openwrt" --register`
1. Ustawiamy parametry sprzętowe: `VBoxManage modifyvm "openwrt" --memory 4096 --cpus 2`
1. Konfigurujemy sieć (interfejs host-only): `VBoxManage modifyvm "openwrt" --nic1 hostonly --hostonlyadapter1 vboxnet0`
1. Tworzymy kontroler SATA: `VBoxManage storagectl "openwrt" --name "SATA Controller" --add sata --controller IntelAhci`
1. Podłączamy istniejący dysk VDI:
```
VBoxManage storageattach "openwrt" \
  --storagectl "SATA Controller" \
  --port 0 --device 0 --type hdd \
  --medium "/sciezka/do/pliku/openwrt-24.10.4-x86-64-generic-ext4-combined.img.vdi"
```
1. Uruchamiamy maszynę wirtualną: `VBoxManage startvm openwrt`
1. Konfigurujemy interfejs sieciowy po zalogowaniu się do maszyny wirtualnej OpenWrt:
```
uci set network.lan.ipaddr=192.168.56.100
uci commit
reboot
```

[Complete Guide to OpenWrt in VirtualBox: Setup and Disk Expansion](https://dev.to/ahaoboy/complete-guide-to-openwrt-in-virtualbox-setup-and-disk-expansion-1fe2)

[openwrt-virtualbox-build releases](https://github.com/ahaoboy/openwrt-virtualbox-build/releases/tag/nightly)
