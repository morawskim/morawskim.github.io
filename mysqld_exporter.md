# mysqld_exporter

mysqld_exporter to narzędzie używane do monitorowania baz danych MySQL.
Zbiera metryki z MySQL (np. ilość połączeń, ustawienia itd.) i udostępnia je Prometheusowi.

Do zbierania danych warto utworzyć dedykowane konto MySQL, z niezbędnymi uprawnieniami.
Dla Ansible nasze zadania mogą wyglądać w poniższy sposób:

```
- name: Create mysql user for mysqld_exporter
  community.mysql.mysql_user:
    login_user: "root"
    login_password: "{{ mysql_root_password }}"
    name: mysqld_exporter
    password: "{{ MYSQLD_EXPORTER_PASSWORD }}"
    host: "%"
    priv: "*.*:PROCESS,REPLICATION CLIENT,SELECT"
    update_password: "on_create"
    state: present

- name: Set max_user_connections for mysqld_exporter
  community.mysql.mysql_query:
    login_user: "root"
    login_password: "{{ mysql_root_password }}"
    query: |
      ALTER USER 'mysqld_exporter'@'%' WITH MAX_USER_CONNECTIONS 3;

```

Przykładowy docker-compose:

```
services:
  mysqld_exporter:
    image: prom/mysqld-exporter
    command:
      - --mysqld.address=172.17.0.1:3306
      - --mysqld.username=mysqld_exporter
      - --collect.engine_innodb_status
      # It can be resource-intensive if you have a lot of databases and tables.
      - --collect.info_schema.tables
      - --collect.info_schema.tables.databases=*
    environment:
      MYSQLD_EXPORTER_PASSWORD: "mysecretpassword"
    ports:
      - "9104:9104"
```

## Alerty

[Awesome Prometheus alerts - MySQL](https://samber.github.io/awesome-prometheus-alerts/rules.html#mysql-1)
