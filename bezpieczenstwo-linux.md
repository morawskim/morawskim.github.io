# Bezpieczeństwo Linux

## Weryfikacja podpisów

Pobranie klucza GPG użytego do podpisania pliku/pakietu:
`gpg --keyserver keys.gnupg.net --recv-keys 0xAAAAAAAAABBBBB`

Sprawdzenie zgodności sumy kontrolnej pliku ISO:
`sha512sum -c PLIK_Z_SUMAMI_KONTROLNYMI`

Weryfikacja podpisu pliku z sumami kontrolnymi:
`gpg --verify SHA512SUM.sign SHA512SUMS`

## UEFI/Secure Boot

Jeśli są pliki w katalogu `/sys/firmware/efi/` to system został uruchomiony w trybie UEFI.

[Managing EFI Boot Loaders for Linux: Dealing with Secure Boot]( https://www.rodsbooks.com/efi-bootloaders/secureboot.html)

[Linux on UEFI:A Quick Installation Guide](https://www.rodsbooks.com/linux-uefi/)

## APT / RPM

### Utrzymanie aktualności pakietów

#### APT (Debian/Ubuntu)

Opcjonalnie można wyłączyć instalację rekomendowanych pakietów:
`apt install --no-install-recommends <pakiet>`

`apt update` - odświeża listę pakietów

`apt upgrade` - instaluje dostępne aktualizacje w tym wymagające doinstalowania nowych jako zależności; jeśli aktualizacja danego pakietu wymaga usunięcia innego, nie wykona jej

`apt full-upgrade` - instaluje także aktualizacje powodujące usnunięcie zainstalowanych pakietów

#### RHEL i pochodne

`dnf upgrade` - instaluje aktualizacje

`dnf check-upgrade` - sprawdza dostępne aktualizacje

`dnf upgrade --security` - tylko aktualizacje bezpieczeństwa

`dnf upgrade --cve=CVE-20XX-XXXXX` - aktualizacja dla konkretnej podatności


### Konfiguracja repozytoriów i kluczy

#### APT

Pliki repozytoriów:

* /etc/apt/sources.list
* /etc/apt/sources.list.d/*.list
* /etc/apt/sources.list.d/*.sources

Baza kluczy (przestarzałe podejście):

* apt-key list
* apt-key del <keyid>
* apt-key add /sciezka/do/pliku/klucza

W Debian 12, Ubuntu 24.04 i nowszych apt-key jest przestarzałe.
Zalecane jest używanie GPG oraz umieszczanie kluczy w `/etc/apt/keyrings/` i odwoływanie się do nich w plikach `.sources`.

Szczegóły i przykłady można znaleźć w podręczniku `man apt-key` sekcja deprecation.

#### RHEL

Pliki repozytoriów:

* /etc/yum.repos.d/*.repo

Zarządzanie kluczami:

`rpm -qa gpg-pubkey` - lista kluczy

`rpm -qi gpg-pubkey-1234-abcd` - szczegóły klucza

`rpm -e gpg-pubkey-1234-abcd` - usunięcie klucza

`rpmkeys --import /sciez/do/plilu/klucza` - import klucza

### Weryfikacja plików z pakietów

#### DEB

Sprawdzenie, z którego pakietu pochodzi plik:
`dpkg-query -S /sciezka/do/pliku`

Weryfikacja integralności pakietu:
`dpkg --verify nazwa_pakietu`

Sumy kontrolne są porównywane z bazą, której spójność dokumentacja zaleca spradzać poleceniem:
`dpkg --audit`

#### RPM

Sprawdzenie, z którego pakietu pochodzi plik:
`rpm -qf /sciezka/do/pliku`

Weryfikacja integralności:
`rpm --verify nazwa pakietu`

### Różnice w działaniu mechanizmu podpisów cyfrowych DEB i RPM

#### DEB

Podpisany jest tylko spis treści repozytorium (plik z sumami kontrolnymi poszczególnych plików `.deb`)

Za jego weryfikację odpowiadają programy pracujące z repozytoriami APT (apt, apt-get itp.)

Wewnątrz pojedyńczego pakietu `.deb` nie ma możliwości umieszczenia podpisu.
Program dpkg nie ma zatem możliwości potwierdzenia autentyczności pakietów, które instaluje.

#### RPM

Format RPM pozwala na umieszczenie podpisu wewnątrz samego pakietu.

Aby zweryfikować podpis konieczne jest zaimportowanie klucza do bazy RPM - `rpmkeys --import /sciezka/do/pliku/klucza`

Weryfikacja podpisu pakietu:
`rpm -K /sciezka/do/pliku.rpm`

### Automatyczne aktualizacje

#### Debian/Ubuntu

`apt install unattended-upgrades`

[Automatic updates (Ubuntu)](https://ubuntu.com/server/docs/how-to/software/automatic-updates/)

[PeriodicUpdates (Debian)](https://wiki.debian.org/PeriodicUpdates)

#### RHEL i pokrewne

`dnf install dnf-automatic`
