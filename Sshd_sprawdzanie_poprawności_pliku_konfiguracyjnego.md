Sshd sprawdzanie poprawności pliku konfiguracyjnego
===================================================

Podczas edycji plików konfiguracyjnych nietrudno o pomyłkę. W przypadku serwera ssh, mamy specjalny argument, który pozwala nam sprawdzić, czy plik konfiguracyjny nie zawiera błędów.

``` bash
sudo /usr/sbin/sshd -t
/etc/ssh/sshd_config: line 20: Bad configuration option: Protocool
/etc/ssh/sshd_config: terminating, 1 bad configuration options
```

``` bash
sudo /usr/sbin/sshd -t
ignoring bad proto spec: '3'.
/etc/ssh/sshd_config line 20: Bad protocol spec '3'.
```

``` bash
sudo /usr/sbin/sshd -t
Could not load host key: /etc/ssh/not-exist-key
```