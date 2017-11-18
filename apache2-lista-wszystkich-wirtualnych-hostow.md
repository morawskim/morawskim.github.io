# Apache2 - lista wszystkich wirtualnych hostów

``` bash
$sudo apache2ctl -S
[sudo] hasło użytkownika root:
AH00558: httpd-prefork: Could not reliably determine the server's fully qualified domain name, using 192.168.15.71. Set the 'ServerName' directive globally to suppress this message
VirtualHost configuration:
*:443                  is a NameVirtualHost
         default server oldadmin.mydeal.dev (/etc/apache2/vhosts.d/00-oldadmin.mydeal.dev-ssl.conf:20)
         port 443 namevhost oldadmin.mydeal.dev (/etc/apache2/vhosts.d/00-oldadmin.mydeal.dev-ssl.conf:20)
         port 443 namevhost mydeal.dev (/etc/apache2/vhosts.d/mydeal.dev-ssl.conf:20)
                 alias www.mydeal.dev
                 alias static.mydeal.dev
                 wild alias *.mydeal.dev
         port 443 namevhost mydil.dev (/etc/apache2/vhosts.d/mydil.dev-ssl.conf:20)
*:80                   is a NameVirtualHost
         default server oldadmin.mydeal.dev (/etc/apache2/vhosts.d/00-oldadmin.mydeal.dev.conf:20)
         port 80 namevhost oldadmin.mydeal.dev (/etc/apache2/vhosts.d/00-oldadmin.mydeal.dev.conf:20)
         port 80 namevhost localhost (/etc/apache2/vhosts.d/000-default.conf:15)
                 alias www.localhost
         port 80 namevhost api.dpd-city.dev (/etc/apache2/vhosts.d/api.dpd-city.dev.conf:20)
         port 80 namevhost cgit.dev (/etc/apache2/vhosts.d/cgit.dev.conf:15)
                 alias www.cgit.dev
         port 80 namevhost dpd-city.dev (/etc/apache2/vhosts.d/dpd-city.dev.conf:20)
         port 80 namevhost drupal.dev (/etc/apache2/vhosts.d/drupal.dev.conf:20)
         port 80 namevhost ideabank.dev (/etc/apache2/vhosts.d/ideabank.dev.conf:20)
         port 80 namevhost mydeal.dev (/etc/apache2/vhosts.d/mydeal.dev.conf:20)
                 alias www.mydeal.dev
                 alias static.mydeal.dev
                 wild alias *.mydeal.dev
         port 80 namevhost phpmyadmin.dev (/etc/apache2/vhosts.d/phpmyadmin.dev.conf:15)
                 alias www.phpmyadmin.dev
         port 80 namevhost phpmyadmin40.dev (/etc/apache2/vhosts.d/phpmyadmin40.dev.conf:15)
                 alias www.phpmyadmin40.dev
         port 80 namevhost rigips.dev (/etc/apache2/vhosts.d/rigips.dev.conf:20)
         port 80 namevhost ws.dpd-city.dev (/etc/apache2/vhosts.d/ws.dpd-city.dev.conf:20)
         port 80 namevhost zabbix.dev (/etc/apache2/vhosts.d/zabbix.dev.conf:15)
                 alias www.zabbix.dev
ServerRoot: "/srv/www"
Main DocumentRoot: "/srv/www/htdocs"
Main ErrorLog: "/var/log/apache2/error_log"
Mutex default: dir="/run/" mechanism=default 
Mutex mpm-accept: using_defaults
Mutex ssl-stapling-refresh: using_defaults
Mutex rewrite-map: using_defaults
Mutex ssl-stapling: using_defaults
Mutex proxy: using_defaults
Mutex ssl-cache: using_defaults
PidFile: "/var/run/httpd.pid"
Define: SYSCONFIG
Define: SSL
Define: DUMP_VHOSTS
Define: DUMP_RUN_CFG
User: name="wwwrun" id=30
Group: name="www" id=8
```

