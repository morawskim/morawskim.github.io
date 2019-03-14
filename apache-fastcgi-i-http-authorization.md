# Apache, fastcgi i HTTP Authorization

Jeśli serwer apache nie korzysta z modułu php, a z fcgi to pojawi się problem z obsługą nagłówka `HTTP_AUTHORIZATION`.
Musimy dodać do pliku vhost lub `.htaccess` poniższą regułą mod-rewrite.

`RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]`
