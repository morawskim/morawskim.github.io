# Wydajność PHP

## Konfiguracja dla php opcache

[Configure OPcache for Maximum Performance](https://symfony.com/doc/current/performance.html#configure-opcache-for-maximum-performance)

```
opcache.enable=1
; maximum memory that OPcache can use to store compiled PHP files
opcache.memory_consumption=256
; maximum number of files that can be stored in the cache
opcache.max_accelerated_files=20000
opcache.enable_cli=1
opcache.save_comments=1
opcache.interned_strings_buffer=8
;Don’t Check PHP Files Timestamps
opcache.validate_timestamps=0

#Preload for symfony framework
opcache.preload=/path/to/symfony/config/preload.php
; required for opcache.preload:
opcache.preload_user=www-data
```

## Websocket server 1mln+

1. Increase the default TCP buffer sizes for the system
1. Increase the default IPv4 port range
1. Increase the limit for open files and file handles
1. Increase the limit for /proc/sys/net/netfilter/nf_conntrack_max

Liczba otwartych plików przez proces - `ls -l /proc/<PID>/fd` lub `lsof -p <PID>`

Limity dla procesu - `/proc/<PID>/limits`

Liczba deskryptorów plików obecnie używanych w systemie - `cat /proc/sys/fs/file-nr`.
Przykładowy wynik `19136   0       9223372036854775807`.
Pierwsza kolumna pokazuje liczbę używanych deskryptorów plików.
Druga kolumna pokazuje liczbę nieużywanych, ale przydzielonych uchwytów plików.
Zaś trzecia kolumna pokazuje maksymalną liczbę deskryptorów plików w całym systemie.

| Parametr  | OPis  |
|---|---|
| ulimit -Sn (nofile)  | Soft limit for number of open files  |
| ulimit -Hn (nofile)	  | Hard limit for number of open files  |
| fs.nr_open  |  Max number of file handles a process can allocate. |
| fs.file-max | Total number of open file handles allowed for entire system	Calculated dynamically based on system (and usually quite large) |


`fs.file-max` and `fs.nr_open` should not be equal. `fs.file-max` is the total limits of all open file descriptors on the entire system. `fs.nr_open` is the number of file descriptors for a process. When setting `fs.nr_open`, you should make sure that `fs.file-max` is significantly bigger than `fs.nr_open`

`fs.nr_open` acts as an upper limit for `ulimit -Hn`. ulimit -Hn determines the number of files any process on the system can have open. Since an open file (or a network connection) requires three file descriptors, `fs.nr_open` should be at least three times as large as the value set for `ulimit -Hn`

### /etc/security/limits.conf

Systemd korzysta z parametru `DefaultLimitNOFILE` zdefiniowanego w `/etc/systemd/system.conf`, a nie z `/etc/security/limits.conf`.

```
## /etc/security/limits.conf
## System Limits for FDs
## "nofile" is "Number of Open Files"
## This is the cap on number of FDs in use concurrently.
## Set nofile to the max value of 1,048,576.

#<user>     <type>    <item>     <value>
*           soft      nofile     1048576
*           hard      nofile     1048576
root        soft      nofile     1048576
root        hard      nofile     1048576
```

### /etc/sysctl.conf

```
## /etc/sysctl.conf
## Increase Outbound Connections
## Good for a service mesh and proxies like
## Nginx/Envoy/HAProxy/Varnish and applications that
## need long-lived connections.
## Careful not to set the range wider as you will impact
## running application ports in heavy usage situations.
net.ipv4.ip_local_port_range = 12000 65535

fs.nr_open = 1048576
```

### docker-compose

docker-compose (w kontenerze musimy zienic te pliki

```
version: "3.7"
services:
  mycontainer:
    # ...
    ulimits:
      nofile:
        soft: 1048576
        hard: 1048576
    sysctls:
      net.ipv4.ip_local_port_range: 12000 65535
```

[Lessons learned from building a WebSocket server](https://dev.to/appwrite/lessons-learned-from-building-a-websocket-server-4i04)


[php[architect] December 2021 - Lessons learned from building a WebSocket server](https://www.phparch.com/article/lessons-learned-from-building-a-websocket-server/)

[Tuning and debugging maximum connections accepted by MessageSight V2.0](https://www.ibm.com/support/pages/tuning-and-debugging-maximum-connections-accepted-messagesight-v20)

[EC2 Tuning for +1M TCP Connections using Linux ](https://www.linkedin.com/pulse/ec2-tuning-1m-tcp-connections-using-linux-stephen-blum/)

[Performance Tuning on Linux — TCP](https://cromwell-intl.com/open-source/performance-tuning/tcp.html)
