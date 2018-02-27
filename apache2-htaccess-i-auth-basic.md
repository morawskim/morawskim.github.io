# apache2 - htaccess i auth basic

Do pliku `.htaccess` dopisujemy.

```
AuthType Basic
AuthName "Restricted Content"
AuthUserFile /home/marcin/.config/htpasswd
Require valid-user
```

Plik z hasłami tworzymy w następujący sposób.

```
htpasswd -c /home/marcin/.config/htpasswd username
```

Nowe konta dopisujemy poprzez wywołanie polecenia jak wyżej, ale bez parametru `-c`

```
htpasswd /home/marcin/.config/htpasswd username
```