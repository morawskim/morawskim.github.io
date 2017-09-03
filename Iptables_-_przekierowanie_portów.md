Iptables - przekierowanie portów
================================

Czasami chcę przekierować ruch z jednego portu na inny. Można to zrobić wywołując następującą komendę z uprawnieniami root'a.

``` bash
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080
```

Powyższe polecenie przekieruje cały ruch przychodzący z interfejsu eth0, z portu 80 na port 8080.