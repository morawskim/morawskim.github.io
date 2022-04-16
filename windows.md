# Windows

## Przydatne aplikacje

`NoxPlayer` - emulator systemu operacyjnego Android

`Anvil’s Storage Utilities` - narzędzie przeznaczone do testowania wydajności dysków twardych/SSD

`SyncDroid` - migracja danych miedzy telefonami Android

## PortableApps

`KiTTY Portable` - telnet and SSH with added features

`Mozilla Firefox, Portable Edition` - the award-winning web browser that's safe and secure`

`Telegram Desktop Portable` - secure instant messaging

`Shotcut Portable` - full-featured video editor

`VLC Media Player Portable` - An easy to use media player that plays many formats

`LibreOffice Portable` - word processor, spreadsheet, presentations with excellent compatibility

`7-Zip Portable` - File archiver and compressor

`ccPortable (Freeware)` - assists with running CCleaner® portably

`CPU-Z Portable (Freeware)` - system profiler

`CrystalDiskInfo Portable` - disk health monitoring tool

`CrystalDiskMark Portable` - disk benchmark utility

`GPU-Z Portable (Freeware)` - graphics system profiler

`Gridy Portable` - snap your open windows to a grid

`rcvPortable (Freeware)` - file recovery with Recuva®

`specPortable (Freeware)` - system information tool with Speccy®

`SSD-Z Portable (Freeware)` - SSD information tool

`DUMo Portable (Freeware)` - update local drivers

## Porady

`diskmgmt.msc` - Konsola do zarządzania dyskami

## Skróty klawiaturowe

`Win + Tab` – podgląd pulpitów i aktualnie otwartych okien.

`Win + PrintScreen` – tworzenie zrzutu ekranu i zapisanie go w katalogu Obrazy/Zrzuty ekranu.

## Naprawianie systemu plików NTFS

Do naprawienia systemu plików możemy użyć Linuxa.
Wywołujemy polecenie `sudo ntfsfix /dev/partycjaDyskuZSystememPlikowNTFS`
Jeśli podczas wywoływania tego polecenia otrzymamy błąd:
> Metadata kept in Windows cache, refused to mount.                                                                                                                                           
> FAILED

To wywołujemy polecenie `sudo ntfs-3g -o remove_hiberfile /dev/partycjaDyskuZSystememPlikowNTFS /mnt/`
Następnie należy odmontować system plików - `sudo umount /mnt`.
Wywołując ponownie polecenie `sudo ntfsfix /dev/partycjaDyskuZSystememPlikowNTFS` otrzymamy:

>Mounting volume... OK
>Processing of $MFT and $MFTMirr completed successfully.
>Checking the alternate boot sector... OK
>NTFS volume version is 3.1.
>NTFS partition /dev/sda2 was processed successfully

Możemy także uruchomić system Windows w trybie awaryjnym i wywołać z konsoli z uprawnieniami administratora polecenie `chkdsk DiskLetter: /f`
