Montowanie dysku poprzez identyfikator UUID
===========================================

Montowanie partycji po jej nazwie (np. sda1) może być problematyczne, w przypadku kiedy korzystamy często z pamięci przenośnej. Zaleca się montowanie takich partycji po identyfikatorze UUID. Identyfikator UUID partycji można podejrzeć wywołując poniższe polecenie:

``` bash
sudo /usr/sbin/blkid
#wynik polecenia
/dev/sda1: LABEL="System Reserved" UUID="EC4883134882DBA8" TYPE="ntfs"
/dev/sda2: UUID="9878917F78915D36" TYPE="ntfs"
/dev/sda3: UUID="AC64966864963554" TYPE="ntfs"
/dev/sdb1: UUID="498b2998-acfd-4df4-b360-527bfa6a6ca7" TYPE="swap"
/dev/sdb2: UUID="cf2dc87f-1b23-40ab-83a1-e4d91967f965" TYPE="ext4"
/dev/sdb3: UUID="a691834b-d6c1-45cf-aab0-2ec2881579bd" TYPE="ext4"
/dev/sdc1: SEC_TYPE="msdos" LABEL="SD_BACKUP" UUID="48FC-A694" TYPE="vfat"
```

Do pliku /etc/fstab dodajemy wpis, aby montować partycję "48FC-A694" przy każdym uruchomieniu. <syntaxhiglight lang="text"> UUID=48FC-A694 /srv/backup vfat defaults 0 0 </syntaxhiglight> Pierwsza kolumna to nazwa użądzenia, jego identyfikator (UUID) albo etykieta (LABEL).
Druga kolumna to punkt montowania.
Trzecia kolumna to typ systemu plików (FAT32, ext4, ntfs itp).
Czwarta kolumna to opcje dla polecenia mount (dla danego systemu plików), oddzielone przecinkiem. Wartość defaults oznacza że następujące opcje zostaną użyte: rw, suid, dev, exec, auto, nouser, and async. Jeśli nie chcemy montować systemu plików na starcie systemu dodajemy opcję noauto.
Piątka kolumna jest interpretowana przez program dump. Określa, które partycje powinny być archiwizowane.
Szósta kolumna jest używana przez program fsck (sprawdza poprawności systemu plików). Wartość "0" oznacza że ten system plików nie powinien być sprawdzany przez fsck. Wartość "1"jest "zarezerwowana" tylko dla głównego sytemu plików, pozostałe systemy plików powinny mieć wartość "2".