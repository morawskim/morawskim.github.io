# KVM – Zwiększenie rozmiaru dysku

Plan działania

- Sprawdź układ partycji przed rozszerzeniem.
- Wyłącz maszynę wirtualną.
- Zwiększ rozmiar pliku dysku przez `qemu-img resize`.
- Uruchom maszynę – system może automatycznie wykryć zmianę.
- W razie potrzeby – rozszerz partycję i system plików ręcznie.

Aby zwiększyć rozmiar partycji w maszynie wirtualnej KVM, najpierw warto sprawdzić układ tablicy partycji.
Używamy w tym celu `fdisk` lub `gdisk`, aby upewnić się, że istnieje możliwość rozszerzenia interesującej nas partycji –
w przeciwnym razie operacja powiększenia dysku nie przyniesie efektu.

W moim przypadku tablica partycji wyglądała następująco (`sudo gdisk /dev/vda`):

```
Number  Start (sector)    End (sector)  Size       Code  Name
   1          227328       167772126   79.9 GiB    8300
  14            2048           10239   4.0 MiB     EF02
  15           10240          227327   106.0 MiB   EF00
```

Warto zwrócić uwagę, że pierwsza partycja (z kodem 8300) znajduje się na końcu dysku, co umożliwia jej łatwe rozszerzenie.


Zatrzymujemy maszynę wirtualną przed modyfikacjami.

Aby uzyskać ścieżkę do pliku QCOW2, możemy użyć polecenia: `virsh -c qemu:///system dumpxml NAZWA_MASZYNY`

Przykład fragmentu XML:

```
<!-- ....... -->
    <disk type='volume' device='disk'>
      <driver name='qemu' type='qcow2'/>
      <source pool='default' volume='disk-vm-k8s' index='2'/>
      <backingStore type='file' index='3'>
        <format type='qcow2'/>
        <source file='/var/lib/libvirt/images/ubuntu-lts-20-k8s.qcow2'/>
        <backingStore/>
      </backingStore>
      <target dev='vda' bus='virtio'/>
      <alias name='virtio-disk0'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x0'/>
    </disk>
<!-- ....... -->
```

Alternatywnie: `virsh -c qemu:///system domblklist vm-ubuntu-k8s`

Przykład wyniku:

```
 Target   Source
-------------------------------
 vda      disk-vm-k8s
 hdd      /var/lib/libvirt/images/commoninit-ubuntu-k8s.iso
```

Jak widać, oba polecenia nie podają pełnej ścieżki do pliku.

Sprawdzamy dostępne storage poole: `virsh -c qemu:///system pool-list --all`

Wynik:

```
 Name      State    Autostart
-------------------------------
 default   active   no
```

Wyświetlamy zawartość danego storage poola: `virsh -c qemu:///system vol-list default`

Wynik:

```
 Name               Path
-------------------------------------------------------------
.......
 disk-vm-k8s        /var/lib/libvirt/images/disk-vm-k8s
......
```


Mając ścieżkę do pliku dysku, zwiększamy jego rozmiar o np. 250GB: `sudo qemu-img resize /var/lib/libvirt/images/disk-vm-k8s +250G`

Uruchamiamy maszynę wirtualną.
W moim przypadku (Ubuntu 20.04 LTS z cloud-init) system automatycznie rozpoznał nowy rozmiar dysku, a partycja została rozszerzona automatycznie: `df -h`

Wynik:

```
Filesystem      Size  Used Avail Use% Mounted on
tmpfs           1.2G  3.5M  1.2G   1% /run
/dev/vda1       320G   68G  252G  22% /
tmpfs           6.0G     0  6.0G   0% /dev/shm
```


W razie potrzeby, można sprawdzić układ partycji ponownie (`gdisk`/`fdisk`) i ręcznie rozszerzyć partycję oraz system plików, np. przy pomocy `resize2fs` (dla ext4)

Podczas rozruchu maszyny wirtualnej mogą pojawić się wpisy informujące o rozszerzeniu partycji.
Można je wyświetlić po zakończeniu procesu rozruchu za pomocą polecenia: `sudo dmesg | grep vda`

>
[    0.954243] virtio_blk virtio2: [vda] 692060160 512-byte logical blocks (354 GB/330 GiB)
[    1.017805]  vda: vda1 vda14 vda15
[    3.604452] EXT4-fs (vda1): mounted filesystem with ordered data mode. Opts: (null). Quota mode: none.
[    4.274266] EXT4-fs (vda1): re-mounted. Opts: discard,errors=remount-ro. Quota mode: none.
[    8.536795] EXT4-fs (vda1): resizing filesystem from 20943099 to 86479099 blocks
[    8.671459] EXT4-fs (vda1): resized filesystem to 86479099
