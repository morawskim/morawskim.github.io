# FrankenPHP

FrankenPHP to nowoczesny web server i application server napisany w języku Go, który uruchamia aplikacje PHP szybciej i bardziej wydajnie niż tradycyjne serwery (np. Apache + mod_php lub Nginx + PHP-FPM).

## Xdebug

Gdy nie korzystamy z FrankenPHP w trybie worker, Xdebug działa bez problemu.

W przypadku uruchomienia w trybie worker mogą jednak występować problemy - [FrankenPHP hangs when function xdebug_connect_to_client() is called in worker mode #1504](https://github.com/php/frankenphp/issues/1504).

W moim przypadku Xdebug i FrankenPHP w trybie worker działał losowo – raz działał, raz nie – w zależności od tego, kiedy włączałem nasłuchiwanie połączenia w PHPStorm.
Czasem możliwe było debugowanie żądań HTTP, ale już nie działało debugowanie skryptów uruchamianych bezpośrednio w kontenerze FrankenPHP (np. przez CLI lub scheduler). Innym razem – odwrotnie – debugowanie skryptów działało, ale żądań HTTP już nie.

## Konfiguracja PHP

Możemy zmienić konfigurację PHP, używając dyrektywy php_ini w pliku Caddyfile.

```
{
	frankenphp {
		php_ini {
			memory_limit 256M
		}
	}
}
```

## Caddyfile

```
{
	frankenphp {
		php_ini {
			memory_limit 256M
		}
	}
}

http://:80 {
	# enable comppression (optional)
	encode zstd br gzip
	# execute PHP files in the current directory and server assets
	php_server {
		root /app
	}
}
```

## max_requests

Jeśli chcemy restartować wątek PHP po przetworzeniu określonej liczby żądań, możemy użyć dyrektywy `max_requests` w konfiguracji FrankenPHP (wewnątrz bloku frankenphp w pliku konfiguracyjnym Caddy).

Dyrektywa `max_requests` określa maksymalną liczbę requestów obsługiwanych przez pojedynczy wątek PHP przed jego restartem. Mechanizm ten pomaga ograniczać skutki wycieków pamięci (memory leaks).

Domyślna wartość to 0, co oznacza brak limitu i brak automatycznego restartu wątków.

```
{
	# Debug
	debug

	frankenphp {
		# ...
		max_requests {$MAX_REQUESTS:10}
	}
}
```

W tym przykładzie użyj wartości zmiennej środowiskowej `MAX_REQUESTS`, a jeśli nie istnieje — użyj wartości 10.

W logach będziemy widzieć ustawioną wartość `max_requests`: `docker compose logs php | grep  max_requests`

Przykład wpisu:
> php-1  | {"level":"info","ts":1779626040.8992379,"logger":"frankenphp","msg":"FrankenPHP started 🐘","php_version":"8.2.31","num_threads":25,"max_threads":25,"max_requests":4}

Jeśli mamy włączoną dyrektywę `debug`, to po osiągnięciu limitu przetworzonych żądań w logach zobaczymy wpis (`docker compose logs php | grep -i 'max requests reached'`):

> php-1  | {"level":"debug","ts":1779626087.1332717,"logger":"frankenphp","msg":"max requests reached, restarting","worker":"/app/public/index.php","thread":1,"max_requests":4}

## OpenTelemetry

Podczas analizy działania OpenTelemetry zauważyłem opóźnienia w publikowaniu sygnałów (w moim przypadku trace'ów) do OpenTelemetry Collector.

Przyczyną okazał się sposób, w jaki SDK OpenTelemetry inicjalizuje proces opróżniania buforów.
W ramach autokonfiguracji rejestrowana jest funkcja za pomocą `register_shutdown_function`, która podczas zamykania obsługi żądania HTTP wykonuje operacje związane z eksportem zgromadzonych danych.

Rejestracja odbywa się w metodzie [\OpenTelemetry\SDK\SdkAutoloader::environmentBasedInitializer](https://github.com/open-telemetry/opentelemetry-php/blob/086ec77bb2d7733aadd5dc3b9f8cda728fd5bf90/src/SDK/SdkAutoloader.php#L121).

Takie podejście działa poprawnie w środowisku PHP-FPM, gdzie proces obsługujący żądanie wywołuje zarejestrowane funkcje przez `register_shutdown_function` po zakończeniu requestu.

Sytuacja wygląda inaczej w przypadku FrankenPHP działającego w trybie workerów.
Proces PHP pozostaje aktywny i obsługuje wiele kolejnych żądań, dlatego funkcje zarejestrowane przez `register_shutdown_function` są wykonywane dopiero w momencie zakończenia pracy workera.
Może to powodować opóźnienia w publikowaniu sygnałów do OpenTelemetry Collector.

Rozwiązaniem jest wymuszenie opróżnienia buforów po zakończeniu obsługi każdego żądania.
Można to zrealizować poprzez listener uruchamiany na końcu cyklu życia requestu.
W przypadku Symfony odpowiednim miejscem jest obsługa zdarzenia TerminateEvent.

```
use OpenTelemetry\API\Globals;
// ...

$result = Globals::tracerProvider()->forceFlush()
```

Wywołanie `forceFlush()` po każdym żądaniu powoduje natychmiastowe przesłanie zgromadzonych trace'ów do eksportera.

## Debugowanie przy użyciu Delve

W ramach jednego z projektów w logach pojawił się błąd związany z FrankenPHP.
Nie mógł on zarejestrować handlera HTTP dla Mercure.
Jak się później okazało, był to fałszywy alarm i wystarczyło dostosować konfigurację do nowszej wersji.

Istnieje również osobne repozytorium z [obrazami developerskimi](https://hub.docker.com/r/dunglas/frankenphp-dev), jednak ich nie testowałem.

Pobieramy kod FrankenPHP: `git clone https://github.com/php/frankenphp && cd frankenphp`.

Musimy zmodyfikować plik Dockerfile.
Nie korzystałem z [docker bake](https://docs.docker.com/build/bake/).
Dodatkowo należy wyłączyć usuwanie symboli debugowania.

```
Index: Dockerfile
IDEA additional info:
Subsystem: com.intellij.openapi.diff.impl.patch.CharsetEP
<+>UTF-8
===================================================================
diff --git a/Dockerfile b/Dockerfile
--- a/Dockerfile	(revision edaffab6a00cb6fe8a93ca5699be437b2eed5705)
+++ b/Dockerfile	(date 1780775299728)
@@ -2,7 +2,7 @@
 #checkov:skip=CKV_DOCKER_2
 #checkov:skip=CKV_DOCKER_3
 #checkov:skip=CKV_DOCKER_7
-FROM php-base AS common
+FROM php:8.5-zts-trixie AS common

 WORKDIR /app

@@ -56,7 +56,7 @@
 ARG FRANKENPHP_VERSION='dev'
 SHELL ["/bin/bash", "-o", "pipefail", "-c"]

-COPY --from=golang-base /usr/local/go /usr/local/go
+COPY --from=golang:1.26-trixie /usr/local/go /usr/local/go

 ENV PATH=/usr/local/go/bin:$PATH
 ENV GOTOOLCHAIN=local
@@ -121,7 +121,7 @@

 WORKDIR /go/src/app/caddy/frankenphp
 RUN GOBIN=/usr/local/bin \
-	../../go.sh install -ldflags "-w -s -X 'github.com/caddyserver/caddy/v2.CustomVersion=FrankenPHP $FRANKENPHP_VERSION PHP $PHP_VERSION Caddy' -X 'github.com/caddyserver/caddy/v2.CustomBinaryName=frankenphp' -X 'github.com/caddyserver/caddy/v2/modules/caddyhttp.ServerHeader=FrankenPHP Caddy'" -buildvcs=true && \
+	../../go.sh install -gcflags "all=-N -l" -ldflags "-X 'github.com/caddyserver/caddy/v2.CustomVersion=FrankenPHP $FRANKENPHP_VERSION PHP $PHP_VERSION Caddy' -X 'github.com/caddyserver/caddy/v2.CustomBinaryName=frankenphp' -X 'github.com/caddyserver/caddy/v2/modules/caddyhttp.ServerHeader=FrankenPHP Caddy'" -buildvcs=true && \
 	setcap cap_net_bind_service=+ep /usr/local/bin/frankenphp && \
 	cp Caddyfile /etc/frankenphp/Caddyfile && \
 	frankenphp version && \
```

Obraz kontenera w linii: `FROM php-base AS common` zastępujemy przez: `FROM php:8.5-zts-trixie AS common`
Następnie w linii: `COPY --from=golang-base /usr/local/go /usr/local/go` podstawiamy obraz: `golang:1.26-trixie`
Obie wartości można znaleźć w pliku `docker-bake.hcl`.

Kolejnym krokiem jest usunięcie flag `-w -s` z parametru ldflags, aby zachować symbole debugowania, oraz dodanie flagi: `-gcflags "all=-N -l"`.
Dzięki temu kompilator wyłączy optymalizacje utrudniające debugowanie.
Budujemy obraz: `docker build -t gnu-ext -f Dockerfile  .`

Następnie w projekcie PHP możemy użyć go zamiast bazowego obrazu: `dunglas/frankenphp:1-php8.5-trixie`.

W konfiguracji usługi w Docker Compose musimy wprowadzić kilka zmian, aby uruchamiać powłokę zamiast serwera FrankenPHP oraz umożliwić działanie Delve:

```
services:
  frankenphp:
    # ....
    entrypoint: "/usr/bin/bash"
    tty: true
    cap_add:
      - SYS_PTRACE
    ports:
      - "2345:2345"
```

Uruchamiamy kontener: `docker compose up -d`.
Logujemy się do niego: `docker compose exec frankenphp bash`

W kontenerze instalujemy Go w tej samej wersji, która została użyta do zbudowania FrankenPHP.
W moim przypadku konieczne było dodanie repozytorium `debian-backports`:

```
tee /etc/apt/sources.list.d/debian-backports.sources > /dev/null <<'EOF'
Types: deb deb-src
URIs: http://deb.debian.org/debian
Suites: trixie-backports
Components: main
Enabled: yes
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
EOF
```

Następnie aktualizujemy listę pakietów i instalujemy Go 1.26 z nowo dodanego repozytorium:
`apt update -y && apt install -y -t trixie-backports golang-1.26`

Po zainstalowaniu Go instalujemy Delve: `/usr/lib/go-1.26/bin/go install github.com/go-delve/delve/cmd/dlv@latest`
Na końcu uruchamiamy Delve wraz z FrankenPHP:
`/root/go/bin/dlv exec /usr/local/bin/frankenphp --listen=:2345 --headless=true --api-version=2 --accept-multiclient --only-same-user=false --check-go-version=false -- run  --config /etc/frankenphp/Caddyfile --adapter caddyfile`

FrankenPHP nie uruchomi się, dopóki debugger nie połączy się z portem 2345.
W GoLandzie wystarczy skonfigurować "Run/Debug Configuration" typu "Go Remote" i podłączyć się do działającego procesu Delve.
