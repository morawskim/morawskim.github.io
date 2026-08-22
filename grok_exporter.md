# grok_exporter

`grok_exporter` to narzędzie, które umożliwia parsowanie logów i eksportowanie wyników w formacie zgodnym z Prometheus.

## Plik konfiguracyjny

Pobierając plik grok_exporter z witryny [GitHub](https://github.com/fstab/grok_exporter), otrzymamy archiwum ZIP zawierające także wzorce Grok z Logstasha. Możemy je również pobrać samodzielnie z [repozytorium](https://github.com/logstash-plugins/logstash-patterns-core/tree/6d25c13c15f98843513f7cdc07f0fb41fbd404ef/patterns).
Bazując na poniższym pliku konfiguracyjnym, wzorce Grok powinniśmy umieścić w katalogu `patterns`.

```
global:
  config_version: 3

input:
  type: file
  path: /sciezka/do/pliku.log
  readall: true # Read from the beginning of the file? False means we start at the end of the file and read only new lines.
imports:
- type: grok_patterns
  dir: ./patterns

grok_patterns:
  - 'NAME [a-zA-Z\p{L}]+'

metrics:
  - type: counter
    name: my_metric_name
    help: "Liczba wystąpień bledow per uzytkownik"
    match: '%{YEAR}-%{MONTHNUM}-%{MONTHDAY} %{HOUR}:%{MINUTE}:%{SECOND} - error for account: %{NAME:firstname} %{NAME:lastname}'
    labels:
      fullname: "{{ .firstname }} {{ .lastname }}"

server:
  host: 0.0.0.0
  port: 9144

```

Eksporter uruchamiamy poleceniem `./grok_exporter -config config.yml`

## php-fpm server reached pm.max_children setting

grok_exporter jest raczej [porzuconym projektem](https://github.com/fstab/grok_exporter/issues/189), jednak nadal może być przydatny w niektórych rozwiązaniach jako tymczasowe narzędzie.

W jednej z aplikacji co jakiś czas w logach PHP-FPM pojawiała się informacja:

> server reached pm.max_children setting

Standardowe narzędzia monitorujące nie były w stanie skutecznie wykryć tego problemu, ponieważ sprawdzały stan aplikacji co 30 sekund.
Jeżeli problem występował tylko przez krótki czas, mógł zostać niezauważony pomiędzy kolejnymi pomiarami.
Dzięki grok_exporter mogliśmy aktualizować metryki w momencie pojawienia się odpowiedniego wpisu w pliku logu.

Tworzymy osobny plik z zadaniami odpowiedzialnymi za instalację i konfigurację grok_exporter:

```
- name: Create group
  ansible.builtin.group:
    name: "{{ grok_exporter_group }}"
    system: true
- name: Create user
  ansible.builtin.user:
    name: "{{ grok_exporter_user }}"
    group: "{{ grok_exporter_group }}"
    system: true
    shell: /usr/sbin/nologin
    create_home: false
- name: Check if grok_exporter exists
  ansible.builtin.stat:
    path: "{{ grok_exporter_binary }}"
  register: grok_exporter_binary_stat
# on first run this task fail
- name: Download grok_exporter
  ansible.builtin.unarchive:
    src: "{{ grok_exporter_download_url }}"
    dest: /usr/local/bin
    remote_src: yes
    owner: root
    group: root
    mode: 0755
    extra_opts:
      - -j
    include: # requires ansible 2.11
      - grok_exporter-{{grok_exporter_version}}.linux-amd64/grok_exporter
  when: not grok_exporter_binary_stat.stat.exists

- name: Create grok_exporter config file
  ansible.builtin.copy:
    content: "{{ grok_exporter_config_file_content }}"
    dest: "{{ grok_exporter_config_file}}"
    owner: root
    group: "{{ grok_exporter_group }}"
    mode: "0640"
  notify: Restart grok_exporter

- name: Create systemd service
  ansible.builtin.copy:
    content: |
      [Unit]
      Description=Prometheus Grok Exporter
      After=network.target

      [Service]
      Type=simple
      User={{ grok_exporter_user }}
      Group={{ grok_exporter_group }}

      ExecStart={{ grok_exporter_binary }} \
        -config {{ grok_exporter_config_file }}

      Restart=always
      RestartSec=5

      NoNewPrivileges=true
      PrivateTmp=true

      [Install]
      WantedBy=multi-user.target
    dest: /etc/systemd/system/grok_exporter.service
    owner: root
    group: root
    mode: "0644"
- name: Enable and start a grok_exporter
  ansible.builtin.systemd_service:
    name: grok_exporter.service
    state: started
    enabled: true
    daemon_reload: true

```

Zadanie importujemy następnie w playbooku i przekazujemy wymagane zmienne:

```
- # .....
  tasks:
  - import_tasks: grok_exporter.yml
    vars:
      grok_exporter_version: "1.0.0.RC5"
      grok_exporter_user: "grok_exporter"
      grok_exporter_group: "grok_exporter"

      grok_exporter_binary: "/usr/local/bin/grok_exporter"
      grok_exporter_config_file: "/etc/grok_exporter.yml"
      grok_exporter_log_dir: "/var/log/grok_exporter"

      grok_exporter_download_url: >-
        https://github.com/fstab/grok_exporter/releases/download/v{{ grok_exporter_version }}/grok_exporter-{{ grok_exporter_version }}.linux-amd64.zip

      grok_exporter_config_file_content: |
        global:
          config_version: 3

        input:
          type: file
          path: /path/to/phpfpm.log
          readall: true

        grok_patterns:
          - 'PHP_FPM_POOL [a-zA-Z]+'

        metrics:
          - type: counter
            name: phpfpm_log_max_children_reached_total
            help: PHP-FPM reached max children
            #[11-Aug-2026 12:53:03] WARNING: [pool www] server reached pm.max_children setting (100), consider raising it
            match: '\[pool %{PHP_FPM_POOL:poolname}\] server reached pm.max_children setting'
            labels:
              pool: "{% raw %}{{ .poolname}}{% endraw %}"

        server:
          host: 0.0.0.0 # todo change me
          port: 9144

  handlers:
    - name: Restart grok_exporter
      ansible.builtin.systemd:
        name: grok_exporter
        state: restarted

```

Po wykonaniu playbooka możemy sprawdzić, czy grok_exporter wystawia metryki na porcie 9144: `curl -s localhost:9144/metrics | grep phpfpm`.

Wynikiem powinny być między innymi metryki związane z przetwarzaniem logów oraz nasza własna metryka:

```
grok_exporter_line_processing_errors_total{metric="phpfpm_log_max_children_reached_total"} 0
grok_exporter_lines_matching_total{metric="phpfpm_log_max_children_reached_total"} 1
grok_exporter_lines_processing_time_microseconds_total{metric="phpfpm_log_max_children_reached_total"} 17
# HELP phpfpm_log_max_children_reached_total PHP-FPM reached max children
# TYPE phpfpm_log_max_children_reached_total counter
phpfpm_log_max_children_reached_total{pool="www"} 1
```

Metryka `phpfpm_log_max_children_reached_total{pool="www"} 1` jest licznikiem wystąpień komunikatu "server reached pm.max_children setting".
Etykieta pool pozwala dodatkowo określić, którego poola PHP-FPM dotyczył problem.
