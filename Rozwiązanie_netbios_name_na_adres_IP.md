Rozwiązanie netbios name na adres IP
====================================

Domyślnie korzystając z systemu Linux nie możemy odwoływać się do maszyn windowsowych po ich nazwie komputera (netbios name). Instalując jednak oprogramowanie samba-winbind, można ten problem łatwo rozwiązać.

``` bash
zypper in samba-winbind
#Debian
apt-get install winbind libnss-winbind
```

Edytujemy plik /etc/nsswitch.conf. Szukamy w nim linii

```
...
hosts: files dns
...
```

Dopisujemy wartość "wins". Po wprowadzonych zmianach nasza linia powinna wyglądać następująco:

```
...
hosts:      files dns wins
...
```

Od tego momentu możemy łączyć się np. z zasobami sieciowymi Windows podając nazwę komputera.

``` bash
ping marcin-komputer
PING marcin-komputer (192.168.62.105) 56(84) bytes of data.
64 bytes from 192.168.62.105: icmp_req=1 ttl=128 time=1.77 ms
64 bytes from 192.168.62.105: icmp_req=2 ttl=128 time=2.35 ms
64 bytes from 192.168.62.105: icmp_req=3 ttl=128 time=2.73 ms
64 bytes from 192.168.62.105: icmp_req=4 ttl=128 time=3.63 ms
64 bytes from 192.168.62.105: icmp_req=5 ttl=128 time=2.78 ms
64 bytes from 192.168.62.105: icmp_req=6 ttl=128 time=2.67 ms
^C
--- marcin-komputer ping statistics ---
6 packets transmitted, 6 received, 0% packet loss, time 5005ms
rtt min/avg/max/mdev = 1.773/2.659/3.631/0.556 ms
```

``` bash
nmblookup marcin-komputer
192.168.62.105 marcin-komputer<00>
192.168.56.1 marcin-komputer<00>
```