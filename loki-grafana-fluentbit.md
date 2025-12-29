# Loki, Grafana i fluent bit

## Konfiguracja Loki

Tworzymy plik konfiguracyjny `local-config.yaml` dla Loki na podstawie [przykładowego pliku](/#!loki.md#Przyk%C5%82adowy_plik_konfiguracyjny_loki/local-config.yaml)

## Konfiguracja Grafana – datasource Loki

Tworzymy katalog `provisioning` dla datasource: `mkdir -p provisioning/datasources`.
W katalogu `provisioning/datasources` tworzymy plik `ds.yaml` o następującej treści:

```
apiVersion: 1
datasources:
- name: Loki
  type: loki
  access: proxy
  orgId: 1
  url: http://loki:3100
  basicAuth: false
  isDefault: true
  version: 1
  editable: false

```

## Zmienne środowiskowe

Tworzymy plik `.env` i ustawiamy w nim zmienną `TREAFIK_USER_PASS`.
Jako wartość podajemy zakodowany ciąg Basic Auth.

Instrukcja: [Traefik - Auth basic](/#!traefik.md#Auth_basic_i_SSL_(v3%29)


## Docker Compose – Loki, Grafana, Traefik

Tworzymy plik `docker-compose.yml`.
Instancja Loki jest dostępna za Traefik i wymaga autoryzacji Basic Auth.

```
services:
  loki:
    image: grafana/loki:3.6
    ports:
      - "3100:3100"
    command: -config.file=/etc/loki/local-config.yaml
    volumes:
      - ./local-config.yaml:/etc/loki/local-config.yaml
      - loki-data:/loki
    labels:
      - traefik.enable=true
      #- traefik.http.routers.loki.rule=Host(`loki`)
      - traefik.http.routers.loki.rule=PathPrefix(`/loki`)
      - traefik.http.routers.loki.entrypoints=http
      - traefik.http.services.loki.loadbalancer.server.port=3100
      - traefik.http.routers.loki.middlewares=loki-auth
      - traefik.http.middlewares.loki-auth.basicauth.users=${TREAFIK_USER_PASS}
  grafana:
    image: grafana/grafana:12.3
    ports:
      - "3000:3000"
    environment:
      - GF_PATHS_PROVISIONING=/etc/grafana/provisioning
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana-data:/var/lib/grafana
      - ./provisioning:/etc/grafana/provisioning
  traefik:
    image: traefik:v3.1
    ports:
      - "80:80"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    command:
      #- --log.level=DEBUG
      #- --log.filePath=/letsencrypt/traefik.log
      - --api.dashboard=true
      - --providers.docker=true
      - --providers.docker.exposedbydefault=false
      - --entrypoints.http.address=:80
volumes:
  grafana-data:
  loki-data:

```

## Konfiguracja Fluent Bit

### Parser ścieżki pliku

Tworzymy plik `appparser.conf`:

```
[PARSER]
    Name        path_parser
    Format      regex
    Regex       ^/var/log/app/(?<app>[^/]+)/(?<fileName>[^/]+).*$
```

W głównym pliku konfiguracyjnym Fluent Bit (`fluent-bit.conf`) dodajemy parsery w sekcji `[SERVICE]`:

```
[SERVICE]
    #.....
    # Parsers File
    # ============
    # specify an optional 'Parsers' configuration file
    parsers_file parsers.conf
    parsers_file appparser.conf
    # .....
```

> Uwaga: Fluent Bit nie pozwala definiować sekcji [PARSER] ani multiline_parser bezpośrednio w głównym pliku konfiguracyjnym. Muszą one znajdować się w plikach wczytywanych przez parsers_file.

> Sections 'multiline_parser' and 'parser' are not valid in the main configuration file. It belongs to
> the 'parsers_file' configuration files.
> [error] configuration file contains errors, aborting.

### Input, Filter i Output

Monitorujemy wiele plików logów jednocześnie (`/var/log/app/*/*.log`).
Metadane (np. nazwa instancji i pliku) wyciągamy ze ścieżki pliku przy pomocy filtra parser.

```
[INPUT]
    name tail
    tag httpd
    path /var/log/app/*/*.log
    refresh_interval 1
    parser apache
    read_from_head true
    Path_Key file_path
[FILTER]
    Name          parser
    Match         httpd
    Key_Name      file_path
    Parser        path_parser
    Reserve_Data  True
[OUTPUT]
    name loki
    match httpd
    host traefik
    #uri /loki/api/v1/push
    port 80
    tls off
    tls.verify off
    http_user dev
    http_passwd ${LOKI_PASSWORD}
    labels job=fluentbit,host=dev,env=$app,file=$fileName
```

## Generowanie logów – PHP

Za pomocą skryptu PHP generujemy przykładowe wpisy access log w formacie Apache:

```
<?php

function getRandomElement(array $values) {
    $key = array_rand($values);

    return $values[$key];
}

function createLogRow($settings, $format = 'combined') {
    $ip = $settings['ip'];
    $port = $settings['port'];
    $user = $settings['user'];
    $path = $settings['path'];
    $attack = $settings['attack'];
    $verb = $settings['verb'];
    $status = $settings['status'];
    $date = $settings['date'];
    $http = $settings['version'];
    $referrer = $settings['referrer'];
    $agent = $settings['agent'];
    $blob = rand(1, 90000);

    $log = "";

    switch ($format) {
        case 'common':
            $user = "-";
            $log = $ip ." - ". $user ." [". $date ."] ". "\"" . $verb ." ". $path.$attack . " " .$http. "\" " . $status ." ". $blob;
            break;
        case 'combined':
            $user = "-";
            $log = $ip ." - ". $user ." [". $date ."] ". "\"" . $verb ." ". $path.$attack . " " .$http. "\" " . $status ." ". $blob ." \"". $referrer ."\" \"" . $agent ."\" \"-\"";
            break;
        default:
            throw new RuntimeException("Unknown format");
    }

    return $log;
}

function generateLogs(DateTimeInterface $dt, $items = 30): iterable {
    $results = [];
    $logs = "";
    $separator = "\r\n";
    $timeFormat = 'd/M/Y:H:i:s O';
    $requestIps = [
        '127.0.0.1',
        '8.7.6.5',
        '1.2.3.4',
        '3.3.3.3',
        '23.23.23.23',
    ];
    $requestUserAgents = [
        'Mozilla/5.0 (Linux; Android 8.1.0; MS50G Build/V22_20200918; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/89.0.4389.86 Mobile Safari/537.36',
        'Mozilla/5.0 (Linux; Android 10; Redmi K20 Pro) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.66 Mobile Safari/537.36',
        'Mozilla/5.0 (Linux; Android 7.0; Easy-Power-Pro) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Mobile Safari/537.36',
        'Dalvik/2.1.0 (Linux; U; Android 9; ASUS_Z017DC Build/PQ3A.190801.002)',
        'Mozilla/5.0 (Linux; Android 10; SM-A505FN) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.86 Mobile Safari/537.36',
        'Mozilla/5.0 (Linux; Android 10; SM-A315N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.181 Mobile Safari/537.36',
        'Mozilla/5.0 (Linux; Android 12) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Mobile Safari/537.36',
        'Mozilla/5.0 (Linux; Android 9; W-P611-EEA) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.83 Mobile Safari/537.36',
        'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.90 Safari/537.36 Edg/89.0.774.57',
        'Dalvik/2.1.0 (Linux; U; Android 6.0; O41 Build/MRA58K)',
    ];
    $attackSuffix = [
        '',
        '?foo=bar',
        '?bar=baz',
        '?z=z',
        '?foo=z&bar=baz',
    ];
    $requestPaths = [
        '/',
        '/index.php',
        '/login.php',
        '/register.php',
        '/api/v1/orders',
        '/blog/2025/post1',
    ];

    for ($i = 0; $i < $items; $i++) {
        $settings['ip'] = getRandomElement($requestIps);
        $settings['port'] = getRandomElement([80,443]);
        $settings['user'] = getRandomElement(['admin', '-']);
        $settings['path'] = getRandomElement($requestPaths);
        $settings['attack'] = getRandomElement($attackSuffix);
        $settings['verb'] = getRandomElement(['GET', 'POST']);
        $settings['status'] = getRandomElement([200, 401, 404, 400, 500]);
        $settings['date'] = $dt->format($timeFormat);
        $settings['version'] = getRandomElement(['HTTP/1.1']);
        $settings['referrer'] = getRandomElement($requestPaths);
        $settings['agent'] = getRandomElement($requestUserAgents);

        yield createLogRow($settings) . $separator;
    }
}

date_default_timezone_set($_SERVER['TZ'] ?? 'Europe/Warsaw');

foreach (generateLogs((new DateTimeImmutable('now'))->modify('-5min')) as $log) {
    echo $log;
}

# 172.19.0.1 - - [25/Dec/2025:11:42:56 +0000] "GET /favicon.ico HTTP/1.1" 404 153 "http://localhost:4200/" "Mozilla/5.0 (X11; Linux x86_64; rv:146.0) Gecko/20100101 Firefox/146.0" "-"

```

## Fluent Bit – Docker Compose

Przykładowa usługa Fluent Bit w `docker-compose.yml`:

```
services:
  fluentbit:
    image: cr.fluentbit.io/fluent/fluent-bit:3.2
    command:
      - /fluent-bit/bin/fluent-bit
      - -c
      - /fluent-bit/etc/fluent-bit.conf
    volumes:
      - ./fluent-bit-local.conf:/fluent-bit/etc/fluent-bit.conf
      - ./appparser.conf:/fluent-bit/etc/appparser.conf
      - ./logs:/var/log/app
    environment:
      - LOKI_PASSWORD=mysecretpassword
```
