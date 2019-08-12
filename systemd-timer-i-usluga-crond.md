# systemd timer i usługa crond

## crond - logowanie strumieni wyjścia i błędów polecenia do journald

W dystrybucji ubuntu, nie jest instalowany żadne oprogramowanie MTA.
Oznacza to, że strumienie wyjściowe polecenia uruchomionego przez usługę cron nie zostaną przechwycone.
Możemy samemu przesłać strumienie do pliku z logiem, albo skorzystać z `systemd-cat`.
`systemd-cat` łączy wyjście programu z journal.

Przykładowy wpis w `crontab`:
`10 22 * * * systemd-cat -t "<tag>" /home/deployer/bin/dump-mysql.rb`

Następnie za pomocą polecenia `journalctl -t <tag>` możemy przejrzeć zarejestrowane wpisy w dzienniku.

## Automatyczne uruchamianie jednostek użytkownika

Jednostki timer systemd mogą być alternatywą dla usługi `crond`.
Domyślnie użytkownik musi być zalogowany w systemie, aby systemd wywoływał jednostki użytkownika o wskazanej porze dnia. Wynika to z działania usługi. Instancja systemd dla użytkownika jest uruchamiana podczas pierwszego zalogowania i zabijana podczas zamknięcia ostatniej sesji użytkownika.

Jeśli chcemy uruchamiać jednostki użytkownika na serwerze, musimy przekonfigurować systemd. W taki sposób, aby uruchamiał instancję systemd dla wybranego użytkownika, już na starcie systemu. I trzymał ją nawet w momencie, gdy ostatnia sesja z użytkownikiem zostanie zakończona.

Wywołujemy następujące polecenie, aby włączyć tryb lingering:
`loginctl enable-linger <username>`

Efektem wywołania tego polecenia powinno być między innymi utworzenie pliku
`/var/lib/systemd/linger/<username>`

[https://wiki.archlinux.org/index.php/Systemd/User#Automatic_start-up_of_systemd_user_instances](https://wiki.archlinux.org/index.php/Systemd/User#Automatic_start-up_of_systemd_user_instances)
