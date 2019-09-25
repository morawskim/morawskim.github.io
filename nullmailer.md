# nullmailer

Nullmailer to usługa MTA. Odpowiada za wysłanie mail wykorzystując do tego zewnętrzne konto SMTP.
Jest prosty w konfiguracji w porównaniu do np. `postfix`.

Musimy zainstalować pakiet `nullmailer`.
Następnie tworzymy plik konfiguracyjny `/etc/nullmailer/adminaddr` i jako zawartość podajemy adres email (lub adresy email oddzielone przecinkiem). Dzięki temu maile kierowane na lokalne konta np. `root` zostaną przekazane na podane adresy email.

> If  this  file  is  not  empty,  all recipients to users at either "localhost" (the literal string) or the canonical host name (from  /etc/mailname)  are  remapped  to this  address.  This is provided to allow local daemons to be able to send email to "somebody@localhost" and have it go somewhere sensible instead of being bounced  by  your relay host.

Tworzymy także plik `/etc/nullmailer/remotes`. Ten plik zawiera konfigurację połączenia z zdalnym serwerem SMTP.
W przypadku usługi gmail korzystamy z szablonu `smtp.gmail.com smtp --port=465 --auth-login --user=<user@gmail.com> --pass=<haslo> --ssl`.

W przypadku smtp mailgun `smtp.mailgun.org smtp --port=587 --starttls --user=<nazwaUzytkownika@mailgun.example.com> --pass=<haslo>`

Dostępne parametry konfiguracyjne możemy wyświetlić wywołując polecenie `/usr/lib/nullmailer/smtp --help`

```
usage: smtp [flags] < options 3< mail-file
Send an email message via SMTP
      --host=VALUE          Set the hostname for the remote
  -p, --port=INT            Set the port number on the remote host to connect to
      --user=VALUE          Set the user name for authentication
      --pass=VALUE          Set the password for authentication
      --auth-login          Use AUTH LOGIN instead of auto-detecting in SMTP
      --source=VALUE        Source address for connections
      --tls                 Connect using TLS (on an alternate port by default)
      --ssl                 Alias for --tls
      --starttls            Use STARTTLS command
      --x509certfile=VALUE  Client certificate file
      --x509keyfile=VALUE   Client certificate private key file
                            (Defaults to the same file as --x509certfile)
      --x509cafile=VALUE    Certificate authority trust file
                            (Defaults to /etc/ssl/certs/ca-certificates.crt)
      --x509crlfile=VALUE   Certificate revocation list file
      --x509fmtder          X.509 files are in DER format
                            (Defaults to PEM format)
      --insecure            Don't abort if server certificate fails validation
      --tls-anon-auth       Use TLS anonymous authentication - needs --insecure option

  -h, --help                Display this help and exit
```

Plik konfiguracyjny `/etc/nullmailer/me` przechowuje fqdn serwera, zaś `/etc/nullmailer/defaulthost` określa domyślną domenę/host, która zostanie dodana kiedy próbujemy przesłać maila na konto bez podawania domeny np. `root` zamiast `root@example.com`.

http://www.troubleshooters.com/linux/nullmailer/#_rising_to_the_ssl_challenge

https://raspberry.znix.com/2013/03/nullmailer-on-raspberry-pi.html

## Debian

W systemach z rodziny `Debian` nullmailer ignoruje plik `/etc/nullmailer/me`. - `
Warning: On Debian systems, nullmailer's 'me' is disregarded; please use '/etc/mailname' in
Sep 24 17:14:55 ubuntu-bionic nullmailer-send[3361]:`
Zamiast tego pliku, korzystamy z `/etc/mailname`.

## /etc/aliases

>nullmailer doesn't support /etc/aliases, the newaliases command provides a dummy script for policy compliance only. A catch-all alias for local users may be achieved using the adminaddr(5) control file.
/usr/share/doc/nullmailer/README.Debian
