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
