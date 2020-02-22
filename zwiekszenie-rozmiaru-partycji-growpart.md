# Zwiększenie rozmiaru partycji (growpart)

Obecnie wykorzystując serwer w chmurze, możemy szybko dodać dodatkową przestrzeń lub zmienić jej rozmiar.
Potrzebujemy programu `growpart`, który jest dostępny w pakiecie `growpart` dla dystrybucji openSUSE i `cloud-guest-utils` w przypadku dystrybucji Ubuntu.

https://www.digitalocean.com/docs/volumes/how-to/expand-partitions/

https://blog.sleeplessbeastie.eu/2019/07/17/how-to-increase-google-cloud-virtual-machine-disk-size/

https://docs.amazonaws.cn/en_us/AWSEC2/latest/UserGuide/recognize-expanded-volume-linux.html


Proces ten możemy przećwiczyć emulując fizyczne urządzenie blokowe.
Tworzymy plik, który będzie reprezentował nasze urządzenie blokowe - `dd if=/dev/zero of=disk.raw bs=1024 count=500000`

Następnie generujemy tabelę partycji za pomocą narzędzia `fdisk`. Wywołujemy interaktywny tryb - `fdisk disk.raw`.
Tworzymy nową (`n`) partycję podstawową (`p`) o numerze `1` i rozmiarze np. 100 MB (`+100M`). Zapisujemy tabelę partycji (`w`).

Tworzymy nasze urządzenia blikowe. Możemy skorzystać z kpartx ([Kpartx - Montowanie partycji z obrazu dysku](Kpartx_-_Montowanie_partycji_z_obrazu_dysku.md)). Inna opcja to `sudo losetup --partscan --show --find disk.raw`.

Możemy teraz wywołać polecenie `lsblk --fs`, aby zobaczyć nasze urządzenia blokowe i ich systemy plików.
```
NAME      FSTYPE  LABEL           UUID                                 MOUNTPOINT
loop0
└─loop0p1
sda
└─sda1    ext4    cloudimg-rootfs 6cbfe350-30ce-4407-affc-cbc785f199b7 /
sdb       iso9660 cidata          2019-04-04-16-00-22-00
```

Widzimy nasze nowe urządzenie blokowe, które nie posiada obecnie żadnego systemu plików.
Musimy je utworzyć wywołując polecenie `sudo mkfs.ext4 -L etykieta /dev/loop0p1`.
Montujemy partycję - `sudo mount /dev/loop0p1 /mnt/`
Sprawdzamy wielkość partycji poleceniem `df -h`.
```
Filesystem      Size  Used Avail Use% Mounted on
....
/dev/loop0p1     93M  1.6M   85M   2% /mnt
```

Możemy utworzyć plik na nowej partycji `echo "foo" | sudo tee /mnt/foo`
Zwiększamy rozmiar partycji poleceniem `sudo growpart /dev/loop0 1`
```
CHANGED: partition=1 start=2048 old: size=204800 end=206848 new: size=997919,end=999967
```

Wywołując polecenie `fdisk -l disk.raw` możemy potwierdzić że dane rekordu MBR się zmieniły.
```
Disk disk.raw: 488.3 MiB, 512000000 bytes, 1000000 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xa0c9d8b8

Device     Boot Start    End Sectors   Size Id Type
disk.raw1        2048 999966  997919 487.3M 83 Linux
```

Po założeniu systemu plików na nowym urządzeniu blokowym widzimy zmiany na wyjściu `lsblk --fs`
```
lsblk --fs
NAME      FSTYPE  LABEL           UUID                                 MOUNTPOINT
loop0
└─loop0p1 ext4    etykieta        e2bc7915-e888-42e0-b54e-874d85c84e66
sda
└─sda1    ext4    cloudimg-rootfs 6cbfe350-30ce-4407-affc-cbc785f199b7 /
sdb       iso9660 cidata          2019-04-04-16-00-22-00
```

Odłączamy partycję `sudo umount /mnt`
Weryfikujemy stan systemu plików `sudo e2fsck -f /dev/loop0p1`
```
e2fsck 1.44.1 (24-Mar-2018)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
etykieta: 12/25688 files (0.0% non-contiguous), 8897/102400 blocks
```

Zwiększamy rozmiar systemu plików - `sudo resize2fs /dev/loop0p1`
```
resize2fs 1.44.1 (24-Mar-2018)
Resizing the filesystem on /dev/loop0p1 to 498956 (1k) blocks.
The filesystem on /dev/loop0p1 is now 498956 (1k) blocks long.
```

Montuje ponownie partycję - `sudo mount /dev/loop0p1 /mnt/`
Wyświetlamy rozmiar partycji `df -h`
```
Filesystem      Size  Used Avail Use% Mounted on
...
/dev/loop0p1    469M  2.3M  438M   1% /mnt
```

Możemy także wyświetlić zawartość wcześniej utworzonego pliku tekstowego.
Finalnie odłączamy partycję `sudo umount /mnt` i kasujemy nasze urządzenia blokowe `sudo losetup -d /dev/loop0`
