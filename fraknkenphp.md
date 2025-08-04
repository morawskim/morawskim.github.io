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
