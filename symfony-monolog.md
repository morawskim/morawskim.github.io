# Symfony Monolog

## Logowanie do strumienia stderr

Monolog domyślnie zapisuje logi do pliku `%kernel.logs_dir%/%kernel.environment%.log`. Uruchamiając aplikację Symfony w kontenerze chcemy logować błędy do strumienia błędów, który przechwyci docker. Wystarczy, że w plikach konfiguracyjnych monolog, zmienimy wartość parametru `path` handlera na `php://stderr`. Jeśli korzystamy z obrazu `php:7.3-fpm` nie musimy konfigurować `php-fpm`. Obraz ten zawiera plik konfiguracyjny `/usr/local/etc/php-fpm.d/docker.conf`, który odpowiednio konfiguruje usługę  `php-fpm` i pulę `www`. W innym przypadku będziemy musieli dokonać tych zmian samemu. Parametr `decorate_workers_output` jest dostępny od PHP 7.3. Dla starszej wersji PHP istnieją obejścia tego problemu.

```
[global]
error_log = /proc/self/fd/2

; https://github.com/docker-library/php/pull/725#issuecomment-443540114
log_limit = 8192

;....

; Ensure worker stdout and stderr are sent to the main error log.
catch_workers_output = yes
decorate_workers_output = no
```

[Logging in Symfony and the Cloud](https://symfony.com/blog/logging-in-symfony-and-the-cloud)

[Logging PHP < 7.3](https://github.com/kibatic/symfony-docker#logging-php--73-1)

[Logs to stdout get prefixed with warning in php-fpm image #207](https://github.com/docker-library/php/issues/207)

[Docker and php-fpm truncated logs workaround and configuration for php](https://ypereirareis.github.io/blog/2019/07/30/php-fpm-truncated-log-workaround-solution-trick/)

## Dostrojenie konfiguracji nginx

Serwer HTTP `nginx` generuje unikalny identyfikator żądania. Możemy go przekazać do PHP, lub ustawić w nagłówku HTTP, kiedy nginx pełni rolę serwera proxy.

```
# przekazanie do PHP
fastcgi_param HTTP_X_REQUEST_ID $request_id;

# ustawienie nagłówka X-Request-Id
proxy_set_header X-Request-Id $request_id;
```
