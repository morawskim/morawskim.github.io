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
  php:
    image: yiisoftware/yii2-php:8.4-fpm-nginx
    volumes:
      - ./index.php:/app/web/index.php
      - ./99-www.conf:/usr/local/etc/php-fpm.d/99-www.conf
    ports:
      - "5000:80"
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

## Funkcja fpm_get_status

Funkcja `fpm_get_status` służy do pobrania bieżących danych o stanie PHP-FPM.

[PHP-FPM real-time status page (Single file without the need for web server configuration)](https://gist.github.com/EhsanCh/97187902e905a308ce434bda6730073c)
