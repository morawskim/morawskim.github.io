# Problem z ausearch w cronie

W ramach prac porządkowych oraz przygotowania aplikacji na nadchodzące zmiany chcieliśmy przenieść wykonywanie cronów z serwera aplikacyjnego na inny serwer.
Chcieliśmy jednak upewnić się, że przeniesienie tych zadań nie spowoduje problemów.
Na przykład sytuacji, w której któreś z istniejących zadań tworzy plik pobierany później przez użytkownika po zalogowaniu do systemu, a plik ten znajduje się na lokalnym dysku zamiast w usłudze S3.

W tym celu skorzystałem z narzędzia strace do monitorowania wywołań systemowych.

`strace -e trace=file -f -y php ./write-file.php 2>&1 | grep -vE '"(/usr/|/etc/|/lib64/|/proc/|sys/|/dev/|/bin/|/sbin/|/var/www/html/vendor/)' | grep -v '\.php"'`

Przykładowe demo znajduje się [tutaj](https://github.com/morawskim/php-examples/tree/master/strace)

Dodatkowo skonfigurowałem usługę auditd.
Przykładowe demo znajduje się [tutaj](https://github.com/morawskim/devops-projects/tree/main/auditd)

Do crona podłączyłem wywołanie programu `/usr/sbin/ausearch`, który odczytuje logi auditd i przekierowuje wynik do pliku.
Jednak mimo uruchamiania zadania przez cron, docelowy plik nie zawierał oczekiwanych wpisów.

Ten sam problem napotkał również inny użytkownik: [ausearch fails when called from cron script](https://bugzilla.redhat.com/show_bug.cgi?id=2208963#c1)

Podczas wykonywania zadań przez crona `stdin`, `stdout` oraz `stderr` są potokami (pipes).
`ausearch` preferuje odczytywanie danych z potoku, jeśli stdin jest potokiem. W efekcie w pliku pojawiały się jedynie wpisy "<no matches>".

Rozwiązaniem okazało się dodanie parametru `--input-logs`, który zmienia te domyślne zachowanie.

Finalne polecenie do odczytywania logów auditd wygląda następująco:

`/usr/sbin/ausearch --input-logs -i -k var_www_write >> /somewhere/file 2>&1`
