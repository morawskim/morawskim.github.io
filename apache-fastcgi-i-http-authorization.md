# Apache, fastcgi (PHP-FPM) i HTTP Authorization

Gdy PHP działa przez moduł `mod_proxy_fcgi` Apache (np. z PHP-FPM), nagłówki autoryzacji nie są przekazywane do aplikacji. W takim przypadku należy dodać następującą dyrektywę konfiguracji:

`RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]`

W przypadku braku modułu `mod_rewrite` (wymaga `mod_setenvif`):
`SetEnvIf Authorization "(.*)" HTTP_AUTHORIZATION=$1`
