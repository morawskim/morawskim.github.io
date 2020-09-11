# Profilowanie kodu Xdebug/Blackfire

## Xdebug

Aby profilować kod za pomocą Xdebug musimy ustawić opcję `xdebug.profiler_enable_trigger` na wartość 1. Dzięki temu wysyłając ciasteczko `XDEBUG_PROFILE` lub parametr GET/POST o takim kluczu włączymy profiler.

W odpowiedzi HTTP dostaniemy nagłówek `X-Xdebug-Profile-Filename` z wartością, gdzie zapisał się nasz plik do dalszej analizy. Przy domyślnej konfiguracji będzie to katalog `/tmp`. Jednak jeśli korzystamy z serwera apache i systemd to katalog `/tmp` dla tej usługi może być ukryty. Wywołując polecenie `systemctl cat apache2.service` w konfiguracji jednostki `Service` zobaczymy `PrivateTmp=true`. Plik profilera zapisze się w jednym z katalogów `/tmp/systemd-private-*`. Jeśli profilujemy skrypt CLI to możemy skorzystać z funkcji `xdebug_get_profiler_filename` do pobrania nazwy pliku.

Profilując kod na zdalnym serwerze, nie będziemy mieć takich samych ścieżek do plików. W ustawieniach KCacheGrind musimy dodać katalog z projektem - `Ustawienia` -> `Ustawienia KCachegrind`. Przechodzimy do zakładki `Komentarze` i dodajemy katalog do `Katalogi źródłowe`. W KCacheGrind jedna jednostka czasu to 1/1 000 000 sekundy.

[Profiling PHP Scripts](https://xdebug.org/docs/profiler)
