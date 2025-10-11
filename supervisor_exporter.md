# supervisord_exporter

supervisord_exporter to narzędzie, które odczytuje stany procesów zarządzanych przez supervisord i udostępnia je jako metryki Prometheusa.

Obecnie oficjalna wersja nie obsługuje połączenia przez unix socket, [ale przygotowałem fork z taką funkcją](https://github.com/morawskim/supervisord_exporter/tree/unixsocket).

Przykładowy docker-compose:
```
services:
  supervisord_exporter:
    image: morawskim/supervisord_exporter:unixsocket
    command:
      - -supervisord-url=unix:///var/run/supervisor.sock
    ports:
      - "9876:9876"
    volumes:
      - /var/run/supervisor/supervisor.sock:/var/run/supervisor.sock
    user: root
```

Przykładowa konfiguracja supervisorda, która uruchamia usługę foo (jako proces sleep 3600), ustawia uprawnienia pliku gniazda UNIX na 0777, a także włącza serwer HTTP (na porcie 9001), który udostępnia interfejs XML-RPC.

```
[unix_http_server]
chmod=0777                       ; sockef file mode (default 0700)

[inet_http_server]
port = 0.0.0.0:9001

[program:foo]
command=sleep 3600
process_name=foo%(process_num)d
numprocs=1
directory=/tmp
user=nobody
autostart=true
autorestart=true
redirect_stderr=true
startretries=30
stdout_logfile=/var/log/supervisor/foostdout.log
stderr_logfile=/var/log/supervisor/foostderr.log
```

## Alarmy

```
groups:
  - name: supervisord_exporter
    rules:
      - alert: SupervisordJobMissing
        expr: 'absent(up{job="supervisord_exporter"})'
        for: 0m
        labels:
          severity: warning
        annotations:
          summary: Supervisord job missing (instance {{ $labels.instance }})
          description: "A Supervisord job has disappeared\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

      - alert: SupervisordTargetMissing
        expr: 'supervisord_up == 0'
        for: 0m
        labels:
          severity: critical
        annotations:
          summary: Supervisord target missing (instance {{ $labels.instance }})
          description: "A Supervisord target has disappeared. An exporter might be crashed.\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

      - alert: SupervisorProcessTooManyRestarts
        expr: resets(supervisor_process_uptime{job="supervisord_exporter"}[5m]) > 2
        for: 0m
        labels:
          severity: warning
        annotations:
          summary: 'Process {{ $labels.group }}:{{ $labels.name }} too many restarts (instance {{ $labels.instance }})'
          description: "Process has restarted more than twice in the last 5 minutes. It might be crashlooping.\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

```
