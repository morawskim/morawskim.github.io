# ansible i goss

[goss](https://github.com/goss-org/goss) służy do testowania aktualnego stanu serwera.
W przeciwieństwie do [Serverspec](https://serverspec.org/) musimy zainstalować na serwerze tylko jeden plik.

Przykładowy plik `goss.yml`, który testuje czy usługa sshd, libvirtd działają, a także czy konto marcin istnieje.

```
port:
  tcp:22:
    listening: true
    ip:
    - 0.0.0.0
service:
  sshd:
    enabled: true
    running: true
  libvirtd:
    enabled: true
    running: true
user:
  marcin:
    exists: true
    groups:
    - libvirt
    - systemd-journal
process:
  libvirtd:
    running: true
```

Goss nie może testować zdalnych serwerów - [Testing of remote machines?](https://github.com/goss-org/goss/issues/388). Pewnym rozwiązaniem jest skorzystanie z [modułu ansible](https://github.com/indusbox/goss-ansible).

Zgodnie z instrukcją wystarczy, że pobierzemy plik `goss.py` z repozytorium "goss-ansible" i umieścimy go w katalogu np. `ansible/modules`. Następnie podczas wywoływania polecenia ansible-playbook musimy ustawić zmienną środowiskową `ANSIBLE_LIBRARY` na wartość `$PWD/ansible/modules:/usr/share/ansible/plugins/modules`. Ścieszka do wbudowanych modułów ansible może się różnić między systemami.

Do pliku playbook możemy dodać zadania, które skopiują plik z definicją oczekiwanego stanu serwera, pobiorą goss i zweryfikują czy serwer spełnia wymagania.

```
- name: Download goss
  get_url:
    url: https://github.com/goss-org/goss/releases/download/v0.3.23/goss-linux-amd64
    dest: /usr/local/bin/goss
    mode: '0750'
- name: Copy goss
  template:
    src: goss/goss.yaml
    dest: /root/goss.yaml
    owner: root
    group: root
    mode: '0600'
- name: run goss against the gossfile /path/to/file.yml
  goss:
    path: "/root/goss.yaml"
    goss_path: "/usr/local/bin/goss"
```
