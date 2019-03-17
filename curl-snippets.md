# Curl - snippets

## Odpytywanie gniazd Unix z curl

`curl --unix-socket /var/run/docker.sock http:/localhost/images/json`

## Wymuszenie użycia wybranego adresu IP podczas wysyłania żądania

Poniższe polecenie wymusza użycie adresu IP `127.0.0.1` podczas żądania pobrania `www.example.com` przez port http.

`curl http://www.example.com --resolve www.example.com:80:127.0.0.1`
