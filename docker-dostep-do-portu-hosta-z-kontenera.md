# Docker - dostęp do portu hosta z kontenera

Na openSuSE Leap 15 dostarczany jest docker w wersji `17.09.1-ce`.

```
Client:
Version: 17.09.1-ce
API version: 1.32
Go version: go1.8.7
Git commit: f4ffd2511ce9
Built: Mon Jul 30 12:00:00 2018
OS/Arch: linux/amd64

Server:
Version: 17.09.1-ce
API version: 1.32 (minimum version 1.12)
Go version: go1.8.7
Git commit: f4ffd2511ce9
Built: Mon Jul 30 12:00:00 2018
OS/Arch: linux/amd64
Experimental: false
```

Obecnie docker dla linuxa nie obsługuje nazwy domenowej `host.docker.internal`, aby odwołać się do hosta z kontenera:
* https://github.com/docker/for-linux/issues/264
* https://docs.docker.com/docker-for-windows/networking/#i-want-to-connect-from-a-container-to-a-service-on-the-host

Z kontenera możemy odwołać się do maszyny poprzez adres ip domyślnej bramy.
Wywołujemy polecenie `ip route`

```
default via 172.17.0.1 dev eth0
172.17.0.0/16 dev eth0 proto kernel scope link src 172.17.0.2
```

Adres IP naszego hosta to 172.17.0.1. Korzystając z tego adresu IP, możemy podłączyć się pod usługi hosta.

Usługa `firewalld` może blokować połączenie z kontenera do hosta.
W takim przypadku interfejs dockera `docker0` trzeba dodać do strefy zaufanej.

```
# jesli chcemy przypisać interfejs do strefy zaufanej na stałe
sudo firewall-cmd --permanent --zone=trusted --add-interface=docker0

# w przeciwnym przypadku
sudo firewall-cmd --zone=trusted --add-interface=docker0
```
