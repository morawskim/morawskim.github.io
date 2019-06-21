# Odległość między punktami geograficznymi

## javascript

https://github.com/googlemaps/js-marker-clusterer/blob/8c2be07696e0c8789a4e314e12fc698622bf8323/src/markerclusterer.js#L723

``` javascript
function(p1, p2) {
  if (!p1 || !p2) {
    return 0;
  }

  var R = 6371; // Radius of the Earth in km
  var dLat = (p2.lat() - p1.lat()) * Math.PI / 180;
  var dLon = (p2.lng() - p1.lng()) * Math.PI / 180;
  var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(p1.lat() * Math.PI / 180) * Math.cos(p2.lat() * Math.PI / 180) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  var d = R * c;
  return d;
};
```

## pgsql function

``` sql
create function distance(lat1 double precision, lon1 double precision, lat2 double precision, lon2 double precision) returns double precision
    security definer
    language plpgsql
as
$$
DECLARE
    d  double precision;
    f1 double precision;
    f2 double precision;
    de double precision;
BEGIN
  f1 = RADIANS(lat1);
  f2 = RADIANS(lat2);
  de = RADIANS(lon2-lon1);

  d  = ACOS( SIN(f1)*SIN(f2) + COS(f1)*COS(f2)*COS(de) ) * 6371000 ;

    RETURN d;
END;
```

## redis

[Redis zawiera komendę GEODIST do obliczania odległości między punktami. Ten algorytm wyciągnąłem już wcześniej](redis-debugging.md)

https://github.com/antirez/redis/blob/0cabe0cfa7290d9b14596ec38e0d0a22df65d1df/src/geohash_helper.c#L211

``` cpp
double geohashGetDistance(double lon1d, double lat1d, double lon2d, double lat2d) {
    double lat1r, lon1r, lat2r, lon2r, u, v;
    lat1r = deg_rad(lat1d);
    lon1r = deg_rad(lon1d);
    lat2r = deg_rad(lat2d);
    lon2r = deg_rad(lon2d);
    u = sin((lat2r - lat1r) / 2);
    v = sin((lon2r - lon1r) / 2);
    return 2.0 * EARTH_RADIUS_IN_METERS *
           asin(sqrt(u * u + cos(lat1r) * cos(lat2r) * v * v));
}
```
