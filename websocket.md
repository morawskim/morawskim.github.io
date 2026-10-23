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

## k6

Do testowania wydajności serwera WebSocket możemy użyć narzędzia Grafana k6.

Przykładowy test:

```
import { WebSocket } from 'k6/websockets';

export const options = {
    vus: 1,
    iterations: 1,
};

const WS_URL = __ENV.WS_URL || 'ws://127.0.0.1:9500';
const CONNECTIONS = 50;

// Min and max lifetime of connection in seconds
const MIN_LIFETIME = 5;
const MAX_LIFETIME = 15;

function randomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}

export default function () {
    for (let i = 0; i < CONNECTIONS; i++) {
        createConnection(i);
    }

    console.log(`Created ${CONNECTIONS} WebSocket connections`);
}

function createConnection(id) {
    const ws = new WebSocket(WS_URL);

    const lifetime = randomInt(MIN_LIFETIME, MAX_LIFETIME);

    ws.onopen = () => {
        console.log(
            `[${id}] WebSocket connected, closing in ${lifetime}s`
        );

        // An example message after a connection has been established.
        ws.send(JSON.stringify({
            // ...
        }));

        setTimeout(() => {
            console.log(`[${id}] Closing WebSocket`);
            ws.close(1000, 'Test finished');
        }, lifetime * 1000);
    };

    ws.onmessage = (event) => {
        console.log(`[${id}] Received: ${event.data.replace(/(\r\n|\n|\r)/gm, "").substring(0, 100)}`);
    };

    ws.onerror = (e) => {
        console.error(`[${id}] WebSocket error: ${e.error()}`);
    };

    ws.onclose = (event) => {
        console.log(
            `[${id}] WebSocket closed, code=${event.code}`
        );
    };
}
```

Możemy go uruchomić, wykorzystując obraz kontenera:

`docker run --rm -v $PWD:/project --network=host grafana/k6:v1 -e WS_URL=ws://127.0.0.1:9500 /project/websocket-test.js`
