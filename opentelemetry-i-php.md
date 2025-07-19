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
