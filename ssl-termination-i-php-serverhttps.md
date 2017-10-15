# SSL termination i PHP $_SERVER['HTTPS']

Jeśli przed naszym serwerem HTTP znajduje się proxy, które ma za zadanie rozszyfrowanie ruchu SSL to w PHP w zmiennej serwerowej `$_SERVER['HTTPS']` nie będzie informacji o tym, że połaczenie było szyfrowane.

W przypadku projektu, który "na sztywno" sprawdza wartość tej zmiennej, możemy ten problem roziwązać przez ustawienie tej zmiennej przez serwer HTTP Apache.

W tym przypadku bazując na wartości nagłówka `X-Forwarded-SSL` ustawiania jest zmienna serwera PHP `$_SERVER['HTTPS']` na wartośc `on`.
```
RewriteEngine on
RewriteCond %{HTTP:X-Forwarded-SSL} ^on$
RewriteRule (.*) - [E=HTTPS:on]
```

