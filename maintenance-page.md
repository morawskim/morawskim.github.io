# Maintenance page

Podczas migracji lub wdrożenia często musimy wyłączyć stronę. Obecnie aplikacje korzystają z wzorca `Front Controller`. Rozwiązanie te polega na użycie pojedynczego pliku PHP, przez który przetwarzane są wszystkie żądania HTTP. Zmieniając więc ten plik, możemy zwrócić status HTTP `503` z komunikatem. Zwracanie statusu `503` uchroni nas przed zindeksowaniem strony, kiedy jest wyłączona. Możemy rozbudować przykład i zezwolić na dostęp do strony tylko osobom z określonych adresów IP.

``` php
<?php
header('HTTP/1.1 503 Service Temporarily Unavailable');
header('Status: 503 Service Temporarily Unavailable');
header('Retry-After: 3600');
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>503 Service Temporarily Unavailable</title>
</head>
<body>
<h1>Service Temporarily Unavailable</h1>
<p>The server is temporarily unable to service your request due to maintenance downtime. Please try again later.</p>
</body>
</html>
```

[Maintenance page with Nginx with specific permitted access](https://www.sonassi.com/blog/knowledge-base/maintenance-page-with-nginx-with-specific-permitted-access)

[Nginx maintenance page](https://coderwall.com/p/tlkarq/nginx-maintenance-page)
