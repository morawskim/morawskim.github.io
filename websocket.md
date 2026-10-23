# Websocket

## websocat

W projekcie wykorzystywaliśmy protokół WebSocket do rozgłaszania postępu wykonywania zadań w kolejce.

Za pomocą narzędzia [websocat](https://github.com/vi/websocat) chciałem połączyć się z serwerem WebSocket i monitorować przesyłąne wiadomości.

Możemy w tym celu wykorzystać obraz kontenera - `docker run --rm -ti ghcr.io/vi/websocat:nightly -v ws://127.0.0.1:9500`

Jeśli serwer WebSocket wymaga szyfrowanego połączenia, a chcemy zignorować ewentualne problemy z certyfikatem, możemy skorzystać z opcji `-k/--insecure`

Po nawiązaniu połączenia powinniśmy otrzymać komunikat potwierdzający:
```
[INFO  websocat::lints] Auto-inserting the line mode
[INFO  websocat::stdio_threaded_peer] get_stdio_peer (threaded)
[INFO  websocat::ws_client_peer] get_ws_client_peer
[INFO  websocat::net_peer] Connected to TCP 127.0.0.1:9500
[INFO  websocat::ws_client_peer] Connected to ws, response headers: Headers { Upgrade: websocket
, Connection: Upgrade
, Sec-Websocket-Accept: XXXXXXXXXXXXXXXXXXXx
, Sec-Websocket-Version: 13
, Sec-Websocket-Protocol: XXXXXXXXXXXXXx
, Server: XXXXXXXXXXXXXXXXXXXX
, Date: Fri, 23 Oct 2026 16:15:00 GMT
, }
```

Możemy teraz wysłać wiadomość, wpisując ją bezpośrednio w konsoli lub wklejając gotową treść.
Odpowiedź serwera zostanie wyświetlona na ekranie.
