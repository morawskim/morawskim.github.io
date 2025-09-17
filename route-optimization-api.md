# Route Optimization API

Route Optimization API przydziela zadania i generuje trasy dla floty pojazdów, optymalizując je zgodnie z określonymi celami i ograniczeniami transportowymi.

[Route Optimization API](https://developers.google.com/maps/documentation/route-optimization)

## Polyline encoder/decoder

[Encoded Polyline Algorithm Format](https://developers.google.com/maps/documentation/utilities/polylinealgorithm)

### PHP

W PHP instalujemy pakiet za pomocą composer: `composer require emcconville/polyline-encoder`.

Definiujemy klasę wykorzystującą trait `emcconville\Polyline\GoogleTrait`

```
# ...
use emcconville\Polyline\GoogleTrait;

class PolylineEncoder
{
    use GoogleTrait;

    public function __userOverwrites__()
    {
        $cfg = array(
            'precision' => 5,
            'tuple'     => 2
        );

        return array_values($cfg);
    }
}

```

Nadpisanie metody `__userOverwrites__` eliminuje błąd:

> Calling get_class() without arguments is deprecated

Następnie możemy zakodować współrzędne:

```
$svc = new PolylineEncoder();
$encodedPoints = $svc->encodePoints([
    [52.237049,21.017532],
    # ...
]);
```

### JavaScript (Google Map API)

```
const {encoding} = await google.maps.importLibrary("geometry");
// path musi być poprawnym zakodowanym stringiem w formacie encoded polyline.
const arrayOfCoordinates = encoding.decodePath(path);

```
