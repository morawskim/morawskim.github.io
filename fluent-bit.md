# Fluent Bit

## parser 'XXX' is not registered

Jeśli otrzymamy błąd `parser 'apache' is not registered` upewnijmy się że [domyślny plik z konfiguracją parserów](https://github.com/fluent/fluent-bit/blob/fb57c6bbc0fb0d2da9aecadd02fc4d5818b96c44/conf/parsers.conf) jest wczytywany.

W pliku konfiguracyjny powinniśmy mieć klucz `parsers_file`


```
[SERVICE]
    # Parsers File
    # ============
    # specify an optional 'Parsers' configuration file
    parsers_file parsers.conf
```

W przypadku konfiguracji w formacie YAML:
```
service:
  parsers_file: /fluent-bit/etc/parsers.conf
```

## Przykład

Tworzymy plik `docker-compose.yml` o zawartości:

```
services:
  fluentbit:
    image: cr.fluentbit.io/fluent/fluent-bit:3.2
    volumes:
      - ./input.log:/input/input.log
      - ./fluent-bit.conf:/fluent-bit/etc/fluent-bit.conf
    command:
      - /fluent-bit/bin/fluent-bit
      - -c
      - /fluent-bit/etc/fluent-bit.conf
```

Następnie tworzymy plik `input.log` z logami w formacie apache access logs np.

```
172.18.0.2 - - [29/Nov/2024:22:51:02 +0100] "POST /ajax/relational-selector HTTP/1.1" 200 2474 "http://foo.lvh:80/bar/update?id=151962" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:132.0) Gecko/20100101 Firefox/132.0"
172.18.0.1 - - [27/Jan/2025:17:08:15 +0100] "GET /notifications/default/count HTTP/1.1" 200 726 "http://foo.lvh:80/bar/update?id=61" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:134.0) Gecko/20100101 Firefox/134.0"

```

Tworzymy plik konfiguracyjny `fluent-bit.conf`,
Możemy bazować na przykładzie [fluent-bit.conf](https://github.com/fluent/fluent-bit/blob/fb57c6bbc0fb0d2da9aecadd02fc4d5818b96c44/conf/fluent-bit.conf)

```
[SERVICE]
    # Flush
    # =====
    # set an interval of seconds before to flush records to a destination
    flush        1

    # Daemon
    # ======
    # instruct Fluent Bit to run in foreground or background mode.
    daemon       Off

    # Log_Level
    # =========
    # Set the verbosity level of the service, values can be:
    #
    # - error
    # - warning
    # - info
    # - debug
    # - trace
    #
    # by default 'info' is set, that means it includes 'error' and 'warning'.
    log_level    info

    # Parsers File
    # ============
    # specify an optional 'Parsers' configuration file
    parsers_file parsers.conf

    # Plugins File
    # ============
    # specify an optional 'Plugins' configuration file to load external plugins.
    plugins_file plugins.conf

    # HTTP Server
    # ===========
    # Enable/Disable the built-in HTTP Server for metrics
    http_server  Off
    http_listen  0.0.0.0
    http_port    2020

    # Storage
    # =======
    # Fluent Bit can use memory and filesystem buffering based mechanisms
    #
    # - https://docs.fluentbit.io/manual/administration/buffering-and-storage
    #
    # storage metrics
    # ---------------
    # publish storage pipeline metrics in '/api/v1/storage'. The metrics are
    # exported only if the 'http_server' option is enabled.
    #
    storage.metrics on

    # storage.path
    # ------------
    # absolute file system path to store filesystem data buffers (chunks).
    #
    # storage.path /tmp/storage

    # storage.sync
    # ------------
    # configure the synchronization mode used to store the data into the
    # filesystem. It can take the values normal or full.
    #
    # storage.sync normal

    # storage.checksum
    # ----------------
    # enable the data integrity check when writing and reading data from the
    # filesystem. The storage layer uses the CRC32 algorithm.
    #
    # storage.checksum off

    # storage.backlog.mem_limit
    # -------------------------
    # if storage.path is set, Fluent Bit will look for data chunks that were
    # not delivered and are still in the storage layer, these are called
    # backlog data. This option configure a hint of maximum value of memory
    # to use when processing these records.
    #
    # storage.backlog.mem_limit 5M


[INPUT]
    name tail
    tag mytag
    path /input/input.log
    refresh_interval 1
    parser apache
    read_from_head true

[OUTPUT]
    name  stdout
    match *
```

W tym przykładzie zmodyfikowałem sekcję `[INPUT]` i `[OUTPUT]`.

