Postfix relay host Gmail
========================

Zanim zaczniemy musimy mieć zainstalowany serwer pocztowy postfix i bibliotekę libsasl2. Wykonujemy backup domyślnego pliku konfiguracyjnego serwera pocztowego

``` bash
mv /etc/postfix/main.cf /etc/postfix/main.cf.back
```

Tworzymy własny plik konfiguracyjny

``` bash
vim /etc/postfix/main.cf
```

I wklejamy zawartość

```
#The Internet protocols Postfix will attempt to use when making or accepting connections.
#Specify one or more of "ipv4" or "ipv6", separated by whitespace or commas.
#The form "all" is equivalent to "ipv4, ipv6" or "ipv4", depending on whether the operating system implements IPv6.
#Default all
inet_protocols = ipv4

#The internet domain name of this mail system.
#The default is to use $myhostname minus the first component, or "localdomain" (Postfix 2.3 and later).
#$mydomain is used as a default value for many other configuration parameters.
#Default see "postconf -d" output
mydomain = local.domain

#The internet hostname of this mail system.
#The default is to use the fully-qualified domain name (FQDN) from gethostname(),
#or to use the non-FQDN result from gethostname()
#and append ".$mydomain". $myhostname is used as a default value for many
#other configuration parameters.
#Default see "postconf -d" output
myhostname = raspberry.local.domain

#The domain name that locally-posted mail appears to come from,
#and that locally posted mail is delivered to.
#The default, $myhostname, is adequate for small sites.
#If you run a domain with multiple machines, you should (1) change this to $mydomain and (2) set up a domain-wide
# alias database that aliases each user to user@that.users.mailhost.
#Default $myhostname
myorigin = $myhostname

#The next-hop destination of non-local mail;
#overrides non-local domains in recipient addresses.
#This information is overruled with relay_transport, sender_dependent_default_transport_maps, default_transport, sender_dependent_relayhost_maps and with the transport(5) table.
#Default empty
relayhost = smtp.gmail.com:587

#Enable SASL authentication in the Postfix SMTP client. By default, the Postfix SMTP client uses no authentication.
#Default no
smtp_sasl_auth_enable = yes

#Optional Postfix SMTP client lookup tables with one username:password entry per sender,
#remote hostname or next-hop domain.
#Per-sender lookup is done only when sender-dependent authentication is enabled.
#If no username:password entry is found, then the Postfix SMTP client will not attempt to authenticate to the remote host
#Default: empty
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd

#Postfix SMTP client SASL security options;
#as of Postfix 2.3 the list of available features depends on the SASL client
# implementation that is selected with smtp_sasl_type.
#The following security features are defined for the cyrus client SASL implementation:
# Specify zero or more of the following:
#noplaintext
#    Disallow methods that use plaintext passwords.
#noactive
#    Disallow methods subject to active (non-dictionary) attack.
#nodictionary
#    Disallow methods subject to passive (dictionary) attack.
#noanonymous
#    Disallow methods that allow anonymous authentication.
#mutual_auth
#    Only allow methods that provide mutual authentication (not available with SASL version 1).
#Default noplaintext, noanonymous
smtp_sasl_security_options = noanonymous

#The SASL plug-in type that the Postfix SMTP client should use for authentication.
#The available types are listed with the "postconf -A" command.
#Default cyrus
smtp_sasl_type = cyrus

#A file containing CA certificates of root CAs trusted to sign either
# remote SMTP server certificates or intermediate CA certificates.
#These are loaded into memory before the smtp(8) client enters the chroot jail.
#If the number of trusted roots is large, consider using smtp_tls_CApath instead,
# but note that the latter directory must be present in the chroot jail
# if the smtp(8) client is chrooted.
#This file may also be used to augment the client certificate trust chain,
# but it is best to include all the required certificates directly in $smtp_tls_cert_file.
#Default empty
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt

#Opportunistic mode: use TLS when a remote SMTP server announces STARTTLS support,
# otherwise send the mail in the clear.
#Beware: some SMTP servers offer STARTTLS even if it is not configured.
#With Postfix < 2.3, if the TLS handshake fails, and no other server is available,
# delivery is deferred and mail stays in the queue.
#If this is a concern for you, use the smtp_tls_per_site feature instead.
#Default no
smtp_use_tls = yes

#Enable SASL authentication in the Postfix SMTP server.
#By default, the Postfix SMTP server does not use authentication.
#Default no
smtpd_sasl_auth_enable = yes

#Implementation-specific information that the Postfix SMTP server passes through
# to the SASL plug-in implementation that is selected with smtpd_sasl_type.
#Typically this specifies the name of a configuration file or rendezvous point.
#Default smtpd
smtpd_sasl_path = smtpd
```

Następnie tworzymy plik /etc/postfix/sasl_passwd

``` bash
vim /etc/postfix/sasl_passwd
```

I wklejamy zawartość

```
smtp.gmail.com:587 username@gmail.com:password
```

Zmieniamy uprawnienia do pliku

``` bash
chmod 400 /etc/postfix/sasl_passwd
```

Zmieniamy właściela pliku na postfix lub root'a (jeśli nasza dystrybucja tego wymaga)

``` bash
sudo chown -R root:root /etc/postfix/
```

Tworzymy wersję binarną naszego pliku z hasłem do serwera smtp

``` bash
sudo postmap /etc/postfix/sasl_passwd
```

Powyższa konfiguracja ciągle dostarczy maile do użytkowników lokalnych wygenerowane np. przez usługę cron. Aby przekierować maile adresowane na lokalne konto użytkownika na adres email musimy edytować plik /etc/aliases

```
# See man 5 aliases for format
postmaster:    root
pi:     marcin@morawskim.pl
root:   marcin@morawskim.pl
```

Po zapisaniu pliku, musimy go przekonwertować do pliku binarnego. Robimy to wywołując polecenie

``` bash
newaliases
```