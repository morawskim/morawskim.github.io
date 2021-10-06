# Docker i PHP

## GD - JPEG not supported

W projekcie wykorzystywałem obraz `php:7.4-fpm`. Za pomocą apt-get w `Dockerfile` instalowałem dodatkowe pakiety do obsługi różnych formatów plików graficznych:
```
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libjpeg-dev libpng-dev libfreetype6-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
```

Następnie wywoływałem standardowe polecenia instalacji rozszerzenia PHP w kontenerze docker

```
RUN docker-php-ext-configure gd \
    && docker-php-ext-install gd
```

Jednak mimo tego wywołując polecenie `php -r 'print_r(gd_info());'` otrzymałem:

```
Array
(
    [GD Version] => bundled (2.1.0 compatible)
    [FreeType Support] =>
    [GIF Read Support] => 1
    [GIF Create Support] => 1
    [JPEG Support] =>
    [PNG Support] => 1
    [WBMP Support] => 1
    [XPM Support] =>
    [XBM Support] => 1
    [WebP Support] =>
    [BMP Support] => 1
    [TGA Read Support] => 1
    [JIS-mapped Japanese Font Support] =>
)
```

Ten problem dotknął nie tylko mnie - [gd has unrecognized options in PHP 7.4 #912](https://github.com/docker-library/php/issues/912). Dodając parametr `--with-jpeg` do polecenia `docker-php-ext-configure gd` skompilujemy rozszerzenie PHP z obsługą jpeg - `docker-php-ext-configure gd --with-jpeg`.

```
Array
(
    [GD Version] => bundled (2.1.0 compatible)
    [FreeType Support] =>
    [GIF Read Support] => 1
    [GIF Create Support] => 1
    [JPEG Support] => 1
    [PNG Support] => 1
    [WBMP Support] => 1
    [XPM Support] =>
    [XBM Support] => 1
    [WebP Support] =>
    [BMP Support] => 1
    [TGA Read Support] => 1
    [JIS-mapped Japanese Font Support] =>
)
```

## Redis

Potrzebowałem do obrazu PHP (`php:7.3-apache`) dodać rozszerzenie `redis`.

Wywołałem standardowe polecenie do instalacji rozszerzeń PHP - `pecl install redis`.
Jednak podczas wywołania tego polecenia musimy odpowiedzieć na parę pytań.
Musiałem więc przekazać niezbędne odpowiedzi. Rozwiązaniem jest wywołanie polecenia powłoki `echo` - `echo -e "no\nno\nno\n" | pecl install redis`.

Dzięki temu przekazałem skryptowi `./configure` informację, że nie chce włączać wsparcia dla `igbinary`, a także kompresji lzf i zstd. Możemy zmieniać wartość według uznania włączając wsparcie dla niektórych funkcjonalności.
Na wyjściu pojawi się linia z naszymi wybranymi ustawieniami: `running: /tmp/pear/temp/redis/configure --with-php-config=/usr/local/bin/php-config --enable-redis-igbinary=no --enable-redis-lzf=no --enable-redis-zstd=no `.

Po kompilacji musimy jeszcze włączyć rozszerzenie. Możemy skorzystać z multistage build. Ścieżka do pliku z rozszerzeniem pojawi się na ekranie - `Installing '/usr/local/lib/php/extensions/no-debug-non-zts-20180731/redis.so'`.
Następnie musimy skonfigurować PHP do załadowania rozszerzenia redis - `echo "extension=redis.so" | tee /usr/local/etc/php/conf.d/redis.ini`.

Po tych krokach nasz obraz, będzie zawierał rozszerzenie PHP `redis`.
