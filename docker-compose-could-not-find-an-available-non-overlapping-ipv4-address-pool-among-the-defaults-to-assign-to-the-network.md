# docker-compose - could not find an available, non-overlapping IPv4 address pool among the defaults to assign to the network

Podczas wywołania polecenia `docker-compose up -d` otrzymałem błąd:
```
Creating network "ssorder_default" with the default driver
ERROR: could not find an available, non-overlapping IPv4 address pool among the defaults to assign to the network
```

Ten błąd otrzymałem, ponieważ wcześniej połączyłem się z VPN. Poprawna kolejność to uruchomienie kontenerów i następnie połączenie się z vpn. Istnieje także inne rozwiązanie - https://stackoverflow.com/questions/45692255/how-make-openvpn-work-with-docker/45694531#45694531

