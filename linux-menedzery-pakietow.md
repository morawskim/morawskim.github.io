# Linux - menedżery pakietów

Menedżery pakietów automatyzują procesy instalacji, aktualizacji oraz usuwania oprogramowania w systemach Linux. Podstawowe formaty pakietów w Linuksie to `deb` i `RPM`. Do zarządzania  bazą pakietów służą odpowiednio narzędzia `dpkg` i `rpm`. Jednak najczęściej będziemy korzystać z narzędzi `apt-get`, `zypper`, `yum` czy też `dnf`. Oferują one zarządzanie zależnościami, co pozwala ograniczyć efekt `dependency hell`.

## Wyświetl wszystkie dostępne wersje pakietu

| Narzędzie  | Komenda  |
|---|---|
| apt-get  | `apt-cache madison <package>`  |
| zypper  | `zypper search --details --match-exact  <package>`  |


## Instalacja określonej wersji pakietu

| Narzędzie  | Komenda  |
|---|---|
| apt-get  | `apt-get install <package>=<version>`  |
| zypper  | `zypper in -f <package>-<version>`  |

## dpkg vs rpm

|   | rpm  | dpkg  |
|---|---|---|
| Zapytanie o pakiet będący właścicielem pliku  | `rpm -qf <path>`  | `dpkg -S <path>`  |
| Wyświetl listę plików w pakiecie  | `rpm -ql <package>`  | `dpkg -L <package>`  |

## APT pinning

Kiedy do systemu dodamy wiele repozytoriów, pakiet może istnieć w wielu z nich. Ten przypadek występuje, kiedy dodamy repozytorium gitlab. Domyślnie debian i ubuntu zawierają już pakiet `gitlab-runner`.
Korzystając z polecenia `apt-cache policy` dowiemy się z którego repozytorium zostanie zainstalowany pakiet. Apt na podstawie priorytetów wybierze, z którego repozytorium zainstalować pakiet (jeśli w poleceniu nie podamy jawnie parametru `-t <nazwa repo>`).

Proces pinning pozwala nam na zmianę priorytetów (domyślnie to 500) dla wybranych pakietów lub całych repozytoriów.
Algorytm wyboru pakietu działa następująco:
* jeśli pakiety mają ten sam priorytet, pakiet z wyższym numerem wersji (najnowszym) wygrywa
* jeśli pakiety mają różne priorytety, wygrywa ten z wyższym priorytetem

Aby zmienić priorytety pakietu `gitlab-runner` i preferować repozytorium gitlab, tworzymy plik `/etc/apt/preferences.d/gitlab-runner.pref` o zawartości:
```
Explanation: Prefer GitLab provided packages over the Debian native ones
Package: gitlab-runner
Pin: origin packages.gitlab.com
Pin-Priority: 1001
```

Wywołując polecenie `apt-cache policy <package>` dostaniemy wynik podobny do poniższego:
```
gitlab-runner:
  Installed: (none)
  Candidate: 12.10.1
  Version table:
     12.10.1 1001
        500 https://packages.gitlab.com/runner/gitlab-runner/ubuntu bionic/main amd64 Packages
```

Widzimy w nim informację o priorytetach i kandydacie do instalacji. W przypadku braku pliku `/etc/apt/preferences.d/gitlab-runner.pref` wynik będzie inny (ustawiony zostanie domyślny priorytet):
```
gitlab-runner:
  Installed: (none)
  Candidate: 12.10.1
  Version table:
     12.10.1 500
        500 https://packages.gitlab.com/runner/gitlab-runner/ubuntu bionic/main amd64 Packages
```

Aby wyświetlić priorytet dla każdego repozytorium korzystamy z polecenia `apt-cache policy`.

[AptConfiguration](https://wiki.debian.org/AptConfiguration)

[Gitlab APT pinning](https://docs.gitlab.com/runner/install/linux-repository.html#apt-pinning)
