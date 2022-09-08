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

## mitmweb - Client connection killed by block_global option

Po migracji klastra kubernetes z IPv4 na IPv6 pojawił się błąd w logach mitmweb: "Client connection from xxxx:xxxx:xxx:xxxx:xxxx::x killed by block_global option.".
Adresy IPv6 są publiczne, więc musimy dodać do polecenia mitmweb parametr `--set block_global=false`.

[Mitmproxy Client connection killed by block_global](https://stackoverflow.com/questions/52068746/mitmproxy-client-connection-killed-by-block-global)
