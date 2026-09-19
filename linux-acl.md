# Linux ACL

ACL rozszerza tradycyjny model uprawnień systemów Unix/Linux, który opiera się na właścicielu, grupie oraz pozostałych użytkownikach (user, group, other).

Umożliwia nadanie dodatkowych uprawnień dostępu konkretnym użytkownikom i grupom, dzięki czemu nie jesteśmy ograniczeni wyłącznie do jednego właściciela i jednej grupy przypisanych do pliku lub katalogu.

Na jednym z serwerów chciałem monitorować plik z logiem za pomocą narzędzia grok_exporter.
Nie chciałem jednak uruchamiać grok_exporter z konta będącego właścicielem pliku z logiem.

W pierwszej kolejności konfigurujemy domyślną listę ACL (default ACL) dla katalogu `/var/log/test` - `setfacl -d -m 'u:vagrant:rx /var/log/test'`

Default ACL definiuje wpisy ACL, które są dziedziczone przez nowo tworzone pliki i katalogi znajdujące się w tym katalogu.
W tym przykładzie każdy nowy plik i katalog tworzony w katalogu `/var/log/test` automatycznie otrzyma wpis ACL `u:vagrant:rx`.
Rzeczywiste, efektywne uprawnienia wynikające z tego wpisu mogą być ograniczone przez maskę ACL


Samo skonfigurowanie default ACL na `/var/log/test` nie wystarczy, jeżeli użytkownik vagrant nie ma uprawnień do przejścia przez ten katalog.

W takim przypadku należy nadać użytkownikowi odpowiedni wpis ACL również na samym katalogu - `setfacl -m 'u:vagrant:rx /var/log/test`

Do testów możemy wykorzystać poniższy playbook Ansible:

```
- name: ACL
  hosts: localhost
  connection: local
  gather_facts: no
  become: true
  vars:
    dir: /var/log/test
  tasks:
    - name: "Create directory"
      file:
        path: "{{ dir }}"
        state: directory
        mode: '0700'
        owner: root
        group: root
    - name: Create file
      copy:
        content: |
          foo
          bar
        dest: "{{ dir }}/a"
        mode: '0640'
        owner: root
        group: root
    - name: Sets default ACL
      ansible.posix.acl:
        path: "{{ dir }}"
        entity: vagrant
        etype: user
        permissions: r-x
        default: true
        state: present
    - name: Add permission to open and read directory
      ansible.posix.acl:
        path: "{{ dir }}"
        entity: vagrant
        etype: user
        permissions: r-x
        state: present

```

Plik utworzony za pomocą modułu copy nie posiada wpisu ACL, mimo że katalog nadrzędny ma skonfigurowaną default ACL - [copy module ignores ACL when creating file #192](https://github.com/ansible/ansible-modules-core/issues/192)

Aktualną listę ACL dla katalogu/pliku możemy wyświetlić za pomocą polecenia -  `getfacl /sciezka/do/pliku/lub/katalogu`

```
[vagrant@localhost ~]$ getfacl /var/log/test
getfacl: Removing leading '/' from absolute path names
# file: var/log/test/
# owner: root
# group: root
user::rwx
user:vagrant:r-x
group::---
mask::r-x
other::---
default:user::rwx
default:user:vagrant:r-x
default:group::---
default:mask::r-x
default:other::---
```

Jeżeli plik lub katalog posiada rozszerzoną ACL, polecenie `ls -l`  pokazuje dodatkowy znak + za podstawowym zestawem uprawnień.

```
[vagrant@localhost ~]$ ls -la /var/log/test
total 8
drwxr-x---+ 2 root root   15 Sep 18 16:42 .
drwxr-xr-x. 9 root root 4096 Sep 18 16:42 ..
```

[Access Control Lists](https://wiki.archlinux.org/title/Access_Control_Lists)
