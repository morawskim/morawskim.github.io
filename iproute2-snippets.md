# iproute2 - snippets

## IP aliasing

Przypisanie więcej niż jednego adresu IP do interfejsu

```
ip a
....
3: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000                                                        
    link/ether b4:6d:83:cf:cd:0d brd ff:ff:ff:ff:ff:ff                                                                                                
    inet 192.168.0.104/24 brd 192.168.0.255 scope global dynamic wlan0                                                                                
       valid_lft 4711sec preferred_lft 4711sec                                                                                                        
    inet6 fe80::b66d:83ff:fecf:cd0d/64 scope link                                                                                                     
       valid_lft forever preferred_lft forever
...
```

```
ip addr add 192.168.0.5/24 dev wlan0
ip a
...
3: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000                                                        
    link/ether b4:6d:83:cf:cd:0d brd ff:ff:ff:ff:ff:ff                                                                                                
    inet 192.168.0.104/24 brd 192.168.0.255 scope global dynamic wlan0                                                                                
       valid_lft 4711sec preferred_lft 4711sec                                                                                                        
    inet 192.168.0.5/24 scope global secondary wlan0                                                                                                  
       valid_lft forever preferred_lft forever                                                                                                        
    inet6 fe80::b66d:83ff:fecf:cd0d/64 scope link                                                                                                     
       valid_lft forever preferred_lft forever  
...
```

