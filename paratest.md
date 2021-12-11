# ParaTest

[ParaTest](https://github.com/paratestphp/paratest) umożliwia nam uruchomienie testów PHPUnit równolegle. Znacząco skraca to czas potrzebny do wykonania testów. Uruchomienie 292 testów w 4 procesach trwało 01:44 w porównaniu do 05:09.

` ./vendor/bin/paratest --processes=4 --runner WrapperRunner -c /var/www/html/phpunit.xml.dist --group integration`

## friendsofsymfony/elastica-bundle

Mając w aplikacji testy integracyjne z bundle elastica-bundle natrafimy na problem uruchamiania wielu testów równolegle. ParaTest przekazuje zmienną środowiskową `TEST_TOKEN`, którą możemy wykorzystać w środowisku testowym. Jej wartość wykorzystujemy do nazwy indeksu. Dzięki temu każdy proces będzie wykorzystywał oddzielny indeks ElasticSearch.

```
parameters:
    test_token: 1

fos_elastica:
    # ...
    indexes:
        offer:
            index_name: 'offer_%env(default:test_token:TEST_TOKEN)%'
            # ...
```

Dodatkowo przyda nam się usługa do resetu indeksu ElasticSearch.
Po wywołaniu metody `replaceIndex` warto poczekać parę sekund (w moim przypadku 2s wystarczyło), aby ElasticSearch zaczął zwracać zindeksowane dane.

```
# src/Tests/OfferIndexingService.php
<?php

namespace App\Tests;

use FOS\ElasticaBundle\Index\Resetter;
use FOS\ElasticaBundle\Persister\ObjectPersisterInterface;

class OfferIndexingService
{
    private ObjectPersisterInterface $objectPersister;

    private Resetter $resetter;

    public function __construct(ObjectPersisterInterface $objectPersister, Resetter $resetter)
    {
        $this->objectPersister = $objectPersister;
        $this->resetter = $resetter;
    }

    public function replaceIndex(array $offers): void
    {
        $this->resetter->resetIndex('offer', true);
        $this->objectPersister->insertMany($offers);
        $this->resetter->switchIndexAlias('offer', true);
    }
}

```

```
# config/services_test.yaml

services:
  App\Tests\OfferIndexingService:
    public: true
    arguments:
      $objectPersister: '@fos_elastica.object_persister.offer'
      $resetter: '@fos_elastica.resetter'
# ...
```
