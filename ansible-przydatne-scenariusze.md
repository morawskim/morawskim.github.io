# ansible - przydatne scenariusze

## playbook dla traefik:1.7 (docker swarm)

```
---
- hosts: all
  become: true
  gather_facts: no

  tasks:
    # require pip packages: jsondiff
    - name: Create a docker's network
      docker_network:
        name: traefik
        driver: overlay
        attachable: true
    - name: Deploy traefik via docker-stack
      docker_stack:
        state: present
        name: traefik
        compose:
          - version: '3.3'
            services:
              traefik:
                image: traefik:1.7
                restart: unless-stopped
                ports:
                  - 80:80
                  - 443:443
                  - 127.0.0.1:8080:8080
                networks:
                  - traefik
                volumes:
                  - /var/run/docker.sock:/var/run/docker.sock
                  - acme:/acme
                command:
                  - --configfile=/dev/null
                  - --api
                  - --docker
                  - --docker.watch
                  - --docker.network=traefik
                  - --docker.exposedbydefault=false
                  - --docker.swarmMode
                  - --logLevel=INFO
                  # more specific
                  - --debug=false
                  - --defaultentrypoints=https,http
                  - --entryPoints=Name:http Address::80 Redirect.EntryPoint:https
                  - --entryPoints=Name:https Address::443 TLS
                  - --retry
                  - --acme.email=marcin@morawskim.pl
                  - --acme.storage=/acme/acme.json
                  - --acme.entryPoint=https
                  - --acme.onHostRule=true
                  - --acme.httpchallenge.entrypoint=http
                  #- --acme.caServer="https://acme-staging-v02.api.letsencrypt.org/directory"
                deploy:
                  placement:
                    constraints:
                      - node.role == manager
            networks:
              traefik:
                external: true
            volumes:
              acme:
```

## zadania playbooka do instalacji i konfiguracji docker swarm

```
# Setup docker & docker swarm
- name: Update apt-get repo and cache
  apt: update_cache=yes force_apt_get=yes cache_valid_time=3600

- name: Upgrade all apt packages
  apt: upgrade=dist force_apt_get=yes

- name: Install required system packages
  apt: name={{ item }} state=latest update_cache=yes
  loop: [ 'apt-transport-https', 'ca-certificates', 'python3-pip']

- name: Add Docker GPG apt Key
  apt_key:
    url: https://download.docker.com/linux/ubuntu/gpg
    state: present

- name: Add Docker Repository
  apt_repository:
    repo: deb https://download.docker.com/linux/ubuntu {{ ansible_facts['distribution_release'] }} stable
    state: present

- name: Update apt and install docker-ce
  apt: update_cache=yes name=docker-ce state=latest

- name: Install required packages via Pip
  pip:
    name:
    - docker
    - jsondiff

- name: Start docker
  service: name=docker state=started enabled=yes

- name: Init a new swarm with default parameters
  docker_swarm:
    state: present
```

`ansible -i ./inventory.ini ServerNameFromInventoryFile -m setup | grep distr`

## zadania playbooka do utworzenia konta do wdrażania aplikacji

```
# deployer account
- name: Ensure user primary group exists
  group: name={{ user_account }} state=present
- name: Create account
  user:
    name: "{{ user_account }}"
    create_home: true
    group: "{{ user_account }}"
    groups: docker
    state: present
    shell: /usr/bin/bash
    #generate_ssh_key: true
    #home: "{{ user_home }}"
- name: Set up multiple authorized keys for {{ user_account }}
  authorized_key:
    user: "{{ user_account }}"
    state: present
    key: '{{ item }}'
  with_file:
    - public_keys/deployer
```

## newrelic

Aby korzystać z roli `newrelic.newrelic-infra` musimy ją zainstalować - `ansible-galaxy role install -p path/To/Install  newrelic.newrelic-infra`.
Ważne, aby parametr `gather_facts` miał wartość `true` - w przeciwnym przypadku nie będzie możliwe zidentyfikowanie sytemu i próba instalacji agenta zakończy się błędem.
Ponieważ zainstalowaliśmy rolę w niestandardowym katalogu `path/To/Install` musimy podczas wywoływania ansible-playbook ustawić zmienną środowiskową `ANSIBLE_ROLES_PATH` - `ANSIBLE_ROLES_PATH=$(PWD)/path/To/Install`

```
---
- hosts: all
  become: true
  gather_facts: yes
  roles:
    - name: newrelic.newrelic-infra
      vars:
        nrinfragent_config:
          license_key: "{{ lookup('env', 'NEWRELIC_LICENSE_KEY') }}"
```

## template - przekazanie dodatkowych zmiennych do szablonu

```
- hosts: localhost
  gather_facts: no
  connection: local
  tasks:
    - name: template 1
      template:
        src: myTemplateFile.j2
        dest: result1
      vars:
        myTemplateVariable: Foo
    - name: template 2
      template:
        src: myTemplateFile.j2
        dest: result2
      vars:
        myTemplateVariable: Bar
```
