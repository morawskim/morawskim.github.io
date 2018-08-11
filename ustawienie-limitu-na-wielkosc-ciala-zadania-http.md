# Ustawienie limitu na wielkość ciała żadania HTTP

## Apache
Domyślnie wartość parametru `LimitRequestBody` jest ustawiona na 0. Czyli bez limitu.
Parametr ten możemy ustawić w różnych kontekstach (vhost, Location itp.) - http://httpd.apache.org/docs/2.4/mod/core.html#limitrequestbody

```
<VirtualHost *:8000>
...
    LimitRequestBody 1048576
    # 5 MB
    <Location /upload>
        LimitRequestBody 5242880
    </Location>
...
</VirtualHost>

```

## Nginx
Domyślna wartość parametru `client_max_body_size` wynosi 1M - http://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size.

```
server {
....
    client_max_body_size 1m;

    location /upload {
        client_max_body_size 20m;
    }
...
```

