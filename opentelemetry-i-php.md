# OpenTelemetry i PHP

## TracerProvider

Instalujemy pakiety: `composer require open-telemetry/sdk`

Jeśli korzystamy z globalnych instancji typu <Signal>Provider (np. TracerProvider) za pomocą `\OpenTelemetry\API\Globals::tracerProvider()`, to domyślnie są one zarejestrowane jako no-op (puste) dostawcy – nie tworzą spanów ani nie eksportują żadnych danych.

Aby aktywować śledzenie, musimy ręcznie zarejestrować właściwego providera, np.:
```
// ....

$tracerProvider = TracerProvider::builder()->addSpanProcessor(
    new SimpleSpanProcessor(
        (new ConsoleSpanExporterFactory())->create()
    )
)->build();

$configurator = Configurator::create()
    ->withTracerProvider($tracerProvider);

$scope = $configurator->activate();

// ....
```

Po tym wywołaniu Globals::tracerProvider() zwraca realnego providera, który działa zgodnie z konfiguracją (np. eksportuje trace'y do OTLP).

### ResourceDetectorInterface

ResourceDetector służy do automatycznego wykrywania i uzupełniania informacji o zasobie, na którym działa aplikacja (np. nazwa hosta, adres IP, region).
Istnieją już gotowe detektory dla niektórych popularnych dostawców chmury.
Możemy także utworzyć własny detektor dla naszej aplikacji implementując interfejs `\OpenTelemetry\SDK\Resource\ResourceDetectorInterface`.

```
\OpenTelemetry\SDK\Registry::registerResourceDetector('myapp', new class implements  \OpenTelemetry\SDK\Resource\ResourceDetectorInterface {
    public function getResource(): \OpenTelemetry\SDK\Resource\ResourceInfo
    {
        return \OpenTelemetry\SDK\Resource\ResourceInfo::create(
            \OpenTelemetry\SDK\Common\Attribute\Attributes::create([
                'app.version' => '0.1.1',
                'app.foo' => 'bar'
            ])
        );
    }
});

```
