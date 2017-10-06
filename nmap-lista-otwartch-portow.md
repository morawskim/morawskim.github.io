# nmap - lista otwartch portów

TCP
``` bash
sudo nmap -sT localhost
root's password:

Starting Nmap 6.47 ( http://nmap.org ) at 2017-09-23 10:02 CEST
Nmap scan report for localhost (127.0.0.1)
Host is up (0.00030s latency).
Not shown: 984 closed ports
PORT     STATE SERVICE
22/tcp   open  ssh
25/tcp   open  smtp
53/tcp   open  domain
80/tcp   open  http
111/tcp  open  rpcbind
139/tcp  open  netbios-ssn
443/tcp  open  https
445/tcp  open  microsoft-ds
631/tcp  open  ipp
1025/tcp open  NFS-or-IIS
2049/tcp open  nfs
3306/tcp open  mysql
4444/tcp open  krb524
5900/tcp open  vnc
9418/tcp open  git
9999/tcp open  abyss

Nmap done: 1 IP address (1 host up) scanned in 0.04 seconds
```
UDP
``` bash
sudo nmap -sU localhost

Starting Nmap 6.47 ( http://nmap.org ) at 2017-09-23 10:04 CEST
Nmap scan report for localhost (127.0.0.1)
Host is up (0.0000030s latency).
Not shown: 994 closed ports
PORT     STATE         SERVICE
53/udp   open          domain
68/udp   open|filtered dhcpc
111/udp  open          rpcbind
829/udp  open|filtered pkix-3-ca-ra
2049/udp open          nfs
5353/udp open|filtered zeroconf

Nmap done: 1 IP address (1 host up) scanned in 2.75 seconds
```

