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

## Listy kontrolne dostępu (mechanizm ACL)

Wyświetlenie ACL dla pliku lub katalogu:
`getfacl /sciezka/do/pliku/lub/katalogu`

Aby znaleźć wszystkie pliki w systemie, które mają ustawione ACL, trzeba przeskanować całe drzewo katalogów:

`getfacl -R -s -p / | grep "^# file"`

## Bezpieczeństwo SSH

Skróty (odciski palców) kluczy publicznych możemy odczytać lokalnie poleceniem:

`ssh-keygen -l -f /sciezka/do/klucza/publicznego`

Przykładowa konfiguracja SFTP (chroot):

```
Match Group sftp
  PasswordAuthentication no
  DisableForwarding yes
  ForceCommand internal-sftp
  ChrootDirectory /srv/sftp
```

Wskazany katalog musi mieć prawodłowo ustawione uprawnienia, reszta systemu plików także - mechanizm chroot nie jest idealnie szczelny.

Klucze będą pobierane z katalogu domowego użytkownika.
Jeśli trzeba po stronie klienta zablokować modyfikację pliku `authorized_keys` można ustawić mu atrybut immutable (`chmod +i`).

Blok Match obejmuje wpisy aż do następnego bloku Match lub do końca pliku.
Najlepiej zatem umieszczać takie bloki na końcu konfiguracji.
Wcięcia nie są interpretowane przez sshd.

### Wybrane parametry konfiguracyjne sshd

`PasswordAuthentication no` - Wyłączenie logowania hasłem.

`X11Forwarding [yes|no]` - Umożliwia/blokuje tunelowanie protokołu X

`AllowTcpForwarding [yes|no|local|remote]` - Forwardowanie ruchu TCP

`GatewayPorts [yes|no]` - Dla tunelowania TCP z serwera zdalnego: pozwala serwerowi na otwarcie portów do tunelowania na wszystkich interfejscach, nie tylko pętli lokalnej `lo` serwera

`PermitOpen adres:port` - Restrykcja dla tuneli inicjowanych po stronie klienta na jaki adres/port docelowy klient może zażądać połączenia

`PermitListen adres:port` - Restrykcja dla tuneli z przyjmowaniem połączeń przez serwer zdalny - na jakich adresach/portach serwer klienta może zażadać nasłuchu

`AllowAgentForwarding [yes|no]` - Umożliwia/blokuje forwardowanie (tunelowanie) połączenia do agenta SSH

`AllowStreamLocalForwarding [yes|no]` - umożliwia/blokuje forwardowanie gniazd (ang. unix sockets) funkcja dość podobna do forwardowania TCP w obie strony dla intrfejsów `lo`

`DisableForwarding yes` - wyłączenie wszystkich mechanizmów forwardowania

### Plik authorized_keys

Przykład klucza publicznego z dodatkowymi ograniczeniami:
`from="10.0.5.5", restrict, command="/usr/local/bin/foo" ssh-ed25519 AAAAf....`

[man sshd AUTHORIZED_KEYS FILE FORMAT](https://linux.die.net/man/8/sshd)

### Certyfikaty SSH

[Certyfikaty SSH](certyfikaty-ssh.md)

## Nmap

`namp -Pn -p0- -sV -T4 host.domena.com` - Skanowanie TCP z zewnątrz

## Ustawienia sysctl związane z bezpieczeństwem

`kernel.dmesg_restrict=1` - Blokuje zwykłym użytkownikom możliwość czytania bufora diagnostyucznego jądra za pomoca dmesg

`kernel.kexec_load_disabled=1` - Wyłącza możliwość załadowania i uruchomienia innego kernela bez restartu.

`kernel.yama.ptrace_scope = 1 lub 3` - Ograniczenie działania `ptrace()`.
0 - brak ograniczeń
1 - tylko procesy potommne (uruchomione przez debugger)
2 - debugger moze dzialac tylko jako root lub z capability CAP_SYS_PTRACE
3 - całkowita blokada (do zmianny konieczny jest restart systemu)

`kernel.unprivileged_bpf_disabled = 1` - Ogranicza prawo użycia eBPF tylko do uprzywilejowanych (root lub posiadacze capability `CAP_BPF`). Po włączeniu nie można zdjąc ograniczenia bez restartu.

`net.core.bpf_jit_harden = 2` - Włącza hardening kompilatora JIT dla programów BPF ładowanych do jadra.
1 - tylko przez nieuprzywilejowanych użytkowników
2 - przez wszystkich

`net.ipv4.tcp_syncookies=1` - Ochrona przed atakami TCP SYN-flood

## Inne

* Pliki mające ustawione prawa setuid/setgid `find / -type f -perm /u+s,g+s`. Jądro Linux dla bezpieczeństwa ignoruje setuid ustawiony dla skryptów.

* Zainstalować pakiet aktualizujący mikrokod CPU, właściwy dla producenta procesora (w zależności od dystrybucji: intel-microcode/intel-ucode albo amd-microcode/amd-ucode).

## Książki

Praca zbiorowa, _Wprowadzenie do bezpieczeństwa IT - Tom 2_, Securitum
