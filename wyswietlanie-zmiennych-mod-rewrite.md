# Wyświetlanie zmiennych mod_rewrite

W katalogu `DOCUMET_ROOT` tworzymy plik `.htaccess` z zawartością:
```
RewriteEngine on
RewriteRule .* - [E=DUMP_REQUEST_URI:%{REQUEST_URI}]
Header set X-FOO "%{DUMP_REQUEST_URI}e"
```

Używamy programu curl do wyświetlenia nagłówków HTTP.
``` bash
❯ curl -v http://127.0.0.1:8000/
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to 127.0.0.1 (127.0.0.1) port 8000 (#0)
> GET / HTTP/1.1
> Host: 127.0.0.1:8000
> User-Agent: curl/7.60.0
> Accept: */*
>
< HTTP/1.1 200 OK
< Date: Tue, 07 Jan 2020 18:24:55 GMT
< Server: Apache/2.4.25 (Debian)
< Last-Modified: Tue, 07 Jan 2020 18:19:55 GMT
< ETag: "77-59b90d2a536e9"
< Accept-Ranges: bytes
< Content-Length: 119
< Vary: Accept-Encoding
< X-FOO: /index.html
< Content-Type: text/html
<
<html>
  <head>
    <title></title>
    <meta content="">
    <style></style>
  </head>
  <body>index!!</body>
</html>
* Connection #0 to host 127.0.0.1 left intact
```

Jak widzimy wartość nagłowka `X-FOO` wynosi `/index.html`.
Dzięki temu możemy debugować nasze złożone reguły `mod_rewrite`.
Lista zmienncyh:
* https://httpd.apache.org/docs/current/expr.html#vars
* https://www.cheatography.com/davechild/cheat-sheets/mod-rewrite/
