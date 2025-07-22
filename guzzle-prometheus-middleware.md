# Guzzle Prometheus middleware

Przykładowa konfiguracja histogramu:
```
$histogram = $collectorRegistry->getOrRegisterHistogram(
    $namespace,
    'guzzle_response_duration_ms',
    'Guzzle response duration histogram',
    ['method', 'url', 'status_code'],
    [
        75,
        100,
        250,
        500,
        750,
        1000,
        2500,
        5000,
        7500,
        10000,
    ]
);
```

Middleware:
```
<?php

namespace myapp\infrastructure\http;

use GuzzleHttp\Psr7\Request;
use GuzzleHttp\Psr7\Response;
use Prometheus\Histogram;

class GuzzlePrometheusMiddleware
{
    public function __construct(private readonly Histogram $histogram)
    {
    }

    /**
     * Middleware that calculates the duration of a guzzle request.
     * After calculation it sends metrics to prometheus.
     *
     * @param callable $handler
     *
     * @return callable Returns a function that accepts the next handler.
     */
    public function __invoke(callable $handler) : callable
    {
        return function (Request $request, array $options) use ($handler) {
            $start = hrtime(true);
            return $handler($request, $options)->then(
                function (Response $response) use ($request, $start) {
                    $this->histogram->observe(
                        (hrtime(true) - $start) / 1e+6,
                        [
                            $request->getMethod(),
                            $request->getUri()->getHost() . $request->getUri()->getPath(),
                            $response->getStatusCode(),
                        ]
                    );
                    return $response;
                }
            );
        };
    }
}

```
