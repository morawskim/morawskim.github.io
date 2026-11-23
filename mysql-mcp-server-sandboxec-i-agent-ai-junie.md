# mysql-mcp-server, sandboxec i agent AI junie

Pobieramy wersję co najmniej 1.9 RC2 z repozytorium [mysql-mcp-server](https://github.com/askdba/mysql-mcp-server).
Ta wersja obsługuje komunikację MCP za pośrednictwem protokołu HTTP.

Tworzymy plik konfiguracyjny dla `mysql-mcp-server`:

```
# mysql-mcp-server configuration file
# Copy this file to one of:
#   ./mysql-mcp-server.yaml (current directory)
#   ~/.config/mysql-mcp-server/config.yaml (user config)
#   /etc/mysql-mcp-server/config.yaml (system config)
#
# Or specify with: mysql-mcp-server --config /path/to/config.yaml
#
# Command-line flags (optional):
#   --silent, -s   Suppress INFO/WARN logs (only errors to stderr); good for production.
#   --daemon, -d   Run in background (Unix, typically with http.enabled: true).
#
# Environment variables override config file values.

# Database connections
# Define one or more MySQL connections
connections:
  default:
    dsn: "dbname:userpassword@tcp(127.0.0.1:3307)/dbname?parseTime=true"
    description: "Local development database"
    read_only: true
    # ssl: "true"           # Enable TLS with certificate verification
    # ssl: "skip-verify"    # Enable TLS without certificate verification (self-signed certs)
    # ssl: "preferred"      # Use TLS if available, fall back to unencrypted

  # Additional connections (optional)
  # production:
  #   dsn: "readonly:pass@tcp(prod-server:3306)/prod?parseTime=true"
  #   description: "Production database (read-only)"
  #   read_only: true
  #   ssl: "true"           # Recommended for production connections

# Query settings
query:
  max_rows: 200              # Maximum rows returned per query
  timeout_seconds: 30        # Query timeout

# Connection pool settings
pool:
  max_open_conns: 10         # Maximum open connections
  max_idle_conns: 5          # Maximum idle connections
  conn_max_lifetime_minutes: 30   # Connection max lifetime
  conn_max_idle_time_minutes: 5   # Max idle time before closing
  ping_timeout_seconds: 5    # Database ping timeout

# Feature flags
features:
  extended_tools: false      # Enable extended tools (list_indexes, etc.)
  vector_tools: false        # Enable vector search tools (MySQL 9.0+)
  token_card: false          # HTTP mode: live token dashboard at /status (requires http.enabled)

# Logging settings
logging:
  json_format: false         # Enable JSON structured logging
  audit_log_path: ""         # Path to audit log file (empty = disabled)

# HTTP/REST API settings (optional)
http:
  enabled: false             # Enable REST API mode
  port: 9306                 # HTTP port
  request_timeout_seconds: 60
  rate_limit:
    enabled: false           # Enable rate limiting
    rps: 100                 # Requests per second
    burst: 200               # Burst size
  mcp:
    bind: 127.0.0.1
    path: /mcp
transport: http
```

Aby włączyć obsługę MCP za pośrednictwem protokołu HTTP, musimy wprowadzić kilka zmian w konfiguracji:

* Dodać klucz `transport` z wartością `http`.
* W sekcji `http` ustawić `enabled` na `false`.
* Dodać obiekt `mcp` zawierający dwa klucze:
  * `bind: 127.0.0.1` – adres, na którym serwer będzie nasłuchiwał.
  * `path: /mcp` – ścieżka endpointu MCP.

Po wprowadzeniu zmian możemy uruchomić serwer MCP za pomocą polecenia:
`mysql-mcp-server --config /sciezka/do/utworoznego/pliku/konfiguracyjnego.yaml`

### Agent AI

Kolejnym krokiem jest skonfigurowanie naszego agenta AI tak, aby mógł komunikować się z serwerem MCP.
W przypadku agenta Junie konfigurację możemy umieścić lokalnie, w katalogu projektu (np. `.junie/mcp/mcp.json`), lub globalnie, w pliku:
`~/.junie/mcp/mcp.json`

Więcej informacji na temat konfiguracji serwerów MCP w Junie znajduje się w dokumentacji:
[Add and configure MCP servers﻿](https://junie.jetbrains.com/docs/junie-cli-mcp-configuration.html)

Przykładowa konfiguracja:

```json
{
  "mcpServers": {
    "mysql-mcp-server": {
      "url": "http://127.0.0.1:9306/mcp",
      "headers": {
        "X-Foo": "Bar"
      }
    }
  }
}
```

### sandboxec

Z repozytorium [sandboxec](https://github.com/sandboxec/sandboxec) pobieramy najnowszą wersję narzędzia.

Następnie tworzymy plik konfiguracyjny, który ograniczy dostęp procesu `mysql-mcp-server` wyłącznie do plików niezbędnych do jego działania.

Dodatkowo ograniczamy możliwości sieciowe procesu:

* nasłuchiwanie jest dozwolone wyłącznie na porcie `9306`.
* połączenia wychodzące są dozwolone wyłącznie na porcie `3307`, wykorzystywanym do komunikacji z bazą danych MySQL.

Niestety, obecna implementacja Landlock nie pozwala na ograniczenie połączeń sieciowych do konkretnego adresu IP.
Możemy więc ograniczyć dostęp do portów, ale nie do konkretnego hosta.

Przykładowa konfiguracja `sandboxec`:

```
abi: 6
ignore-if-missing: true
unsafe-host-runtime: true
fs:
  - r:$HOME/.config/mysql-mcp-server/
  - r:/etc/localtime
  - r:/proc/
  - r:/proc/self/cgroup
  - r:/sys/kernel/mm/
  - r:$PWD/config.yaml
net:
  - c:3307
  - b:9306
```

#### Weryfikacja wymaganych uprawnień

Do zidentyfikowania plików i operacji sieciowych, do których proces próbuje uzyskać dostęp, możemy wykorzystać narzędzie `strace`.

Uruchamiamy serwer wewnątrz sandboxa, jednocześnie śledząc operacje na plikach i połączenia sieciowe:
`sandboxec --config ./sandboxec-config -- strace -f -e trace=file,network /sciezka/do/mysql-mcp-server --config ./mcp-mysql-config.yaml`

Wyniki działania `strace` pozwalają zidentyfikować próby dostępu, które zakończyły się błędem z powodu braku odpowiednich uprawnień.

Jeżeli uznamy, że dana operacja jest niezbędna i bezpieczna, możemy dodać wymagane uprawnienie do konfiguracji sandboxa.

Przykładowe wpisy wskazujące na brak uprawnień:

> openat(AT_FDCWD, "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size", O_RDONLY) = -1 EACCES (Permission denied)
openat(AT_FDCWD, "/proc/self/cgroup", O_RDONLY|O_CLOEXEC) = -1 EACCES (Permission denied)
...
[pid 213506] bind(6, {sa_family=AF_INET, sin_port=htons(9306), sin_addr=inet_addr("127.0.0.1")}, 16) = -1 EACCES (Permission denied)

### Uruchomienie serwera MCP w sandboxie

Po skonfigurowaniu `sandboxec` możemy uruchomić `mysql-mcp-server` w ograniczonym środowisku za pomocą polecenia:

`sandboxec --config ./sandboxec-config.yaml -- /sciezka/do/mysql-mcp-server --config ./mcp-mysql-config.yaml`

Mając uruchomiony serwer MCP, możemy przejść do pracy z agentem AI.

Uruchamiamy Junie, a następnie wywołujemy komendę: `/mcp`.
Pozwoli nam to sprawdzić, czy nasz serwer `mysql-mcp-server` został poprawnie zarejestrowany i jest dostępny dla agenta.

Od tego momentu możemy korzystać z serwera MCP na dwa sposoby:

* bezpośrednio wpisując odpowiednie prompty.
* sykorzystując skille, które korzystają z serwera MCP do wykonywania zapytań SQL na naszej bazie danych.
