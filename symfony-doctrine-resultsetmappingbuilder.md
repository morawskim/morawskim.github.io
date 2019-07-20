# symfony/doctrine - ResultSetMappingBuilder

Chcąc zbudować bardziej złożone zapytanie SQL, które zwróci nam encję możemy skorzystać z metody `createNativeQuery`. Do tej metody przekazujemy prócz zapytania sql, także instancję `ResultSetMappingBuilder`. Ta klasa odpowiada za automatyczne uzupełnia pól encji. W poniższym przykładzie uzupełnione zostaną wszystkie pola encji `Poi`. Dzięki zastosowaniu klasy `ResultSetMappingBuilder` nie musimy ręcznie mapować kolumn zapytania SQL z polami encji.

``` php
$sql = 'SELECT p.* FROM poi p
        WHERE p.poi_group_id = :poiGroupId
        AND reports.distance(p.lat, p.lon, :lat, :lon) < :maxDistance';

$resultSetMapping = new ResultSetMappingBuilder($this->getEntityManager());
$resultSetMapping->addRootEntityFromClassMetadata(Poi::class, 'p');

return $this->getEntityManager()
    ->createNativeQuery($sql, $resultSetMapping)
    ->execute([
        'poiGroupId' => $poiImportModel->getPoiGroup()->getId(),
        'lat' => $poiImportModel->getLat(),
        'lon' => $poiImportModel->getLon(),
        'maxDistance' => $poiImportModel->getPoiGroup()->getConfMaxRadius(),
    ]);
```
