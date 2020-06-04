# nginx - php-fpm

## upstream sent too big header while reading response header from upstream

Po instalacji i włączeniu pakietu `symfony/profiler-packer` otrzymywałem w odpowiedzi kod `502 Bad Gateway`.
W logach był wpis `[error] 29#29: *6 upstream sent too big header while reading response header from upstream`.
W konfiguracji nginx w bloku `location`, który zawiera konfigurację dla PHP dodałem dwie dodatkowe dyrektywy zwiększające rozmiary buforów.

```
# [error] 29#29: *6 upstream sent too big header while reading response header from upstream
fastcgi_buffer_size 32k;
fastcgi_buffers 8 16k;
```
