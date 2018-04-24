# Docker - ssl api

[Wpierw tworzymy certyfikaty serwera i klienta.](tworzenie-ca-certyfikat-serwera-i-klienta.md)

W systemie opensuse leap 42.2 w konsoli w katalogu, gdzie trzymamy certyfikaty i klucze serwera wywołujemy polecenie:
```
/usr/bin/dockerd --containerd /run/containerd/containerd.sock --tlsverify --tlscacert=ca.pem --tlscert=server-cert.pem --tlskey=server-key.pem -H=0.0.0.0:2376
```

W innym oknie terminala z katalogu gdzie mamy certyfikat i klucz klienta wywołujemy polecenie
```
docker --tlsverify --tlscacert=ca.pem --tlscert=cert.pem --tlskey=key.pem -H=127.0.0.1:2376 version
```
