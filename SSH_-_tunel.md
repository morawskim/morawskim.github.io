SSH - tunel
===========

W przypadku, kiedy chcemy połączyć się z bazą danych, ale nasze konto nie zezwala na połączenie z naszego adresu IP, to możemy utworzyć tunel SSH. Taki tunel tworzymy dodając parametr -L do komendy ssh.

``` bash
ssh -f -N -L localport:destinationIp:destination.port username@ssh_server.ip
```

Aby utworzyć tunel SSH do MySQL wydajemy poniższe polecenie

``` bash
ssh -f -N -L 3307:192.168.x.y:3306 username@192.168.a.b
```

Po wywołaniu tego polecenia będziemy mogli połączyć się z serwerem MySQL, podając host 127.0.0.1 i port 3307. Dodatkowo warto dodać parametry f i N. Pozwolą one przenieść połączenie z zdalnym serwerem w tło - nie zostanie uruchomiona powłoka zdalnego systemu.