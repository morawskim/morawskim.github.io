# geodistance

## PHP
Poniższy algorytm został wyciągnięty z serwera redis - https://github.com/antirez/redis/blob/b2cd9fcab6122ccbf8b08f71f59a0af01931083b/src/geohash_helper.c#L211
Zawiera on pewne ograniczenia - https://redis.io/commands/geoadd#what-earth-model-does-it-use
>It just assumes that the Earth is a sphere, since the used distance formula is the Haversine formula. This formula is only an approximation when applied to the Earth, which is not a perfect sphere. The introduced errors are not an issue when used in the context of social network sites that need to query by radius and most other applications. However in the worst case the error may be up to 0.5%, so you may want to consider other systems for error-critical applications.

```
<?php

const EARTH_RADIUS_IN_METERS = 6372797.560856;

function deg_rad(float $deg) {
    return $deg * M_PI/180;
}

/**
* Calculate distance using haversin great circle distance formula.
* Return distance in meters
*/
function geohashGetDistance(
    float $lon1d,
    float $lat1d,
    float $lon2d,
    float $lat2d
): float {
    $lat1r = deg_rad($lat1d);
    $lon1r = deg_rad($lon1d);
    $lat2r = deg_rad($lat2d);
    $lon2r = deg_rad($lon2d);
    $u = sin(($lat2r - $lat1r) / 2);
    $v = sin(($lon2r - $lon1r) / 2);
    return 2.0 * EARTH_RADIUS_IN_METERS *
           asin(sqrt($u * $u + cos($lat1r) * cos($lat2r) * $v * $v));
}

//distance between plock and warsaw
var_dump(geohashGetDistance(
    52.5400381,
    19.6289084,

    52.2326063,
    20.7810086
)/1000);

```
Wynik:
double(132.10064834711)

## Redis

Zawartość pliku `redis-data` z poleceniami.
```
GEOADD TEST 52.5400381 19.6289084 "plock"
GEOADD TEST 52.2326063 20.7810086 "warszawa"
GEODIST TEST plock warszawa km
```

```
cat redis-data | redis-cli
```

Wynik
```
(integer) 0
(integer) 0
"132.1008"
```
