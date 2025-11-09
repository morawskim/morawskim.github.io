# Windows 11 Instalator

[Download Windows 11](https://www.microsoft.com/en-us/software-download/windows11)
[How to Bypass Windows 11's TPM, CPU and RAM Requirements](https://www.tomshardware.com/how-to/bypass-windows-11-tpm-requirement)
[NO Microsoft Account Needed! Windows 11 Setup Bypass (LATEST 6/2025)](https://www.youtube.com/watch?v=SiDLgdbFdtM)

### Instalacja bez dostępu do internetu

Obecnie najnowsza wersja Windows 11 nie pozwala nam na instalację systemu, bez połączenia z internetem.
Obecnie istnieje obejście.

Dochodzimy do ekranu połączenia z siecią. W moim przypadku Windows nie wykrył karty WiFi.
Wciskamy klawisz `Shift + F10`. Pojawi się okno wiersza poleceń.
W otwartym oknie wpisujemy polecenie `OOBE\BYPASSNRO` i zatwierdzamy je klawiszem Enter.
Komputer ponownie się uruchomi, a my dochodząc ponownie do ekranu połączenia się z siecią, będziemy mieć dostępną opcję "Nie mam internetu".
Klikamy w nią i kontynuujemy proces instalacji.

## Instalacja Windowsa bez modułu TPM 2.0

Dochodzimy do ekranu sprawdzania kompatybilności sprzętu z systemem Windows 11.
Wracamy do poprzedniego ekranu.
Naciskamy klawisze `Shift + F10` - pojawi się okno wiersza poleceń.
Wpisujemy polecenie `regedit` i naciskamy Enter, aby uruchomić Edytor rejestru,
W lewym panelu przechodzimy do klucza `HKEY_LOCAL_MACHINE\SYSTEM\Setup`.
Klikamy prawym przyciskiem myszy w prawym panelu i wybieramy "New -> Key".
Nadajemy mu nazwę LabConfig.
Zaznaczamy nowo utworzony klucz LabConfig w lewym panelu.

W prawym panelu klikamy prawym przyciskiem myszy i wybieramy "New -> DWORD (32-bit)".
Nadajemy nazwę `BypassTPMCheck`.
Klikamy dwukrotnie na wartość BypassTPMCheck i ustawiamy wartość na 1.
Zatwierdzamy zmiany, zamykamy Edytor rejestru oraz Wiersz poleceń, a następnie kontynuujemy instalację systemu.

## Instalacja Windowsa bez Secure Boot

Dochodzimy do ekranu sprawdzania kompatybilności sprzętu z systemem Windows 11.
Wracamy do poprzedniego ekranu.
Naciskamy klawisze `Shift + F10` - pojawi się okno wiersza poleceń.
Wpisujemy polecenie `regedit` i naciskamy Enter, aby uruchomić Edytor rejestru,
W lewym panelu przechodzimy do klucza `HKEY_LOCAL_MACHINE\SYSTEM\Setup`.
Klikamy prawym przyciskiem myszy w prawym panelu i wybieramy "New -> Key".
Nadajemy mu nazwę LabConfig.
Zaznaczamy nowo utworzony klucz LabConfig w lewym panelu.

W prawym panelu klikamy prawym przyciskiem myszy i wybieramy "New -> DWORD (32-bit)".
Nadajemy nazwę `BypassSecureBootCheck`.
Klikamy dwukrotnie na wartość BypassSecureBootCheck i ustawiamy wartość na 1.
Zatwierdzamy zmiany, zamykamy Edytor rejestru oraz Wiersz poleceń, a następnie kontynuujemy instalację systemu.

## Konwersja dysku z MBR na GTP

Dochodzimy do ekranu wyboru dysku, na którym chcemy zainstalować system Windows.
Wracamy do poprzedniego ekranu.
Naciskamy klawisze `Shift + F10` - pojawi się okno wiersza poleceń.
Wpisujemy polecenie `diskpart` i naciskamy Enter.
Znak zachęty zmieni się na `DISKPART>`.

Wpisujemy polecenie `list disk` i potwierdzamy klawiszem ENTER, aby wyświetlić listę dysków.
Prawdopodobnie dysk, na którym chcemy zainstalować Windows, to dysk 0. Wybieramy go poleceniem `select disk 0`.
Po wykonaniu zobaczymy komunikat:
> "Disk 0 is not the selected disk."

Następnie wpisujemy polecenie: `clean`, które usunie wszystkie partycje z wybranego dysku.
Otrzymamy komunikat:
> DiskPart succeeded in cleaning the disk

Konwertujemy dysk na format GPT poleceniem: `convert GPT`.
Po zakończeniu powinna się pojawić informacja:
> DiskPart successfully converted the selected disk to GPT format.

Aby zakończyć pracę z narzędziem DiskPart, wpisujemy: `exit`.
Zamykamy Wiersz poleceń i kontynuujemy instalację systemu Windows.

## Omijanie wymogu konta Microsoft podczas instalacji

Dochodzimy do ekranu logowania do konta Microsoft.
Wracamy do poprzedniego ekranu.
Naciskamy klawisze `Shift + F10` - pojawi się okno wiersza poleceń.
Wpisujemy polecenie `start ms-cxh:localonly` i naciskamy Enter.
Pojawi się możliwość utworzenia lokalnego konta użytkownika.
Tworzymy konto i kontynuujemy instalację systemu Windows.
