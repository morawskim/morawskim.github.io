# Proxy

## socat
Przekaż przychodzące dane z lokalnego portu do innego hosta i portu

```
socat TCP-LISTEN:8888,fork TCP4:192.168.15.71:80

```

## socat TCP do gniazda unix
Przekaż przychodzące dane z lokalnego portu do gniazda unix

```
socat TCP-LISTEN:2375,reuseaddr,fork,bind=localhost UNIX-CONNECT:/var/run/FILE.sock
```
