# Architektura

Paradygmat Command-Query-Seperation - W kontekście programowania obiektowego, sprowadza się do reguły: każda metoda klasy powinna być zaliczana do kategorii `command` albo `query`, ale nigdy obu. Metoda typu `command` zmieniają stan obiektu, zaś metody typu `query` odpytują o stan. Podczas testowania najczęściej będziemy używać dublera typu `Mock` dla metody typu `command` (aby upewnić się, czy aby na pewno rozkazy zostały wysłane w spodziewany sposób). W przypadku metod typu query najczęściej korzystamy z dublera typu `Stub`.

## TDD

`Dummy` (zaślepka) - nieużywane parametry, których istnienie jest wymuszane przez kompilator.

`Fake` - uproszczone implementacje obiektów zależnych np. baza danych in-memory.

`Stub` - "uczymy je", jak mają się zachowywać, ale nie weryfikujemy interakcji odbytej z nimi.

`Mock` - pozwala bardzo precyzyjnie zweryfikować interakcję pomiędzy obiektami.
