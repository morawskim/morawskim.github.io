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
