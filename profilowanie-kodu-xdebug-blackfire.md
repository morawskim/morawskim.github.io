# Profilowanie kodu Xdebug/Blackfire

## Xdebug

Aby profilować kod za pomocą Xdebug musimy ustawić opcję `xdebug.profiler_enable_trigger` na wartość 1. Dzięki temu wysyłając ciasteczko `XDEBUG_PROFILE` lub parametr GET/POST o takim kluczu włączymy profiler.

W odpowiedzi HTTP dostaniemy nagłówek `X-Xdebug-Profile-Filename` z wartością, gdzie zapisał się nasz plik do dalszej analizy. Przy domyślnej konfiguracji będzie to katalog `/tmp`. Jednak jeśli korzystamy z serwera apache i systemd to katalog `/tmp` dla tej usługi może być ukryty. Wywołując polecenie `systemctl cat apache2.service` w konfiguracji jednostki `Service` zobaczymy `PrivateTmp=true`. Plik profilera zapisze się w jednym z katalogów `/tmp/systemd-private-*`. Jeśli profilujemy skrypt CLI to możemy skorzystać z funkcji `xdebug_get_profiler_filename` do pobrania nazwy pliku.

Profilując kod na zdalnym serwerze, nie będziemy mieć takich samych ścieżek do plików. W ustawieniach KCacheGrind musimy dodać katalog z projektem - `Ustawienia` -> `Ustawienia KCachegrind`. Przechodzimy do zakładki `Komentarze` i dodajemy katalog do `Katalogi źródłowe`. W KCacheGrind jedna jednostka czasu to 1/1 000 000 sekundy.

[Profiling PHP Scripts](https://xdebug.org/docs/profiler)

## Blackfire

Aby profilować kod za pomocą usługi blackfire potrzebujemy rozszerzenia PHP (tzw. probe) `blackfire`, a także agenta i klienta. W przypadku korzystania z kontenerów dockera, dodajemy konfigurację nowej usługi:
```
blackfire:
    image: blackfire/blackfire
    environment:
        BLACKFIRE_SERVER_ID: ~
        BLACKFIRE_SERVER_TOKEN: ~
        BLACKFIRE_LOG_LEVEL: 1
```

Zmienne środowiskowe `BLACKFIRE_SERVER_ID` i `BLACKFIRE_SERVER_TOKEN` powinniśmy mieć zdefiniowane w naszym pliku `.env`. Chcąc wyświetlać komunikaty diagnostyczne agenta, możemy ustawić zmienną środowiskową `BLACKFIRE_LOG_LEVEL` na wartośc  `4`. Będąc na kontenerze agenta, możemy wywołać polecenie `blackfire-agent -d`, aby wyświetlić konfigurację.

Instalacja rozszerzenia PHP w pliku Dockerfile opisana jest [w dokumentacji](https://blackfire.io/docs/integrations/docker/php-docker). Musimy pobrać rozszerzenie, umieścić je w katalogu `extension_dir` i utworzyć plik ini. Plik ten załaduje rozszerzenie `blackfire` i ustawi parametr `blackfire.agent_socket` na adres agenta.

Jeśli chcemy także profilować skrypty PHP lub żadania AJAX to niezbędny jest zainstalowanie narzędzia CLI blackfire i ustawienie zmiennych środowiskowych `BLACKFIRE_CLIENT_ID` i `BLACKFIRE_CLIENT_TOKEN`. [W dokumentacji](https://blackfire.io/docs/integrations/docker/php-docker#using-the-client-for-cli-profiling) opisano niezbędne kroki. Możemy także korzystając z [instrukcji instalacji](https://blackfire.io/docs/up-and-running/installation?action=install&mode=full&location=local&os=manual&language=php&agent=5fdd5ccf-b9eb-49a1-b965-3c6d9370815f) pobrać bezpośrednio klienta CLI.

### Troubleshooting

Kiedy korzystamy z rozszerzenia Blackfire w przeglądarce, do strony dołączany jest iframe Blackfire. Jeśli na stronie zdefiniowaliśmy `Content Security Policy` to iframe może zostać zablokowany. W takim przypadku musimy zadeklarować domenę `blackfire.io` jako zaufaną - `Content-Security-Policy: frame-src 'self' blackfire.io`.

