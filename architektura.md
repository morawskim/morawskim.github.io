# Architektura

Paradygmat Command-Query-Seperation - W kontekście programowania obiektowego, sprowadza się do reguły: każda metoda klasy powinna być zaliczana do kategorii `command` albo `query`, ale nigdy obu. Metoda typu `command` zmieniają stan obiektu, zaś metody typu `query` odpytują o stan. Podczas testowania najczęściej będziemy używać dublera typu `Mock` dla metody typu `command` (aby upewnić się, czy aby na pewno rozkazy zostały wysłane w spodziewany sposób). W przypadku metod typu query najczęściej korzystamy z dublera typu `Stub`.

## TDD

`Dummy` (zaślepka) - nieużywane parametry, których istnienie jest wymuszane przez kompilator.

`Fake` - uproszczone implementacje obiektów zależnych np. baza danych in-memory.

`Stub` - "uczymy je", jak mają się zachowywać, ale nie weryfikujemy interakcji odbytej z nimi.

`Mock` - pozwala bardzo precyzyjnie zweryfikować interakcję pomiędzy obiektami.

## DDD

Eric Evans, _Domain-Driven Design. Zapanuj nad złożonym systemem informatycznym_, Helion

Harry Percival i Bob Gregory, _Architektura aplikacji w Pythonie. TDD, DDD i rozwój mikrousług reaktywnych_, Helion

>Warstwy mają być luźno związane, a zależności projektowe muszą być tylko jednokierunkowe. Warstwy wyższe mogą w prosty sposób używać elementów warstw niższych poprzez wykorzystanie ich interfejsów publicznych, przechowując odwołania do nich (choćby tymczasowo) — ogólnie rzecz biorąc, używając standardowych sposobów komunikacji. Jednakże w przypadku, gdy obiekt warstwy niższej potrzebuje skomunikować się w górę (nie mówimy o zwykłej odpowiedzi na zapytanie), musimy skorzystać z innego mechanizmu, używając w tym celu wzorca architektonicznego do łączenia warstw w rodzaju odwołań zwrotnych (callbacks) albo OBSERWATORÓW.


> Odróżnienie USŁUG z warstwy aplikacji od tych z warstwy dziedziny może być już trudniejszym zadaniem. Warstwa aplikacji odpowiedzialna jest za zamówienie powiadomienia. Warstwa dziedziny natomiast będzie odpowiedzialna za stwierdzenie, czy poziom graniczny salda został już osiągnięty.


> Każda operacja musi być atomowa. Wszystkie informacje potrzebne do utworzenia kompletnego produktu muszą być przekazane podczas jednego odwołania do FABRYKI. Należy również zdecydować o zachowaniu w sytuacji wystąpienia błędu podczas tworzenia obiektu,
> jeżeli pewne niezmienniki nie zostaną spełnione. W takim przypadku można zwrócić wyjątek lub po prostu wartość null. W celu zachowania spójności należy rozważyć użycie standardu kodowania do obsługi błędów w FABRYCE.


>Nazywaj klasy oraz operacje w taki sposób, aby opisywały swój cel lub działanie bez odwoływania się do środków, których do tego używają. Uwolni to osobę programującą kod klienta od konieczności zrozumienia szczegółów wewnętrznych kodu. Wszystkie te nazwy powinny składać się na JĘZYK WSZECHOBECNY, aby wszyscy członkowie zespołu mogli szybko domyślić się ich znaczenia. Przed utworzeniem kodu napisz najpierw dla niego test, aby wymusić na sobie sposób myślenia późniejszego użytkownika. Cały skomplikowany mechanizm powinien być schowany za abstrakcyjnymi interfejsami, operującymi opisem celu, a nie prowadzącego do niego środka.
>W publicznych interfejsach dziedziny określ relacje oraz reguły, jednak nie wspominaj o tym, jak są one wymuszane. Opisuj zdarzenia oraz akcje, jednak nie wspominaj nic o ich implementacji.

