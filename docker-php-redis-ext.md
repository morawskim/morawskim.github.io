# Docker php-redis extension

Potrzebowałem do obrazu PHP (`php:7.3-apache`) dodać rozszerzenie `redis`.

Wywołałem standardowe polecenie do instalacji rozszerzeń PHP - `pecl install redis`.
Jednak podczas wywołania tego polecenia musimy odpowiedzieć na parę pytań.
Musiałem więc przekazać niezbędne odpowiedzi. Rozwiązaniem jest wywołanie polecenia powłoki `echo` - `echo -e "no\nno\nno\n" | pecl install redis`.

Dzięki temu przekazałem skryptowi `./configure` informację, że nie chce włączać wsparcia dla `igbinary`, a także kompresji lzf i zstd. Możemy zmieniać wartość według uznania włączając wsparcie dla niektórych funkcjonalności.
Na wyjściu pojawi się linia z naszymi wybranymi ustawieniami: `running: /tmp/pear/temp/redis/configure --with-php-config=/usr/local/bin/php-config --enable-redis-igbinary=no --enable-redis-lzf=no --enable-redis-zstd=no `.

Po kompilacji musimy jeszcze włączyć rozszerzenie. Możemy skorzystać z multistage build. Ścieżka do pliku z rozszerzeniem pojawi się na ekranie - `Installing '/usr/local/lib/php/extensions/no-debug-non-zts-20180731/redis.so'`.
Następnie musimy skonfigurować PHP do załadowania rozszerzenia redis - `echo "extension=redis.so" | tee /usr/local/etc/php/conf.d/redis.ini`.

Po tych krokach nasz obraz, będzie zawierał rozszerzenie PHP `redis`.
