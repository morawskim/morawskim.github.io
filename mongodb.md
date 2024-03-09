# MongoDB

## Porady/Dobre praktyki

* Serwer podległy powinien mieć możliwość pozostania w trybie offline przez przynajmniej 8 godzin. Zwiększenie wielkości dziennika zdarzeń replikacji zapewni dodatkową ilość czasu w przypadku awarii sieci itd. Dzięki temu możemy uniknąć konieczności ponownej pełnej synchronizacji któregokolwiek węzła.

* Za pomocą parametru `wtimeout` możemy określić maksymalny czas oczekiwania na potwierdzenie, że operacja zapisu została zreplikowana. Jeśli błąd ma być zgłoszony gdy wymagany poziom replikacji nie zostanie osiągnięty w trakcie 500ms, to parametrowi `wtimeout` przypisujemy wartość 500. Jeśli nie podamy wartości dla `wtimeout`, a replikacja z jakiegokolwiek powodu nigdy nie wystąpi, operacja będzie blokowała aplikację w nieskończoność.

* Zasada osadzania dokumentu vs oddzielna kolekcja -  użyj osadzania dokumentu jeśli obiekt potomny nigdy nie pojawia się poza kontekstem jego obiektu nadrzędnego. W przeciwnym razie obiekty potomne przechowuj w oddzielnej kolekcji. W przypadku osadzenia dokumentów mamy nieco większą wydajność działania, natomiast odwołania zapewniają większą elastyczność.

* Warto utworzyć kopie wszystkich dokumentów w kolekcji, gdy pracujemy nad skryptem który ma np. dostosować dane do nowego formatu.
Do tego celu możemy wykorzystać [etap $out agregacji](https://www.mongodb.com/docs/manual/reference/operator/aggregation/out/).
Wywołując zapytanie `db.NazwaKolekcji.aggregate([{$out: "NazwaKolekcjiKopia"}])` pobierzemy wszystkie dokumenty z kolekcji NazwaKolekcji i zapiszemy je do kolekcji NazwaKolekcjiKopia.
Dzięki temu możemy wielokrotnie uruchamiać nasz skrypt, który może ciągle działać na oryginalnych danych (musimy tylko skasować oryginalną kolekcje i przekopiować dane z kopii).

## PHP

Do działania potrzebujemy rozszerzenia PHP mongodb, a także pakiet `mongodb/mongodb`.
[Przykład](https://github.com/morawskim/php-examples/tree/e1bd212ef21a78d3cd8ee912edfb9ab4f7105b5b/mongodb)


```
<?php

use MongoDB\Client;
use MongoDB\Collection;

require_once __DIR__ . '/vendor/autoload.php';

$mongo = new Client('mongodb://admin:adminpassword@mongodb:27017/admin');
$manager = $mongo->getManager();
$collection = new Collection($manager, 'testdb', 'testing');

$collection->updateOne(
    ['foo' => 'bar'],
    [
        '$set' => [
            'foo' => 'bar',
            'text' => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi tincidunt laoreet turpis, in sollicitudin magna maximus sed. Fusce efficitur luctus quam. Donec auctor lectus et eros finibus dignissim. Nullam laoreet, neque vel rutrum aliquam, nibh quam rutrum odio, id auctor dolor enim vel purus. Vivamus suscipit ex massa, porttitor placerat arcu gravida bibendum. Nulla tempus, justo in ullamcorper sollicitudin, nunc mi semper nulla, sed placerat risus odio et nibh. Cras laoreet leo eget dictum tincidunt. In hac habitasse platea dictumst. Maecenas facilisis, enim ac euismod molestie, dolor mauris congue nibh, eu malesuada erat massa nec libero. Morbi a risus in lacus pharetra convallis consectetur eget purus. Duis ullamcorper nulla eu magna maximus, eget congue ex ultricies. Proin tellus est, dictum eget fermentum non, congue vel mi. Morbi fringilla non lorem ut pellentesque. Phasellus lacinia, sem ut lacinia iaculis, turpis arcu viverra mauris, ac maximus eros diam sed enim. Donec ullamcorper ex in lectus ullamcorper facilisis. Curabitur eu mi quis erat elementum laoreet.',
        ]
    ],
    ['upsert' => true]
);
```
