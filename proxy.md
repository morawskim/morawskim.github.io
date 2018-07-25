# Proxy

## socat
Przekaż przychodzące dane z lokalnego portu do innego hosta i portu

```
socat TCP-LISTEN:8888,fork TCP4:192.168.15.71:80

```