> Prawo postela (ang. Postel's law) zwane również zasadą solidności (ang. robustness principle), głosi "Stosuj liberalne zasady na wejściu i konserwatywne na wyjściu.

> Domena to zgrabne słowo oznaczające problem, który próbujesz rozwiązać.

> Niezmiennik to warunek, który zawsze jest spełniony.

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

Oddzielajmy to, co chcemy zrobić, od tego, jak to zrobić.

Tworzenie Data Transfer Object delegujemy do innego obiektu tzw. Assembler. Odpowiada on za tworzenie obiektów transferu danych na podstawie obiektów modelu dziedziny, do aktualizowania zawartości modelu dziedziny na podstawie informacji przekazanych w DTO, a także tworzeniu obiektu dziedziny na podstawie DTO. Sama logika tych metod zależy od wymagań biznesowych. W przypadku braku obiektu dziedziny w relacji należy rzucać wyjątek czy też tworzyć nowy obiekt dziedziny.

W przypadku serializacji Data Transfer Object musimy wybrać między serializacją tekstową a binarną. W przypadku binarnej musimy przemyśleć wersjonowanie. Najprostsze binarne rozwiązania generują problemy w przypadku dodania nowego pola. Ten problem nie występuje przy serializacji tekstowej np. JSON.

Podczas korzystania z wzorca Optimistic Offline Lock powinniśmy korzystać z inkrementacji numeru wersji niż z znacznika czasu. Wynika to z faktu, że bardzo trudno jest polegać na zegarze systemowym na różnych serwerach.

Optimistic Offline Lock może być także używany do wykrywania niespójnych operacji odczytu. Np. obliczanie należnego podatku zależy od adresu użytkownika. Sesja musi więc sprawdzić numer wersji adresu. Ten problem można rozwiązać przez dodanie adresu do zbioru modyfikacji lub przechowywanie odrębnej listy elementów, których numery wersji należy sprawdzić.

W widoku mając instrukcję warunkową, ważne jest by wartość warunku była wyznaczana na podstawie jednej logicznej właściwości obiektu pomocniczego.

## ADR - Architectural Decision Records

Każdą decyzję architektoniczną powinniśmy dokumentować w ADR - Architectural Decision Records.
ADR składa się z krótkiego pliku tekstowego opisującego konkretną decyzję architektoniczną. Do zarządzania dokumentami ADR możemy skorzystać z [ADR-tools](https://github.com/npryce/adr-tools).

Struktura ADR składa się z pięciu głównych sekcji: Tytuł, Status, Kontekst, Decyzja i Konsekwencje.
Niektórzy dodają jeszcze sekcje: Zgodność, Uwagi, czy też Inne rozwiązania.

Szablon:

```
# NUMBER. TITLE

Date: DATE

## Status

proposed|accepted|deprecated|superseded

## Context

The issue motivating this decision, and any context that influences or constrains the decision.

## Decision

The change that we're proposing or have agreed to implement.

## Consequences

What becomes easier or more difficult to do and any risks introduced by the change that will need to be mitigated.

## Compatibility

## Remarks

```

### Sekcje ADR

Tytuł powinien być wystarczająco opisowy, aby usunąć wszelkie niejasności co do charakteru i kontekstu decyzji, ale jednocześnie krótki i zwięzły.

Status - proposed|accepted|deprecated|superseded

Kontekst - określa czynniki wpływające na decyzję. Innym słowy, "Jaka sytuacja zmusza mnie do podjęcia tej decyzji". Ta część ADR umożliwia architektowi opisanie określonej sytuacji lub problemu i zwięzłe omówienie możliwych alternatyw.
W przypadku szczegółowej analizy każdego z tych alternatywnych rozwiązań, można dołączyć do ADR dodatkową sekcję "Inne rozwiązania".

Decyzja - zawiera decyzję architektoniczną wraz z pełnym jej uzasadnieniem. [...] Prawdopodobnie jednym z najistotniejszych aspektów sekcji Decyzja w dokumencie ADR jest to, że pozwala ona architektowi położyć większy nacisk na to, dlaczego, a nie jak. Zrozumienie, dlaczego decyzja została podjęta, jest o wiele ważniejsze niż zrozumienie jak coś działa.

Konsekwencje - dokumentuje ona ogólny wpływ decyzji architektonicznej. Każda decyzja architektoniczna podejmowana przez architekta wywiera pewien wpływ, zarówno dobry, jak i zły. Konieczność określenia wpływu decyzji architektonicznej zmusza architekta do zastanowienia się, czy ten wpływ nie przeważą nad wynikającymi z niej korzyściami.
Innym dobrym sposobem wykorzystania tej sekcji jest udokumentowanie analizy kompromisów związanych z decyzją architektoniczną.

Zgodność - sekcja zgodności nie należy do standardowych sekcji ADR. [...] Sekcja zmusza architekta do zastanowienia się nad sposobem pomiaru decyzji architektonicznej i zarządzania nią z punktu widzenia zgodności. Architekt musi zdecydować, czy kontrola zgodności dla tej decyzji będzie manualna, czy też może być zautomatyzowana przez użycie funkcji dopasowania. Do mierzenia możemy skorzystać z:

* [Deptrac is a static code analysis tool for PHP that helps you communicate, visualize and enforce architectural decisions in your projects](https://github.com/qossmic/deptrac)

* [Unit test your Java architecture](https://www.archunit.org/)

* [PHP Architecture Tester - Easy to use architectural testing tool for PHP](https://github.com/carlosas/phpat)

* [PHPArch is a work in progress architectural testing library for PHP projects. It is inspired by archlint (C#) and archunit (java)](https://github.com/j6s/phparch)

Uwagi - nie jest częścią standardowego ADR. Zawiera ona rożne metadane dotyczące ADR np.:

* pierwotny autor

* data zatwierdzenia

* zatwierdzone przez

* data zastąpienia

* data ostatniej modyfikacji

* zmodyfikowane przez

* ostatnia modyfikacja


[Managing Architecture Decision Records with ADR-Tools](https://www.hascode.com/2018/05/managing-architecture-decision-records-with-adr-tools/)

[Documenting Architecture Decisions](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions)

Trzy główne antywzorce architektoniczne:

* Obrona swojego stanowiska - ma on miejsce wówczas, gdy architekt unika podjęcia decyzji architektonicznej lub odracza ją z obawy przed dokonaniem złego wyboru.

* Dzień świstaka - występuje on, gdy ludzie nie wiedzą, dlaczego dana decyzja została podjęta, więc dyskusja o niej toczy się bez końca. [...] Antywzorzec Dzień Świstaka występuje w sytuacji, gdy architekt podejmuje decyzję architektoniczną i nie potrafi jej uzasadnić (lub podać pełnego uzasadnienia). Przy argumentowaniu decyzji architektonicznych ważne jest, aby podać zarówno techniczne, jak i biznesowe uzasadnienie swojej decyzji.

* Architektura Sterowana Wiadomościami E-mail - występuje on wtedy, gdy decyzja architektoniczna została podjęta, ale ludzie przestali śledzić proces decyzyjny, zapomnieli o danej decyzji lub nawet nie wiedzą, że została podjęta, i dlatego nie mogą jej wdrożyć. W tym antywzorcu chodzi o skuteczne komunikowanie Twoich decyzji architektonicznych. E-mail jest doskonałym narzędziem komunikacji, ale kiepskim systemem przechowywania dokumentów.

### Książki

Matthias Noback, _Object Design Style Guide_, Manning

Martin Fowler, _Architektura systemów zarządzania przedsiębiorstwem. Wzorce projektowe_, Helion

Mark Richards i Neal Ford, _Podstawy architektury oprogramowania dla inżynierów_, Helion
