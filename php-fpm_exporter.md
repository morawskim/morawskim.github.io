# php-fpm_exporter

[php-fpm_exporter](https://github.com/hipages/php-fpm_exporter) udostępnia metryki z serwera PHP-FPM w formacie zrozumiałym dla Prometheusa.

Domyślnie PHP-FPM nie udostępnia informacji o statusie procesów. Aby je włączyć, możemy dodać osobny plik konfiguracyjny dla PHP-FPM i zmodyfikować ustawienia wybranej puli (np. www), tak aby status był dostępny pod adresem 127.0.0.1:9001/status, jak w poniższym przykładzie:

```
[www]
pm.status_listen = 127.0.0.1:9001
pm.status_path = /status

```

Przykładowy docker-compose do testów konfiguracji php-fpm

```
services:
  caddy:
    image: caddy:2.10
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - ./webroot/:/srv/www
    ports:
    - 8080:80
  php:
    image: php:8.4-fpm
    volumes:
      - ./webroot/:/srv/www
      - ./php-fpm-www.conf:/usr/local/etc/php-fpm.d/zz-php-fpm-www.conf
```

Caddyfile:

```
http://localhost:80 http://127.0.0.1:80 {
    root * /srv/www
    encode gzip zstd

    php_fastcgi php:9000
    file_server
}

```

Przykładowy docker-compose dla php-fpm_exporter

```
services:
  php-fpm_exporter:
    image: hipages/php-fpm_exporter:2.2
    environment:
      PHP_FPM_SCRAPE_URI: "tcp://ip-or-domain-name:9001/status"
      #PHP_FPM_FIX_PROCESS_COUNT: 1
    ports:
      - "9253:9253"
```

Jeśli mamy zainstalowany plik binarny, możemy również uruchomić: `php-fpm_exporter server --phpfpm.scrape-uri 'tcp://127.0.0.1:9001/status'`

Następnie poleceniem: `curl -s localhost:9253/metrics | grep phpfpm_up` możemy sprawdzić, czy metryki PHP-FPM są dostępne.

## Unix socket

Możemy komunikować się z PHP-FPM nie przez TCP (adres IP + port), lecz przez gniazdo Unix.
W przypadku domyślnego obrazu php:8.4-fpm wymaga to zmiany konfiguracji PHP-FPM, tak aby proces nasłuchiwał na gnieździe Unix zamiast na porcie TCP.
Przykładowy plik modyfikujący pule www, który wymusza nasłuchiwanie na gnieździe Unix:

```
[www]
listen = /usr/local/var/run/php-fpm.sock
listen.owner = www-data
listen.group = www-data
listen.mode = 0666
pm.status_path = /status

```

Plik docker-compose

```
services:
  caddy:
    image: caddy:2.10
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - ./webroot/:/srv/www
      - ./socket:/socket
    ports:
    - 8080:80
  php:
    image: php:8.4-fpm
    volumes:
      - ./webroot/:/srv/www
      - ./php-fpm-www.conf:/usr/local/etc/php-fpm.d/zz-php-fpm-www.conf
      - ./socket:/usr/local/var/run

```

Caddyfile:

```
http://localhost:80 http://127.0.0.1:80 {
    root * /srv/www
    encode gzip zstd

    php_fastcgi unix//socket/php-fpm.sock
    file_server
}

```

Jeśli mamy zainstalowany plik binarny eksportera, możemy go uruchomić: `php-fpm_exporter_2.2.0_linux_amd64  server --phpfpm.scrape-uri 'unix:///sciezka/do/pliku/gniazda/php-fpm.sock;/status'`

Następnie poleceniem: `curl -s localhost:9253/metrics | grep phpfpm_up` możemy sprawdzić, czy metryki PHP-FPM są dostępne.

[Access denied when trying to use PHP unix sock #316](https://github.com/hipages/php-fpm_exporter/issues/316#issuecomment-2549720042)

## Funkcja fpm_get_status

Funkcja `fpm_get_status` służy do pobrania bieżących danych o stanie PHP-FPM.

[PHP-FPM real-time status page (Single file without the need for web server configuration)](https://gist.github.com/EhsanCh/97187902e905a308ce434bda6730073c)
