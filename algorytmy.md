# Algorytmy

### Automatyczne rozwiązywanie konfliktów

Przeprowadzono ciekawe badania nad automatycznym rozwiązywaniem konfliktów spowodowanych
jednoczesnymi modyfikacjami danych. Warto wspomnieć o kilku obszarach takich badań:

* Typy CRDT (ang. conflict-free replicated datatypes) [32, 38] to rodzina struktur danych obejmujących zbiory, odwzorowania, listy uporządkowane, liczniki itd., które mogą być jednocześnie
edytowane przez wielu użytkowników i które automatycznie eliminują konflikty w sensowny sposób. Niektóre typy CRDT zostały zaimplementowane w bazie Riak 2.0 [39, 40].

* Trwałe struktury danych z możliwością scalania [41] bezpośrednio śledzą historię zmian (podobnie jak robi to system kontroli wersji Git) i używają funkcji scalania trójstronnego (w typach CRDT używane jest scalanie dwustronne).

* Mechanizm OT (ang. operational transformation) [42] to algorytm rozwiązywania konfliktów
używany w aplikacjach do edycji zespołowej takich jak Ehterpad [30] i Google Docs [31]. Został
zaprojektowany specjalnie z myślą o jednoczesnej edycji uporządkowanych list elementów, np.
list znaków w dokumencie tekstowym.

[Odnośniki](https://github.com/ept/ddia-references/blob/master/chapter-05-refs.md)

Martin Kleppmann, "Przetwarzanie danych w dużej skali. Niezawodność, skalowalność i łatwość konserwacji systemów"

### Leslie Lamport OTP

Leslie Lamport, "Password Authentication with Insecure Communication", Communications of the ACM 24.11 (November 1981)

[Lamport OTP system](https://security.stackexchange.com/questions/90909/lamport-otp-system)

### Grafy

PHP zawiera bibliotekę [clue/graph](https://github.com/graphp/graph), która pozwala tworzyć grafy.
Dodatkowo [graphp/algorithms](https://github.com/graphp/algorithms) zawiera implementację najpopularniejszych algorytmów dla grafów.

#### Najkrótsza ścieżka

Algorytm Breadth-first służy do obliczenia najkrótszej ścieżki dla grafów bez wagi.
Algorytm Dijkstra oblicza najkrótszą ścieżkę dla grafów z wagami. Jednak ma pewnie ograniczenia. Wagi muszą być dodatnie i graf nie może być cykliczny. Jeśli wagi mogą być ujemne musimy korzystać z innego algorytmu np. Ballman-Ford.

```php
<?php

use Fhaculty\Graph\Graph;

require_once __DIR__ . '/vendor/autoload.php';

$graph = new Graph();
$start = $graph->createVertex('start');
$s1 = $graph->createVertex('s1');
$s2 = $graph->createVertex('s2');
$s3 = $graph->createVertex('s3');
$s4 = $graph->createVertex('s4');
$end = $graph->createVertex('end');

$start->createEdgeTo($s1)->setWeight(5);
$start->createEdgeTo($s2)->setWeight(2);

$s1->createEdgeTo($s3)->setWeight(4);
$s1->createEdgeTo($s4)->setWeight(2);
$s2->createEdgeTo($s1)->setWeight(8);
$s2->createEdgeTo($s4)->setWeight(7);

$s3->createEdgeTo($s4)->setWeight(6);
$s3->createEdgeTo($end)->setWeight(3);
$s4->createEdgeTo($end)->setWeight(1);

//$alg = new \Graphp\Algorithms\ShortestPath\Dijkstra($start);
//echo $alg->getDistance($end);
```

## Programowanie dynamiczne

Algorytmy programowania dynamicznego możemy użyć gdy problem można podzielić na pod problemy, które nie są od siebie zależne. Za ich pomocą możemy rozwiązać problem plecakowy.

[Knapsack Problem: Solve using Dynamic Programming Example](https://www.guru99.com/knapsack-problem-dynamic-programming.html)

[How to solve the Knapsack Problem with dynamic programming](https://medium.com/@fabianterh/how-to-solve-the-knapsack-problem-with-dynamic-programming-eb88c706d3cf)

[Knapsack problem/0-1](https://rosettacode.org/wiki/Knapsack_problem/0-1#PHP)

[Knapsack Solver](https://github.com/Plastonick/knapsack-solver)
