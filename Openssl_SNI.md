Openssl SNI
===========

Dzięki rozszerzeniu SNI do TLS, możemy na jednym adresie IP postawić wiele stron po protokole HTTPS. Z tej możliwości często korzysta się na serwerach deweloperskich. Jednak domyślnie, kiedy łączymy się z takim serwerem przez polecenie openssl s_client, odpala się domyślna strona WWW. Tak jak w przykładzie poniżej.

``` bash
openssl s_client -showcerts -CAfile ~/Dokumenty/CA/intermediate/puppet/certs/ca-chain.crt   -connect carcliq.dev:443                 CONNECTED(00000003)
...
---
Certificate chain
 0 s:/C=XY/ST=unknown/L=unknown/O=SUSE Linux Web Server/OU=web server/CN=linux-i5cl.site/emailAddress=webmaster@linux-i5cl.site
   i:/C=XY/ST=unknown/L=unknown/O=SUSE Linux Web Server/OU=CA/CN=linux-i5cl.site/emailAddress=webmaster@linux-i5cl.site
...
```

Rozwiązanie polegam na dodanie parametru -servername HOSTNAME.

``` bash
openssl s_client -showcerts -CAfile ~/Dokumenty/CA/intermediate/puppet/certs/ca-chain.crt -servername carcliq.dev  -connect carcliq.dev:443
CONNECTED(00000003)
....
---
Certificate chain
 0 s:/C=PL/ST=MAZ/L=Plock/O=Morawskim/OU=Morawskim carcliq.dev/CN=www.carcliq.dev
   i:/C=PL/ST=MAZ/O=Morawskim/OU=Morawskim Certificate Authority/CN=Morawskim Puppet CA
-----BEGIN CERTIFICATE-----
```