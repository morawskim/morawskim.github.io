# Buggregator

[Buggregator](https://buggregator.dev) to serwer zawierający parę aplikacji ułatwiających debugowania, zaprojektowany głównie z myślą o PHP.
Jeśli korzystamy z docker to najprościej jest dodać nową usługę "buggregator" do pliku `docker-compose.yml`.

```
services:
  # ...
  buggregator:
    image: ghcr.io/buggregator/server:latest
    ports:
      - 127.0.0.1:8000:8000 # HTTP Dumps, Sentry, Ray, Inspector, XHProf
      - 127.0.0.1:1025:1025 # SMTP
      - 127.0.0.1:9912:9912 # Symfony Var-Dumper
      - 127.0.0.1:9913:9913 # Monolog
```

## Xhprof

Instalujemy rozszerzenie PHP `xhprof` - `pecl install xhprof`.
Następnie włączamy rozszerzenie. W przypadku korzystania z oficjalnego obrazu PHP Docker wywołujemy polecenie `docker-php-ext-enable xhprof`

Instalujemy pakiet "spiral-packages/profiler" wykorzystując composer - `composer require --dev spiral-packages/profiler`.
Konfigurujemy bibliotekę z Buggregator.

```
$httpClient = new Symfony\Component\HttpClient\NativeHttpClient();
$profilerStorage = new SpiralPackages\Profiler\Storage\WebStorage(
    $httpClient,
    'http://buggregator:8000/api/profiler/store'
);
$profiler = new SpiralPackages\Profiler\Profiler(
    $profilerStorage,
    SpiralPackages\Profiler\DriverFactory::createXhrofDriver(),
    'Demo Integration'
);
$profiler->start();
```

Na końcu profilowanej metody wywołujemy `$profiler->end();`, aby zakończyć profilowanie i przesłać dane do Buggregator.
W przypadku korzystania z framework Symfony możemy skorzystać z [gotowego bundle](https://github.com/iluckhack/xhprof-buggregator-bundle).

## Ray

W Golang instalujemy pakiet go-ray - `go get github.com/octoper/go-ray`.
W przypadku korzystania z Buggregator w dockerze zgodnie z przykładem powyżej to konfigurujemy połączenie w następujący sposób:

```
app := ray.Ray()
app.Enable()
app.SetHost("ray@127.0.0.1")
app.SetPort(8000)
```

Aby przesłać zawartość zmiennej `variableWhichContainsSomeData` do Ray korzystamy z kodu - `ray.Ray(variableWhichContainsSomeData)`.
