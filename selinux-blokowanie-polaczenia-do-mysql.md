# selinux - blokowanie połączenia do mysql

Domyślnie selinux blokuje połączenia internetowe inicjowane przez serwer httpd.
Dostęp do bd z powłoki użytkownika działa (nie jest blokowane).
```
mysql -ussorder -h 192.168.0.108 -P3307
```

Poprzez komendę `getenforce` sprawdzamy, czy selinux jest włączony.
Jeśli w wyświetli nam się napis `Enforcing` oznacza, że selinux działa i będzie blokować działania.

Możemy przeszukać logi usługi auditd w poszukiwaniu zablokowanych zdarzeń wywołanych przez httpd - `ausearch -sv no --comm httpd`

```
time->Thu Dec 20 13:21:22 2018
type=SYSCALL msg=audit(1545312082.516:633): arch=c000003e syscall=42 success=no exit=-13 a0=b a1=7ffef7974540 a2=10 a3=b items=0 ppid=3184 pid=3191 auid=500 uid=48 gid=48 euid=48 suid=48 fsuid=48 egid=48 sgid=48 fsgid=48 tty=(none) ses=4 comm="httpd" exe="/usr/sbin/httpd" subj=unconfined_u:system_r:httpd_t:s0 key=(null)
type=AVC msg=audit(1545312082.516:633): avc: denied { name_connect } for pid=3191 comm="httpd" dest=3307 scontext=unconfined_u:system_r:httpd_t:s0 tcontext=system_u:object_r:port_t:s0 tclass=tcp_socket
```

Następnie sprawdzamy, jak ustawione są reguły selinuxa dla httpd za pomocą getsebool.
```
# getsebool -a | grep http
getsebool -a | grep http
allow_httpd_anon_write --> off
allow_httpd_mod_auth_ntlm_winbind --> off
allow_httpd_mod_auth_pam --> off
allow_httpd_sys_script_anon_write --> off
httpd_builtin_scripting --> on
httpd_can_check_spam --> off
httpd_can_network_connect --> off
httpd_can_network_connect_cobbler --> off
httpd_can_network_connect_db --> off
httpd_can_network_memcache --> off
httpd_can_network_relay --> off
httpd_can_sendmail --> off
httpd_dbus_avahi --> on
httpd_dbus_sssd --> off
httpd_enable_cgi --> on
httpd_enable_ftp_server --> off
httpd_enable_homedirs --> off
httpd_execmem --> off
httpd_manage_ipa --> off
httpd_read_user_content --> off
httpd_run_preupgrade --> off
httpd_run_stickshift --> off
httpd_serve_cobbler_files --> off
httpd_setrlimit --> off
httpd_ssi_exec --> off
httpd_tmp_exec --> off
httpd_tty_comm --> on
httpd_unified --> on
httpd_use_cifs --> off
httpd_use_fusefs --> off
httpd_use_gpg --> off
httpd_use_nfs --> off
httpd_use_openstack --> off
httpd_verify_dns --> off
named_bind_http_port --> off
```

W tym przypadku interesują nas dwie reguły:
* httpd_can_network_connect
* httpd_can_network_connect_db

W moim przypadku łącze się na niestandardowy port bd. Wystarczyło włączyć regułę `httpd_can_network_connect`.
Można to zrobić tymczasowo (do restartu maszyny) wywołując polecenie
```
setsebool httpd_can_network_connect 1
```

Aby zmiana była na stałe, to dodajemy flagę `-P` - `setsebool -P httpd_can_network_connect 1`
