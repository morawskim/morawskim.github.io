# mock-http-server

Jeśli chcemy przetestować końcówki REST(np. testy w postmanie), to możemy utworzyć "mockable http server".
Pakiet npm `mock-http-server` umożliwia nam to (https://github.com/spreaker/node-mock-http-server).

Pakiet ten możemy zainstalować lokalnie:
```
yarn add mock-http-server
```

Następnie tworzymy plik np. `mock.js` i definiujemy końcówki.
``` javascript
const ServerMock = require('mock-http-server');

// Run an HTTP server on localhost:9000
const server = new ServerMock({host: "localhost", port: 9000});

server.on({
    method: 'POST',
    path: '/api/users/sessions',
    reply: {
        status: 200,
        headers: {'content-type': 'application/json'},
        body: JSON.stringify({data: {attributes: {token: 'mock-token'}}})
    }
});

//... pozostałe końcówki

server.start(function () {
        console.log("I am ready...");
    }
);
```

Teraz wystarczy tylko uruchomić nasz serwer HTTP.
```
node mock.js
```
