# OpenTelemetry i Golang

## Konfiguracja

Instalujemy wymagane pakiety:

```
go get go.opentelemetry.io/otel \
       go.opentelemetry.io/otel/sdk \
       go.opentelemetry.io/otel/sdk/trace \
       go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracegrpc \
       go.opentelemetry.io/otel/propagation \
       go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp
```

### Traces

W pliku, np. otel.go, konfigurujemy TracerProvider oraz eksport danych telemetrycznych.

```
import (
	// ..
	"go.opentelemetry.io/otel"
	sdktrace "go.opentelemetry.io/otel/sdk/trace"
)

func initTraceProvider(ctx context.Context) (*sdktrace.TracerProvider, error) {
	exporter, err := otlptrace.New(ctx, otlptracegrpc.NewClient())
	if err != nil {
		return nil, err
	}

	tp := sdktrace.NewTracerProvider(
		sdktrace.WithSampler(sdktrace.AlwaysSample()),
		sdktrace.WithBatcher(exporter),
	)

	return tp, err
}
```
