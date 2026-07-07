# Automatyczne aktualizacje w systemach Linux

## APT

Ubuntu dostarcza domyślną konfigurację unattended-upgrades w pliku: `/etc/apt/apt.conf.d/50unattended-upgrades`.

APT odczytuje pliki z katalogu `/etc/apt/apt.conf.d/` w kolejności alfabetycznej.
Wartości z później wczytanych plików nadpisują wcześniejsze.

Zamiast modyfikować domyślny plik, lepiej utworzyć własny, np.: `99-unattended-upgrades`
Dzięki temu zmiany nie zostaną nadpisane podczas aktualizacji.

Jeżeli chcemy otrzymywać powiadomienia e-mail o wykonanych aktualizacjach, należy skonfigurować następujące opcje:

```
Unattended-Upgrade::Mail "user@example.com";
Unattended-Upgrade::MailReport "on-change";
```

Domyślną wartością `Unattended-Upgrade::MailReport` jest `on-change`.
W praktyce jednak zdarzyło mi się, że usługa `apt-daily-upgrade.service`, uruchamiająca skrypt:
`/usr/lib/apt/apt.systemd.daily install`
nie wysyłała wiadomości e-mail mimo domyślnej wartości.
Jawne ustawienie: `Unattended-Upgrade::MailReport "on-change";` rozwiązało problem.

Domyślnie w konfiguracji `Unattended-Upgrade::Allowed-Origins` włączone są aktualizacje z repozytorium bezpieczeństwa (-security), natomiast pozostałe wpisy są zakomentowane.

Po odkomentowaniu odpowiednich wpisów unattended-upgrades będzie instalował również aktualizacje z innych release pockets, np. -updates.

Przykładowa konfiguracja:

```
Unattended-Upgrade::Allowed-Origins {
 "${distro_id}:${distro_codename}";
  "${distro_id}:${distro_codename}-security";
  // Extended Security Maintenance; doesn't necessarily exist for
  // every release and this system may not have it installed, but if
  // available, the policy for updates is such that unattended-upgrades
  // should also install from here by default.
  "${distro_id}ESMApps:${distro_codename}-apps-security";
  "${distro_id}ESM:${distro_codename}-infra-security";
  "${distro_id}:${distro_codename}-updates";
  //"${distro_id}:${distro_codename}-proposed";
  //"${distro_id}:${distro_codename}-backports";
};
```

Jeżeli chcemy automatycznie aktualizować pakiety pochodzące z dodatkowego repozytorium APT (np. gitlab-runner), należy dodać jego Origin do `Unattended-Upgrade::Allowed-Origins`.

Najpierw sprawdzamy informacje o repozytoriach: `apt-cache policy`.

Przykładowy wynik:

```
 500 https://packages.gitlab.com/runner/gitlab-runner/ubuntu jammy/main all Packages
     release v=1,o=packages.gitlab.com/runner/gitlab-runner,a=jammy,n=jammy,l=gitlab-runner,c=main,b=all
     origin packages.gitlab.com
 500 https://packages.gitlab.com/runner/gitlab-runner/ubuntu jammy/main amd64 Packages
     release v=1,o=packages.gitlab.com/runner/gitlab-runner,a=jammy,n=jammy,l=gitlab-runner,c=main,b=amd64
     origin packages.gitlab.com

```

Interesuje nas wartość pola o= (Origin). W tym przypadku jest to:
`packages.gitlab.com/runner/gitlab-runner`

Kodową nazwę dystrybucji (jammy, pole n=jammy) można zastąpić zmienną `${distro_codename}`.
Do `Unattended-Upgrade::Allowed-Origins` należy dodać wpis:
`"packages.gitlab.com/runner/gitlab-runner:${distro_codename}";`

[Rola ansible automaticPackageUpdate](https://github.com/morawskim/provision-dev-servers/tree/master/server/ansible/roles/automaticPackageUpdate)

### Przydatne polecenia

Sprawdzenie efektywnej konfiguracji: `apt-config dump | grep -i unattended`

Test działania bez instalowania aktualizacji: `sudo unattended-upgrades --dry-run -v`. Opcja `--debug` wyświetla szczegółowe informacje o podejmowanych decyzjach.

Log działania unattended-upgrades: `less /var/log/unattended-upgrades/unattended-upgrades.log`

Log operacji wykonywanych przez dpkg podczas instalacji aktualizacji: `less /var/log/unattended-upgrades/unattended-upgrades-dpkg.log`
