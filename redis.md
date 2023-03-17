# Redis

## Klucze bez daty wygaśnięcia

W aplikacji legacy pojawiał się problem z ilością kluczy używanych przez Redis.
Aplikacja wykorzystywała Symfony 3.4 i Doctrine.
Metadane encji Doctrine były przechowywane w bazie Redis.

Wywołanie komendy `INFO` w konsoli Redis, zwróciło liczbę używanych kluczy - ponad 48K. 
Do wylistowania wszystkich istniejących kluczy w bazie Redis używamy polecenia: `redis-cli --scan --pattern '*' -h redis`.
Po posortowaniu ich po nazwie zobaczyłem, że większość z nich zawiera frazę `*CLASSMETADATA]\[*`
Konfiguracja Symfony używała cache Redis (przez bundle) do przechowywania metadanych Doctrine. Po sprawdzeniu kodu Doctrine okazało się, że czyszczenie metadanych nie powoduje skasowania kluczy w Redis, a jedynie aktualizację klucza `DoctrineNamespaceCacheKey`, który przechowywał numer wersji.

Sprawdziłem jaki jest czas ważności dla pozostałych kluczy. Przefiltrowałem listę wszystkich kluczy Redis - łatwo było dostrzec pewne wzorce i je wyeliminować.
Dla pozostałych postanowiłem sprawdzić czas wygaśnięcia.
Redis posiada polecenie `TTL`, które umożliwia nam wyświetlenie pozostałego czasu do wygaśnięcia danego klucza - zwraca wartość -1 jeśli klucz nie wygasa i -2 jeśli klucz nie istnieje.
Za pomocą polecenia sed do każdej linii z kluczem Redis dodałem polecenie TTL i taki plik przekazałem do polecenia redis-cli.
Wynik połączyłem i przefiltrowałem, aby zwrócone zostały tylko klucze bez daty wygaśnięcia -  `join <(cat redis-keys | sed 's/^/TTL /' | cat -n) <(cat redis-keys | sed 's/^/TTL /' | redis-cli -h redis | cat -n ) | awk '$4 == "-1"'`

## Przydatne polecenia

`redis -p 6389 flushall` - Usuwa wszystkie klucze ze wszystkich baz danych (nie tylko wybranej)
