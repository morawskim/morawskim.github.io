Kpartx - Montowanie partycji z obrazu dysku
===========================================

Zanim zamontujemy partycję wyświetlmy odnalezione partycje.

``` bash
sudo /sbin/kpartx -l pen.img
```

Przykładowy wynik

```
loop0p1 : 0 4194304 /dev/loop0 2048
loop0p2 : 0 11677696 /dev/loop0 4196352
```

Pierwsza kolumna mówi nam jak będzie nazywać się urządzenie, które zostaną utworzone i będzie reprezentować partycję. Ostatnia kolumna mówi nam o początku partycji. Mnożąc pozycję początkową partycji przez 512 otrzymamy offset. Ten parametr możemy zastosować w poleceniu mount. W takim przypadku nie musimy tworzyć urządzeń przez kpartx.

``` bash
#montujemy pierwszą partycję
#1048576 = 2048*512
sudo mount -oloop,offset=1048576 pen.img /mnt/
```

W celu utworzenia urządzeń blokowych wydajemy polecenie

``` bash
sudo /sbin/kpartx -a -v pen.img
```

Teraz możemy już zamontować partycję

``` bash
sudo mount /dev/mapper/loop0p1 /mnt/
```

Kiedy zakończymy prace z daną partycją musimy ją odmontować

``` bash
umount /mnt
```

I usuwamy urządzenia blokowe

``` bash
sudo /sbin/kpartx -d -v pen.img
```