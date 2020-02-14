# Unit test - clock wrapper

Problemem w testach jednostkowych jest aktualny czas. Nie możemy pobierać informacje o aktualnej dacie przez funkcje/metody dostarczane w wybranym języku. Korzystają one z wywołań systemowych do pobierania aktualnego czasu. Rozwiązaniem tego problemu jest korzystanie z pewnej formy pośrednictwa. Pozwoli ona nam ustawić aktualną datę/godzinę na konkretną wartość.
Dla języka PHP istnieje biblioteka [lcobucci/clock](https://github.com/lcobucci/clock).

Dodajemy tą bibliotekę do projekt `composer require lcobucci/clock`.
Następnie bazujemy na interfejsie `Lcobucci\Clock\Clock`. Klasy implementujące ten interfejs muszą zaimplementować metodę `public function now(): DateTimeImmutable;`.
Dostarczane są dwie implementacje `Lcobucci\Clock\SystemClock` i `Lcobucci\Clock\FrozenClock`.

Przykład ze strony projektu
``` php
<?php

use Lcobucci\Clock\Clock;
use Lcobucci\Clock\SystemClock;
use Lcobucci\Clock\FrozenClock;

function filterData(Clock $clock, array $objects): array
{
    return array_filter(
        $objects,
        function (stdClass $object) use ($clock): bool {
            return $object->expiresAt > $clock->now();
        }
    );
}

// Object that will return the current time based on the given timezone
$clock = new SystemClock(new DateTimeZone('UTC'));

// Test object that always returns a fixed time object
$clock = new FrozenClock(
    new DateTimeImmutable('2017-05-07 18:49:30')
);

$objects = [
    (object) ['expiresAt' => new DateTimeImmutable('2017-12-31 23:59:59')],
    (object) ['expiresAt' => new DateTimeImmutable('2017-06-30 23:59:59')],
    (object) ['expiresAt' => new DateTimeImmutable('2017-01-30 23:59:59')],
];

var_dump(filterData($clock, $objects)); // last item will be filtered
```
