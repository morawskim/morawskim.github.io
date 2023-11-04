# libpcap

## Analiza ruchu sieciowego

### tshark

tshark -i eth0 -b filesize:10240 -b files:1000 -w if-eth0

Polecenie monitoruje interfejs eth0 i utworzy tysiąc plików o rozmiarze okolo 10MB kazdy z nazwami zawierającymi znaczniki czasu w formacie YYYYMMDDHHMMSS np. if-eth0_00001_2023xxxx
