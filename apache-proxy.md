# apache proxy

```
<VirtualHost *:80>
    ServerName mydomain.example.com

    Redirect / https://mydomain.example.com/

    ErrorLog  /var/log/apache2/mydomain.example.com-error.log
    CustomLog /var/log/apache2/mydomain.example.com-access.log combined
</VirtualHost>
<VirtualHost *:443>
    ServerName mydomain.example.com

    ProxyPass / http://127.0.0.1:8888/
    #ProxyPassReverse / http://127.0.0.1:8888/
    RequestHeader set Host "mydomain.example.com"
    RequestHeader set X-Forwarded-Proto "https"
    RequestHeader set X-Forwarded-Host "mydomain.example.com"
    ProxyPreserveHost On

    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/mydomain.example.com/cert.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/mydomain.example.com/privkey.pem
    SSLCertificateChainFile /etc/letsencrypt/live/mydomain.example.com/chain.pem

    Protocols h2 http/1.1

    ErrorLog  /var/log/apache2/mydomain.example.com-error.log
    CustomLog /var/log/apache2/mydomain.example.com-access.log combined
</VirtualHost>
```
