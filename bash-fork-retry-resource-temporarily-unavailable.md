Bash: fork: retry: Resource temporarily unavailable
===================================================

Po aktualizacji systemu do wersji 42.3 zauważyłem że często podczas wywowyłania nowego polecnia w powłoce otrzymywałem komunikat z błędem:
``` bash
top
-bash: fork: retry: Resource temporarily unavailable
-bash: fork: retry: Resource temporarily unavailable
```

Podejżewałem problem z limitem na maksymalną liczbę uruchomionych procesów.
W openSUSE 42.3 limit wynosi:
``` bash
ulimit -u
1200
```

W openSUSE 13.2 limit wynosił:
``` bash
ulimit -u
3934
```

Postanowiłem dla swojego konta podnieść te limity.
``` bash
cat /etc/security/limits.d/mmo.conf
#
#Each line describes a limit for a user in the form:
#
#<domain>        <type>  <item>  <value>
#

# na opensuse 13.2 mielismy takie limity.
# obecnie na leap 42.2 (i wyzej) limit to 1200
marcin           soft    nproc   3934
marcin           hard    nproc   4096
```
