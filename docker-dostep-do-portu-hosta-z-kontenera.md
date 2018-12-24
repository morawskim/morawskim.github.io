# Docker - dostęp do portu hosta z kontenera

## bridge docker0

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

## docker-compose

W przypadku uruchomienia kontenerów poprzez docker-compose dodanie interfejsu `docker0` do strefy `trusted` nic nie da. Domyślnie docker-compose tworzy oddzielną sieć dla kontenerów zdefiniowanych w pliku `docker-compose.yml`.

Dostępne sieci docker'a.
```
> docker network ls
NETWORK ID          NAME                 DRIVER              SCOPE
1f9bb35b2e1c        bridge               bridge              local
f9150e758ad4        gollfront_default    bridge              local
75149565020b        host                 host                local
8ac8acac3b59        noipclient_default   bridge              local
61c42305e922        none                 null                local
995a20d94ec2        ssorder_default      bridge              local
```

Przypisanie interfejsów do bridge.
```
/usr/sbin/brctl show
bridge name     bridge id               STP enabled     interfaces
br-8ac8acac3b59         8000.02426fae8dc2       no
br-995a20d94ec2         8000.02426763f62d       no              veth149a6d1
                                                        veth3ed13e9
                                                        veth763c193
                                                        vethb1b8b69
                                                        vethef30a30
                                                        vethfb231de
br-f9150e758ad4         8000.0242f84a441a       no
docker0         8000.024217d3758e       no              veth3308d41
```

Musimy dodać zakres IP do strefy interfejsu, do którego chcemy się podłączyć. Mój interfejs `wlan0` jest przypisany do strefy `internal`. Jeśli została utworzona sieć 172.18.0.0/24 przez docker-compose to wywołujemy poniższe polecenie

```
sudo firewall-cmd --zone=internal --add-source=172.18.0.0/24
```

Jeśli chcemy zachować zmianę na stałe to dodajemy flagę `--permanent` - `sudo firewall-cmd --permanent --zone=internal --add-source=172.18.0.0/24`

```
> sudo firewall-cmd --get-active-zones
internal
  interfaces: wlan0
  sources: 172.17.0.0/24 172.19.0.0/24
```
