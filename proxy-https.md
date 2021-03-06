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


## OWASP ZAP ROOTCA

RootCa możemy pobrać z konfiguracji programu (Narzędzia -> Opcje -> Dynamiczne certyfikaty SSL).
Możemy też pobrać z API (jeśli jest włączona taka opcja w konfiguracji).
W przeglądarce internetowej wchodzimy na adres `http://127.0.0.1:8088/UI/core/other/rootcert/`.
Gdzie `127.0.0.1` to adres naszego serwera proxy. A `8088` to port na którym proxy nasłuchuje.
Po podaniu `apikey`, plik root ca będzie można zapisać.


## Sparsowanie certyfikatu SSL (wygenerowanego przez proxy) przez openssl s_client

`play.minio.io` to nasz serwer, z którym chcemy się połączyć przez HTTPS.

```
proxychains4 bash -c 'echo | openssl s_client -showcerts -servername play.minio.io -connect play.minio.io:9000 2>/dev/null | openssl x509 -inform pem -noout -text'
```

Minimalny plik konfiguracyjny dla `proxychains`
```
[ProxyList]
http 172.17.0.1 8088

```

Gdzie `172.17.0.1 8088` to nasz adres IP i port serwera proxy.
