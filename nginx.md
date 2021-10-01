# NGINX

## Cache

Serwer HTTP NGINX może także pełnić role serwera cache. Cache HTTP daje nam bardzo duży wzrost wydajności. W teście `wrk` trwającym 30s jesteśmy w stanie zwiększyć przepustowość przeszło 1000 razy - `wrk -t2 -c 10 -d30s -H'X-Sales-Channel: pl'  --latency http://IP_ADDRESS_OR_DOMAIN_NAME/api/sales-channel`.

Aby włączyć cache HTTP tworzymy standardową konfigurację vhost. Musimy jedynie dodać dwie dyrektywy `proxy_cache_path` i `proxy_cache`. Bardzo dobry opis dyrektyw i wstępu do HTTP Cache jest dostępny na blogu NGINX - [A Guide to Caching with NGINX and NGINX Plus](https://www.nginx.com/blog/nginx-caching-guide/).

```
proxy_cache_path /var/cache/nginx/http-cache levels=1:2 keys_zone=my_cache:10m max_size=11m
                 inactive=60m use_temp_path=off;

server {
  listen 80 default_server;
  server_name _;
  server_tokens off;

  location / {
    proxy_cache my_cache;
    proxy_cache_revalidate on;
    proxy_cache_min_uses 1;
    proxy_cache_use_stale error timeout updating http_500 http_502
                          http_503 http_504;
    proxy_cache_background_update on;
    proxy_cache_lock on;

    proxy_pass http://IP_ADDRESS_OR_DOMAIN_NAME;
    add_header X-Cache-Status $upstream_cache_status;
  }
}
```

W frameworku Symfony mając zainstalowany pakiet `sensio/framework-extra-bundle` możemy skorzystać z adnotacji `Cache` do konfiguracji Cache HTTP. Jednak NGINX buforuje odpowiedź serwera tylko przy spełnieniu warunku:

>NGINX caches a response only if the origin server includes either the Expires header with a date and time in the future, or the Cache-Control header with the max-age directive set to a non‑zero value.

Oznacza to że w konfiguracji adnotacji `Cache`ustawiamy atrybut `maxage` a nie `expires` -  `@Cache(maxage="3600", public=true, vary={"X-Sales-Channel"})`. W przeciwnym przypadku NGINX nie zbuforuje odpowiedzi.

Warto mieć dyrektywę `add_header X-Cache-Status $upstream_cache_status;`. Dzięki temu będziemy mogli łatwo śledzić, czy response została pobrana z pamięci podręcznej, czy z serwera upstream.

NGINX pomimo że trzyma cache na dysku to używane dane przenosi do pamięci RAM. Tworzenie tzw. ramdysku nie ma więc większego znaczenia.

[High‑Performance Caching with NGINX and NGINX Plus](https://www.nginx.com/blog/nginx-high-performance-caching/)

## PHP-FPM - upstream sent too big header while reading response header from upstream

Po instalacji i włączeniu pakietu `symfony/profiler-packer` otrzymywałem w odpowiedzi kod `502 Bad Gateway`.
W logach był wpis `[error] 29#29: *6 upstream sent too big header while reading response header from upstream`.
W konfiguracji nginx w bloku `location`, który zawiera konfigurację dla PHP dodałem dwie dodatkowe dyrektywy zwiększające rozmiary buforów.

```
# [error] 29#29: *6 upstream sent too big header while reading response header from upstream
fastcgi_buffer_size 32k;
fastcgi_buffers 8 16k;
```
