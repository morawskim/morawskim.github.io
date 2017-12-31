# mitmproxy


## Transparent proxy

Serwer
```
sudo iptables -I FORWARD 1 -o wlan0 -s 192.168.0.0/24 -j ACCEPT
sudo iptables -I FORWARD 2 -i wlan0 -s 192.168.0.0/24 -j ACCEPT
sudo iptables -I INPUT -s 192.168.0.0/24 -p tcp --dport 8080 -j ACCEPT
sudo iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080
mitmproxy  -T --host
```

Klient linux

```
sudo route add default gw <IP_SERWERA> eth1
```

