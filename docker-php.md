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
