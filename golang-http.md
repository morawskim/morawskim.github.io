# Golang HTTP

## HTTP/HTTPS proxy

Golang potrafi automatycznie skonfigurować klienta HTTP (`http.Client`) do korzystania z serwera proxy,
jeśli istnieją zmienne środowiskowe `HTTP_PROXY` i/lub `HTTPS_PROXY`.

W przypadku proxy dla połączeń HTTPS zapewne będziemy musieli wyłączyć weryfikację certyfikatów SSL.

```
defaultTransport := http.DefaultTransport.(*http.Transport)

// ignore self-signed SSL
customTransport := &http.Transport{
    Proxy:                 defaultTransport.Proxy,
    DialContext:           defaultTransport.DialContext,
    MaxIdleConns:          defaultTransport.MaxIdleConns,
    IdleConnTimeout:       defaultTransport.IdleConnTimeout,
    ExpectContinueTimeout: defaultTransport.ExpectContinueTimeout,
    TLSHandshakeTimeout:   defaultTransport.TLSHandshakeTimeout,
    TLSClientConfig:       &tls.Config{InsecureSkipVerify: true},
}

return &http.Client{
    Transport: customTransport,
}
```

Możemy także "samemu" skonfigurować klienta HTTP, tak aby korzystał z serwera proxy.

```
proxy, _ := url.Parse("http://host:port")

return &http.Client{
    Transport: &http.Transport{
        Proxy: http.ProxyURL(proxy),
    },
}
```

## Serwer HTTP wykorzystujący Unix Socket

W Go możemy wykorzystać Unix Socket jako listener dla serwera HTTP.

```
socketPath := "/tmp/go-server.sock"

listener, err := net.Listen("unix", socketPath)
if err != nil {
    log.Fatal("listen unix socket:", err)
}

// ...
http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
    w.Write([]byte("Hello from Unix Socket HTTP server!"))
})

//..
err = http.Serve(listener, nil)
if err != nil && err != http.ErrServerClosed {
    log.Fatal("HTTP server error:", err)
}

```

Do komunikacji z serwerem możemy wykorzystać np. curl - `curl --unix-socket /tmp/go-server.sock http://localhost/`
