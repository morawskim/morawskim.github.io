# proxy HTTPS

## Node - wyłączenie weryfikacji certyfikatów SSL

Ustawiamy zmienną środowiskową `NODE_TLS_REJECT_UNAUTHORIZED` na wartość `0`.

```
NODE_TLS_REJECT_UNAUTHORIZED=0 node /sciezka/do/pliku.js
```

Możemy także wyłączyć walidację certyfikatów SSL dla pojedynczego połączenia.
W ustawieniach połączenia tls ustawiamy klucz `rejectUnauthorized` na wartość `false`.
Zgodnie z dokumentacją https://nodejs.org/docs/latest/api/tls.html#tls_tls_connect_options_callback

Kolejną opcją jest zmodyfikowanie wywołania zwrotnego `checkServerIdentity`.
Zgodnie z dokumentacją https://nodejs.org/docs/latest/api/tls.html#tls_tls_connect_options_callback
```
checkServerIdentity: function (host, cert) {
return undefined;
}
```
