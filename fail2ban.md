# fail2ban

Fail2Ban to oprogramowanie do zapobiegania włamaniom, które chroni serwery komputerowe przed atakami siłowymi.
W dystrybucji `Ubuntu` musimy zainstalować pakiet `fail2ban`. A następnie włączamy usługę przy starcie systemu `sudo systemctl enable --now fail2ban.service`.
Domyślnie `fail2ban` powinien mieć włączony konfigurację dla usługi ssh. Wywołując polecenie `sudo fail2ban-client status` wyświetlimy aktywną listę jails.

```
Status
|- Number of jail:      1
`- Jail list:   sshd
```

Możemy także wyświetlić status konkretnej usługi (jail) - `sudo fail2ban-client status sshd`.

```
Status for the jail: sshd
|- Filter
|  |- Currently failed: 0
|  |- Total failed:     10
|  `- File list:        /var/log/auth.log
`- Actions
   |- Currently banned: 1
   |- Total banned:     2
   `- Banned IP list:   10.0.2.2
```

Aby ręcznie dodać adres IP do blokowanych (jail sshd) wywołujemy polecenie - `sudo fail2ban-client set sshd banip <IP>`.
Zaś aby odblokować adres IP (jail sshd) - `sudo fail2ban-client set sshd unbanip <IP>`

Wywołując polecenie `sudo iptables -nL` wyświetlimy reguły firewalla utworzone przez fail2ban.

## Konfiguracja

* `bantime` - "bantime" is the number of seconds that a host is banned
* `maxretry` - "maxretry" is the number of failures before a host get banned
* `ignoreip` - "ignoreip" can be a list of IP addresses, CIDR masks or DNS hosts.
Fail2ban will not ban a host which matches an address in this list.
Several addresses can be defined using space (and/or comma) separator.
* `banaction`  - Default banning action (e.g. iptables, iptables-new,
iptables-multiport, shorewall, etc) It is used to define
action_* variables. Can be overridden globally or per
section within jail.local file
