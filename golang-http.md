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
