# btrfs

Listowanie systemów plików Btrfs `sudo btrfs filesystem show`

Listing wszystkich podwoluminów `sudo btrfs subvolume list /`

Użycie systemu plików `df -t btrfs`

## Montowanie partycji home

Montujemy dysk z systemem plików btrfs w katalogu `/mnt`.
Wyświetlamy dostępne subwoluminy - `sudo btrfs subvolume list /mnt`
Przykładowe dane:
```
ID 256 gen 31 top level 5 path @
ID 257 gen 612739 top level 256 path @/var
ID 258 gen 612579 top level 256 path @/usr/local
ID 259 gen 604579 top level 256 path @/srv
ID 260 gen 612738 top level 256 path @/root
ID 261 gen 612675 top level 256 path @/opt
ID 262 gen 612738 top level 256 path @/home
```
Odłączamy dysk poleceniem umount i montujemy subwolumin @/home `sudo mount /dev/sdb2 -o subvol=@/home /mnt/`.
