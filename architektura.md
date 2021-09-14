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


## Reguły/Dobre praktyki

Polymorphism - ten sam interfejs, różne zachowania

Zachowanie obiektu w trakcie działania programu jest definiowane przez definicję klasy

Klasy możemy podzielić na dwie kategorie: usługi i obiekty które przechowują jakieś dane.

Usługa nie powinna otrzymywać całej globalnej konfiguracji, a tylko wartości które potrzebuje. Niektóre z tych wartości są zawsze używane razem dlatego powinny być przekazywane razem, aby nie łamać ich spójności.

Service locator - usługa z której możemy pobierać inne usługi.

Usługi powinny być niemodyfikowalne po utworzeniu.

Nie wszystkie funkcje muszą być owinięte w obiekty. Najczęściej stosuje się je (do np. funkcji json_encode) gdy chcemy mieć możliwość zastąpienia lub wzbogacenia zachowania funkcji. Albo chcemy takie zachowanie oddzielnie przetestować, bo logika jest bardziej złożona.

Przekazując pewne zależności do usługi chcemy wiedzieć wcześniej czy wszystkie warunki są spełnione. Warto korzystać w takich przypadkach z fabryk. Np. fabryka tworząca usługę do logowania błędów może upewnić się czy proces ma uprawnienia do zapisu, a także utworzyć niezbędne katalogi. W przypadku braku uprawnień otrzymamy błąd znacznie wcześniej niż w momencie wywołania zapisu.

Dobrą praktyką jest nieujawnianie wewnętrznego statu tylko dla potrzeb testów. Robimy to tylko gdy jakiś klient to potrzebuje.

Kiedy porównujemy obiekty w testach powinniśmy korzystać z asercji `assertEquals`. Raczej nie chcemy sprawdzać czy oba obiekty odnoszą się do tego samego adresu pamięci.

Jak tylko aplikacja przekracza granice systemu powinniśmy wprowadzić abstrakcję, która ukryje szczegóły implementacji.

Powiniemy wyodrębnić metodę do klasy jeśli:

* jest zbyt duża
* musimy ją przetestować oddzielnie
* przekracza granicę systemu

W przeciwnym przypadku wyodrębnienie takiej metody może spowodować zbyt duża ilość klas i problemy z czytelnością kody (masę przeskoków między klasami)

Query methods nie powinny być mokowane w testach. Nie powinniśmy także testować ilości wywołań wykonanych do nich.
Te metody z definicji są bez skutków ubocznych, więc możemy je bezpiecznie wywołać wiele razy.

Encje reprezentują domenę biznesową. Zawierają istotne dane i dostarczają użyteczne zachowania powiązane z tymi danymi.

### Książki

Matthias Noback, _Object Design Style Guide_, Manning
