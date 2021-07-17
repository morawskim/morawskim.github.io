# Architektura

Paradygmat Command-Query-Seperation - W kontekście programowania obiektowego, sprowadza się do reguły: każda metoda klasy powinna być zaliczana do kategorii `command` albo `query`, ale nigdy obu. Metoda typu `command` zmieniają stan obiektu, zaś metody typu `query` odpytują o stan. Podczas testowania najczęściej będziemy używać dublera typu `Mock` dla metody typu `command` (aby upewnić się, czy aby na pewno rozkazy zostały wysłane w spodziewany sposób). W przypadku metod typu query najczęściej korzystamy z dublera typu `Stub`.

## TDD

`Dummy` (zaślepka) - nieużywane parametry, których istnienie jest wymuszane przez kompilator.

`Fake` - uproszczone implementacje obiektów zależnych np. baza danych in-memory.

`Stub` - "uczymy je", jak mają się zachowywać, ale nie weryfikujemy interakcji odbytej z nimi.

`Mock` - pozwala bardzo precyzyjnie zweryfikować interakcję pomiędzy obiektami.

## DDD

Eric Evans, _Domain-Driven Design. Zapanuj nad złożonym systemem informatycznym_, Helion

>Warstwy mają być luźno związane, a zależności projektowe muszą być tylko jednokierunkowe. Warstwy wyższe mogą w prosty sposób używać elementów warstw niższych poprzez wykorzystanie ich interfejsów publicznych, przechowując odwołania do nich (choćby tymczasowo) — ogólnie rzecz biorąc, używając standardowych sposobów komunikacji. Jednakże w przypadku, gdy obiekt warstwy niższej potrzebuje skomunikować się w górę (nie mówimy o zwykłej odpowiedzi na zapytanie), musimy skorzystać z innego mechanizmu, używając w tym celu wzorca architektonicznego do łączenia warstw w rodzaju odwołań zwrotnych (callbacks) albo OBSERWATORÓW.


> Odróżnienie USŁUG z warstwy aplikacji od tych z warstwy dziedziny może być już trudniejszym zadaniem. Warstwa aplikacji odpowiedzialna jest za zamówienie powiadomienia. Warstwa dziedziny natomiast będzie odpowiedzialna za stwierdzenie, czy poziom graniczny salda został już osiągnięty.


> Każda operacja musi być atomowa. Wszystkie informacje potrzebne do utworzenia kompletnego produktu muszą być przekazane podczas jednego odwołania do FABRYKI. Należy również zdecydować o zachowaniu w sytuacji wystąpienia błędu podczas tworzenia obiektu,
> jeżeli pewne niezmienniki nie zostaną spełnione. W takim przypadku można zwrócić wyjątek lub po prostu wartość null. W celu zachowania spójności należy rozważyć użycie standardu kodowania do obsługi błędów w FABRYCE.


>Nazywaj klasy oraz operacje w taki sposób, aby opisywały swój cel lub działanie bez odwoływania się do środków, których do tego używają. Uwolni to osobę programującą kod klienta od konieczności zrozumienia szczegółów wewnętrznych kodu. Wszystkie te nazwy powinny składać się na JĘZYK WSZECHOBECNY, aby wszyscy członkowie zespołu mogli szybko domyślić się ich znaczenia. Przed utworzeniem kodu napisz najpierw dla niego test, aby wymusić na sobie sposób myślenia późniejszego użytkownika. Cały skomplikowany mechanizm powinien być schowany za abstrakcyjnymi interfejsami, operującymi opisem celu, a nie prowadzącego do niego środka.
>W publicznych interfejsach dziedziny określ relacje oraz reguły, jednak nie wspominaj o tym, jak są one wymuszane. Opisuj zdarzenia oraz akcje, jednak nie wspominaj nic o ich implementacji.
