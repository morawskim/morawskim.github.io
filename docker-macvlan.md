# Docker MacVLAN

Docker obsługuje sterownik MacVLAN, który pozwala przypisać kontenerowi adres IP z naszej fizycznej sieci. Dzięki temu możemy wystawić wybrane usługi/kontenery tak, jakby były podłączone bezpośrednio do sieci lokalnej (LAN), a nie ukryte za NAT-em Dockera.

Tworzymy sieć MacVLAN:

```
docker network create -d macvlan \
  --subnet=192.168.33.0/24 \
  --gateway=192.168.33.1 \
  --ip-range=192.168.33.192/28 \
  -o parent=enp0s31f6 \
  vlan2_network
```

Interfejs sieciowy enp0s31f6 musi być przewodowym interfejsem Ethernet. Interfejsy bezprzewodowe (Wi-Fi) nie obsługują MacVLAN.

### Docker Compose – użycie sieci MacVLAN

```
services:
  nginx:
    image: 'nginx:latest'
    networks:
      vlan2_network:
        ipv4_address: 192.168.33.195

networks:
  vlan2_network:
    external: true

```

[The Zero-Trust Homelab Manual: MacVLAN, Private PKI, and Tailscale ](https://dev.to/chaithuchowdhary/the-zero-trust-homelab-manual-macvlan-private-pki-and-tailscale-46gj)

[The Ultimate 2024 Docker VLAN Guide and Tutorial You’ll Ever Need](https://www.danielketel.com/the-ultimate-2024-docker-vlan-guide-and-tutorial-youll-ever-need/)

[Docker - Macvlan network driver](https://docs.docker.com/engine/network/drivers/macvlan/)

[What to choose (macvlan vs. ipvlan)?](https://docs.kernel.org/networking/ipvlan.html#what-to-choose-macvlan-vs-ipvlan)

[Macvlan and Ipvlan Network Drivers](https://github.com/projectatomic/docker/blob/master/experimental/vlan-networks.md)

## Interfejs pośredniczący Shim

Zgodnie z założeniami bezpieczeństwa, kontener podłączony przez MacVLAN nie może komunikować się bezpośrednio z hostem, na którym działa Docker.

Aby to obejść, należy utworzyć wirtualny interfejs pośredniczący (shim), który umożliwi komunikację host <-> kontenery MacVLAN.

```
# Utworzenie interfejsu shim
ip link add vlan-docker link enp0s31f6 type macvlan mode bridge
# Przypisanie adresu IP po stronie hosta (musi być unikalny)
ip addr add 192.168.33.99/32 dev vlan-docker
# Aktywacja interfejsu
ip link set vlan-docker up
# Dodanie trasy dla zakresu adresów MacVLAN Dockera
ip route add 192.168.33.192/28 dev vlan-docker
```

Po wykonaniu tych kroków host będzie mógł komunikować się z kontenerami w sieci MacVLAN.
