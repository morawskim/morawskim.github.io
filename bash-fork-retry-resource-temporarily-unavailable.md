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

Aby sprawdzić ile wątków ma proces możemy skorzystac z polecenia:
``` bash
ps -u1000 -Lf

UID        PID  PPID   LWP  C NLWP STIME TTY          TIME CMD
marcin    4863     1  4863  0    1 wrz08 ?        00:00:00 /usr/lib/systemd/systemd —user
marcin    4865  4863  4865  0    1 wrz08 ?        00:00:00 (sd-pam)
marcin    4869  4862  4869  0    1 wrz08 ?        00:00:00 /bin/sh /usr/bin/startkde
marcin    5038     1  5038  0    1 wrz08 ?        00:00:00 /usr/bin/dbus-launch —sh-syntax —exit-with-session /usr/bin/ssh-agent /usr/bin/gpg-agent —sh —daemon —keep-display —write-env-file /home/marcin/.gnupg/agent.info-linux-o4go:0 /etc/X11/xinit/xinitrc
marcin    5039     1  5039  0    1 wrz08 ?        00:00:09 /bin/dbus-daemon —fork —print-pid 5 —print-address 15 —session
marcin    5040  4869  5040  0    1 wrz08 ?        00:00:00 /usr/bin/ssh-agent /usr/bin/gpg-agent —sh —daemon —keep-display —write-env-file /home/marcin/.gnupg/agent.info-linux-o4go:0 /etc/X11/xinit/xinitrc
marcin    5041  4869  5041  0    1 wrz08 ?        00:00:03 /usr/bin/gpg-agent —sh —daemon —keep-display —write-env-file /home/marcin/.gnupg/agent.info-linux-o4go:0 /etc/X11/xinit/xinitrc
marcin    5076     1  5076  0    1 wrz08 ?        00:00:00 /usr/lib64/libexec/kf5/start_kdeinit —kded +kcminit_startup
................................
```

Aby zliczyć liczbę wątków/procesów dla użytkownika z uid=1000 wywołujemy polecenie:
``` bash
ps -u1000 -Lf --no-headers | wc -l
1373
```

