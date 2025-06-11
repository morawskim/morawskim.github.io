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
