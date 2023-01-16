# Ansible jako alternatywa dla Puppet Bolt

Bolt to narzędzie, które automatyzuje ręczną pracę wymaganą do zarządzania infrastrukturą.
Wykorzystując ansible playbook i inventory możemy osiągnąć podobny rezultat.
W tym przypadku pobierzemy z dwóch serwerów pliki z katalogu `/var/log`, które mają rozszerzenie `log`.

Tworzymy plik inventory dla ansbile np. `inventory` i wpisujemy nasze docelowe serwery wraz z dodatkowymi zmiennymi do połączenia przez SSH:

```
[prod]
vm-docker ansible_host=vm-docker
vm-gitlab ansible_host=vm-gitlab

[prod:vars]
ansible_port=22
ansible_user=ubuntu
ansible_ssh_common_args='-J marcin@intel-nuc '

```

Następnie tworzymy plik playbook'a - `playbook.yml`, w którym sprawdzamy połączenie z serwerem, szukamy plików z rozszerzeniem `log` w katalogu `/var/log`, wyświetlamy dopasowane pliku w logach ansible, a na końcu pobieramy znalezione pliku do katalogu "files".

```
---
- hosts: all
  become: false
  vars:
    foo: bar
  tasks:
    - name: Ping srv
      ping:
    - name: List files
      find:
        paths: "/var/log"
        recurse: no
        patterns: "*.log"
      register: files_to_copy
    - name: Print files to copy
      debug:
        var: files_to_copy
    - name: Fetch files
      become: true
      fetch:
        src: "{{ item.path }}"
        dest: files/{{ inventory_hostname }}-{{ item.path | basename }}
        flat: yes
      with_items: "{{ files_to_copy.files }}"
```

Możemy wywołać polecenie `ansible-playbook  -i ./inventory ./playbook.yml`, gdzie podajemy ścieżki do pliku inventory i playbook.
Po wykonaniu w naszym katalogu files pojawią się pobrane pliki z dwóch serwerów.
