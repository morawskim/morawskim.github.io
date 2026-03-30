## swoole

## Undefined constant SWOOLE_SSL

Po aktualizacji Swoole do wersji 6, podczas wykonywania pewnego fragmentu kodu napotkałem błąd: `Undefined constant SWOOLE_SSL`.

Komentarz w wątku [SSL support for Swoole HTTP Server not working #155](https://github.com/laravel/octane/issues/155#issuecomment-816967317) okazał się pomocny.

Instalując pakiet swoole w kontenerze dockera przez pecl i wywołując polecenie `php --ri swoole` otrzymałem poniższe dane:

```
swoole
Author => Swoole Team <team@swoole.com>
swoole.display_errors => On => On
swoole.enable_fiber_mock => Off => Off
swoole.enable_library => On => On
swoole.enable_preemptive_scheduler => Off => Off
swoole.unixsock_buffer_size => 8388608 => 8388608
swoole.use_shortname => On => On
```

Natomiast w środowisku, w którym Swoole w wersji 6 został zainstalowany z pakietu RPM, to samo polecenie (`php --ri swoole`) zwracało:

```
swoole

Swoole => enabled
Author => Swoole Team <team@swoole.com>
Version => 6.0.2
Built => Mar 24 2025 07:22:50
coroutine => enabled with boost asm context
trace_log => enabled
epoll => enabled
eventfd => enabled
signalfd => enabled
cpu_affinity => enabled
spinlock => enabled
rwlock => enabled
sockets => enabled
openssl => OpenSSL 1.1.1k  FIPS 25 Mar 2021
dtls => enabled
http2 => enabled
json => enabled
curl-native => enabled
curl-version => 7.61.1
c-ares => 1.13.0
zlib => 1.2.11
brotli => E16777222/D16777222
zstd => 1.4.4
mutex_timedlock => enabled
pthread_barrier => enabled
futex => enabled
mysqlnd => enabled
coroutine_pgsql => enabled
coroutine_odbc => enabled
coroutine_sqlite => enabled

Directive => Local Value => Master Value
swoole.enable_library => On => On
swoole.enable_fiber_mock => Off => Off
swoole.enable_preemptive_scheduler => Off => Off
swoole.display_errors => On => On
swoole.use_shortname => On => On
swoole.unixsock_buffer_size => 8388608 => 8388608
```

Jak się okazało, wersja instalowana w kontenerze Dockera nie została skompilowana z obsługą OpenSSL (`--enable-openssl`).

Rozwiązaniem problemu było zainstalowanie Swoole za pomocą polecenia: `pecl install --configureoptions 'enable-openssl="yes"' swoole-6.0.2`

## Load Balancing warstwy 4 - TLS SNI

W projekcie Swoole był wykorzystywany do uruchomienia serwera WebSocket.
Klient WebSocket również został zaimplementowany przy użyciu Swoole.

Na serwerze testowym mieliśmy wiele instancji klientów i serwerów WebSocket.
Zamiast otwierać na firewallu osobny port dla każdej instancji, zdecydowałem się wykorzystać load balancing warstwy 4, który na podstawie TLS SNI przekierowuje ruch do odpowiedniej instancji.

W ramach proof of concept, w oparciu o protokół HTTPS, wszystko działało poprawnie — ruch był przekierowywany przez Traefika do odpowiedniego serwera HTTP na podstawie TLS SNI.
Jednak w przypadku proxy dla WebSocket konfiguracja nie działała.

Otrzymywałem błąd HTTP 404, a w logach Traefika widziałem:

> traefik-1  | 2026-03-27T17:38:22Z DBG github.com/traefik/traefik/v3/pkg/tls/tlsmanager.go:288 > Serving default certificate for request: ""
traefik-1  | 172.27.0.1 - - [27/Mar/2026:17:38:22 +0000] "GET / HTTP/1.1" 404 19 "-" "-" 1 "-" "-" 0ms


Aby podejrzeć ruch wychodzący do serwera proxy (Traefik), dodałem dodatkowe uprawnienia do kontenera w `docker-compose.yml`:

```
services:
  app:
    cap_add:
      - NET_RAW
      - NET_ADMIN
```

Następnie w kontenerze zainstalowałem narzędzie tshark: `apt install tshark`

Na hoście uruchomiłem Traefika z routingiem opartym o SNI [zgodnie z demo](https://github.com/morawskim/devops-projects/tree/main/traefik-sni-load-balancer).

Kolejnym krokiem było przechwycenie ruchu sieciowego: `tshark -i eth0 -w /tmp/capture.pcap -f "tcp port 4433"`

Port 4433 to port, na którym nasłuchuje Traefik.
Aplikację skonfigurowałem tak, aby łączyła się z serwerem WebSocket pod adresem `ws.172.17.0.1.nip.io` na porcie 4433.

W przechwyconym ruchu zauważyłem, że pakiet TLS Client Hello nie zawiera SNI.

![tls client hello - bez sni](images/swoole-sni/swoole-bez-sni.png)

Rozwiązaniem było jawne ustawienie SNI w konfiguracji klienta Swoole:

```
// ...

use Swoole\Client;

//...

$this->socket = new Client($this->sockType);
$this->socket->set([
    // ...
    'ssl_host_name' => 'ws.172.17.0.1.nip.io',
]);
```

Po poprawce pakiet TLS Client Hello zawiera już SNI.
W Wiresharku można użyć filtra: `tls.handshake.extensions_server_name`

![tls client hello - z sni](images/swoole-sni/swoole-sni.png)

W logach Traefik zaś znalazła się informacja o przekierowaniu ruchu.

> traefik-1  | 2026-03-27T19:37:18Z DBG github.com/traefik/traefik/v3/pkg/tcp/proxy.go:32 > Handling TCP connection address=172.17.0.1:9500 remoteAddr=172.27.0.1:57882
