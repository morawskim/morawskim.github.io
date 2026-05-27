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
