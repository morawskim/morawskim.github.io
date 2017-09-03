"Rozpakowanie" pakietu RPM
==========================

Ściągamy pakiet RPM.

``` bash
sudo zypper in --download-only zabbix-server-mysql
```

Wyświetlamy zawartość pakietu.

``` bash
rpm -qpl /var/cache/zypp/packages/server_monitoring/x86_64/zabbix-server-2.2.9-1.1.x86_64.rpm
```

Rozpakowujemy pakiet do aktualnego katalogu.

``` bash
rpm2cpio /var/cache/zypp/packages/server_monitoring/x86_64/zabbix-server-2.2.9-1.1.x86_64.rpm | cpio -idvm
```

``` bash
ls -la ./usr/bin/zabbix-get
-rwxr-xr-x 1 marcin users 93392 03-12 11:31 ./usr/bin/zabbix-get
```

``` bash
./usr/bin/zabbix-get -s192.168.62.60 -p10050 -kmysql.version
mysql  Ver 14.14 Distrib 5.5.41, for debian-linux-gnu (armv7l) using readline 6.2
```