# Linux - porady stacja robocza

## VA (VIdeo Acceleration)

Za pomocą programu `vainfo` (pakiet `libva-utils`) uzyskujemy informację o obsługiwanej sprzętowo dekodowaniu wideo.
Przyrostek `VLD` oznacza zdolność do dekodowania, natomiast `EncSlice` do kodowania.
Odtwarzacz `mpv` jest w stanie korzystać z sprzętowej akceleracji podczas dekodowania wideo - `--hwdec=vaapi`.

## turbostat

Za pomocą programu `turbostat` możemy obserwować aktualne zużycie energii - `sudo /usr/bin/turbostat --quiet -i 3 --show 'PkgWatt,CorWatt,GFXWatt,RAMWatt'`

`PkgWatt` - układ, `CorWatt` - procesor, `GFXWatt` - karta graficzna, `RamWatt` - pamięć

## rfkill

`rfkill` to narzędzia do włączania i wyłączania urządzeń bezprzewodowych. Wywołując polecenie `sudo rfkill list wifi` otrzymamy aktualny status. W przypadku blokady `Soft blocked` możemy użyć kombinacji klawiszy, aby spróbować wyłączyć tryb samolotowy. Jeśli to nie pomoże, możemy użyć polecenia `sudo rfkill unblock wifi`.

## ventoy

Ventoy to narzędzie przeznaczone do tworzenia rozruchowych nośników USB wykorzystując obrazy ISO z dowolnym systemem operacyjnym. Program można ściągnąć ze strony projektu w serwisie [Github](https://github.com/ventoy/Ventoy/releases). Po ściągnięciu i rozpakowaniu archiwum wywołujemy polecenie `sudo ./Ventoy2Disk.sh -i <IDENTYFIKATOR_URZADZENIA>`, gdzie `<IDENTYFIKATOR_URZADZENIA>` to ścieżka do naszego pendrive np. `/dev/sdb`.

Następnie montujemy partycję z etykietą "Ventoy" i kopiujemy nasze pliki ISO. W niektórych dystrybucjach Linuxa, musimy doinstalować pakiet `fuse-exfat`, aby móc zamontować partycję (exfat) i przekopiować pliki ISO.

## iwd

iwd - nowy demon sieci bezprzewodowych w Linuksie.

[Artykuł w Linux Magazine Marzec 2021 - Nr 205](https://linux-magazine.pl/lm205/abrakadabra-przedstawiamy-inet-nowy-demon-sieci-bezprzewodowych-w-linuksie-1265.html)

## Specjalistyczne dystrybucje

| Dystrybucja | Opis |
| - | - |
| openmediavault | System operacyjny przygotowany do uruchomienia własnego NAS |
| TrueNAS (wcześniej FreeNAS) | System operacyjny przygotowany do uruchomienia własnego NAS |
