# Windows - klonowanie dysku

Do sklonowania dysku na większy dysk użyłem oprogramowania Clonezilla.
Po zakończeniu klonowania system Windows nie chciał jednak uruchomić się z nowego dysku.

W celu naprawienia bootloadera uruchomiłem konsolę odzyskiwania systemu Windows
z instalatora Windows.

### Diskpart

W konsoli uruchamiamy program diskpart `diskpart`.

Pojawi się prompt `DISKAPRT>`.

Wyświetlamy listę dostępnych dysków `list disk`
Wybieramy nowy dysk, na który sklonowaliśmy zawartość starego dysku `select disk N`
(gdzie N to numer (indeks) wybranego dysku)

Wyświetlamy listę dostępnych wolumenów `list volume`.
Szukamy partycji EFI/UEFI.
Powinna ona mieć system plików FAT32 i zazwyczaj rozmiar około 100 MB.
Wybieramy odpowiedni wolumen `select volume N`
(gdzie N to numer wybranego wolumenu)

Następnie przypisujemy mu tymczasową literę dysku, np. K - `assign letter=k`

Wychodzimy z programu diskpart `exit`.

### Bootloader

Przechodzimy do katalogu bootloadera na partycji EFI: `cd k:\efi\microsoft\boot`
I przechodzimy do wolumenu - `k:`

Prompt powinien teraz zawierać ścieżkę `k:\efi\microsoft\boot`

Najpierw usuwamy atrybuty `attrib bcd -h -r -s`
Zmieniamy nazwę istniejącego pliku BCD `ren bcd bcd.old`
Odbudowujemy bazę konfiguracji rozruchowej `bootrec /rebuildbcd`

Jeżeli zostanie znaleziona instalacja systemu Windows, należy dodać ją do listy systemów rozruchowych.

Na koniec wykonujemy polecenie `bcdboot c:\windows /s k: /f UEFI`
gdzie:

* `C:\Windows` — ścieżka do katalogu z zainstalowanym systemem Windows (widoczna w poleceiu `list volume` diskpart)
* `K:` — litera przypisana wcześniej partycji EFI/UEFI.

Można ponownie uruchomić komputer i sprawdzić, czy system Windows uruchamia się z nowego,
sklonowanego dysku.

[Fix PC Can't Boot From Newly Cloned SSD / HDD](https://www.youtube.com/watch?v=WqJV9i19iUU)
