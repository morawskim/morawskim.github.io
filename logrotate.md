# logrotate

logrotate to narzędzie w systemach Linux, które zarządza logami – rotuje je, kompresuje i usuwa.

## Najczęściej używane dyrektywy konfiguracyjne

| Dyrektywa | Opis |
| - | - |
| `daily` / `weekly` / `monthly` | Częstotliwość rotacji logów |
| `rotate N` | Zachowanie n zrotowanych plików przed usunięciem |
| `compress` | Kompresja zrotowanych plików (gzip) |
| `delaycompress` | Opóźnienie kompresji do następnego cyklu rotacji |
| `notifempty` | Pominięcie rotacji pustych plików |
| `missingok` | Brak błędu, jeśli plik nie istnieje |
| `dateext` | Dodaje datę do nazwy archiwalnych logów zamiast numerów |
| `create <mode> <owner> <group>` | Tworzy nowy pusty plik z określonymi uprawnieniami |
| `copytruncate` | Kopiuje i ucina plik. Istnieje niewielkie ryzyko utraty danych zapisywanych dokładnie w momencie rotacji. Jest to kompromis dla aplikacji, które nie mogą być przeładowane |
| `sharedscripts` | Uruchamia prerotate i postrotate tylko raz na cały blok plików |


Przykład dla serwera httpd z systemu Rocky Linux (`/etc/logrotate.d/httpd`).

```
# Note that logs are not compressed unless "compress" is configured,
# which can be done either here or globally in /etc/logrotate.conf.
/var/log/httpd/*log {
    missingok
    notifempty
    sharedscripts
    delaycompress
    postrotate
        /bin/systemctl reload httpd.service > /dev/null 2>/dev/null || true
    endscript
}
```

## Użyteczne polecenia

Opcja `-d` (`--debug`) pokazuje, co logrotate zrobiłby, ale bez faktycznego wykonywania zmian.

`sudo logrotate -d /etc/logrotate.conf` - Test globalnej konfiguracji

`sudo logrotate -d /etc/logrotate.d/nginx` - Test konkretnego pliku konfiguracyjnego

`sudo logrotate -f /etc/logrotate.conf` - Wymuszenie rotacji wszystkich logów

`sudo logrotate -f /etc/logrotate.d/aplikacja` - Wymuszenie rotacji konkretnej konfiguracji

`cat /var/lib/logrotate/logrotate.status` - Sprawdź stan w pliku stanu

## Kompresja zstd

```
compress
compresscmd /usr/bin/zstd
compressext .zst
compressoptions -T0 --long
uncompresscmd /usr/bin/unzstd
```

## Wiele plików logów w jednym bloku

```
"/var/log/httpd/access.log" /var/log/httpd/error.log {
# ......
}
```

```
/var/log/cron.log
/var/log/debug
/var/log/messages
{
# ...
}
```
