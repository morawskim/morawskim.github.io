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

Zmienianie samych deklaracji importowanych pakietów jest znacznie mniej inwazyjne i ryzykowne niż zmienianie kodu.

Im dalej jest przekazywana pewna decyzja, tym mniejsze będą elastyczność i możliwości późniejszego wprowadzenia zmian. Aby zachować elastyczność, należy starać się udostępniać jak najmniej informacji, i to w możliwie jak najmniejszym zakresie.

Zgłoszenie wyjątku w momencie wykrycia problemy oraz przechwycenie go w miejscu, gdzie problem ten można obsłużyć, jest znacznie lepszym rozwiązaniem niż umieszczenie w kodzie jawnych testów sprawdzających zaistnienie wszystkich możliwych warunków wyjątkowych, z których i tak w danym miejscu  żadnego nie można obsłużyć.

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


## Architektura

`yak shaving` - oznacza wszystkie drobne, pozornie niepowiązane ze sobą zadania wykonywane, zanim będzie można zrobić zadanie, którym pierwotnie chcieliśmy się zająć.

`Złożoność przypadkowa` - pojęcie to odwołuje się do problemu powodowanego przez okreśłone narzędzia i wybrany proces

`Złożoność zasadnicza` - odwołuje się do problemów nieodłącznie wziązanych z tym, nad czym pracujemy.

`Funkcja dopasowania` -  (ang. fitness functions) koncepcja w celu ochrony (i regulacji) parametrów architektury w miarę zmian zachodzących wraz z upływem czasu.

`Architektoniczna funkcja dopasowania` - dowolny mechanizm, który zapewnia obiektywną ocenę integralności niektórych parametrów architektury lub połączenia tych parametrów.

`Kwant architektury` - niezależnie wdrażany artefakt o wysokiej spójności funkcjonalnej i splątaniu synchronicznym. Kwant architektury zawiera wszystkie niezbędne składniki, aby funkcjonować niezależnie od innych części architektury (jeśli aplikacja korzysta z bazy danych jest ona częścią kwantu, ponieważ bez niej system nie będzie działał).
Splątanie synchroniczne zakłada wywołania synchroniczne w kontekście aplikacji lub pomiędzy rozproszonymi usługami, które tworzą kwant tej architektury (usługa, która wywołuje inną usługę synchronicznie nie może wykazywać dużych różnic w dostępności - ogólnie w operacyjnych parametrach architektury).

`Podejście aktor-aktor` - jest popularnym sposobem, który architekci wykorzystują do odwzorowania wymagań na składniki. W tym podejściu, zdefiniowanym pierwotnie w ramach procesu RUP architekci identyfikują aktorów, którzy wykonują czynności przy użyciu aplikacji, oraz działania, które ci aktorzy mogą wykonywać. Dostarcza ono techniki odkrywania typowych użytkowników systemu i tego co mogą oni z nimi zrobić.

`Bryła błota` - to chaotycznie zbudowana, rozległa, niechlujna dżungla o zagmatwanym kodzie, trzymająca się na drucie i taśmie klejącej. Takie systemy wykazują wyraźne oznaki nieuregulowanego wzrostu i powtarzający się doraźnych napraw. Informacje są bezładnie przekazywane pomiędzy odległymi elementami systemu, często do tego stopnia, że prawie wszystkie ważne informacje stają się globalne lub są duplikowane.

### Oczekiwania wobec architekta:

* podejmowanie decyzji architektonicznych

* ciągłe analizowanie architektury

* śledzenie najnowszych trendów

* zapewnienie zgodności z decyzjami

* bogate i zróżnicowane doświadczenie

* wiedza z zakresu biznesu

* umiejętności interpersonalne

* znajomość i umiejętność stosowania polityki firmy

### Prawa architektury oprogramowania

* W architekturze oprogramowania wszystko jest kompromisem. Jeśli architekt uważa, że odkrył coś, co nie jest kompromisem, to najprawdopodobniej jeszcze nie odkrył kompromisu.

* Dlaczego jest ważniejsze niż jak. Architekt może przyjrzeć się istniejącemu systemowi, którego wcześniej nie znał i stwierdzić, jak działa struktura architektury, ale będzie miał trudności z wyjaśnieniem, dlaczego wybrano takie, a nie inne rozwiązanie.

### Wskaźniki architektury
Spójność (ang. cohesion) odnosi się do tego, w jakim stopniu części modułu powinny znajdować się w tym samym module. Innym słowy, jest to miara tego, w jakim stopniu części te są ze sobą powiązane. Idealny moduł spójny to taki, w którym wszystkie części są spakietowane razem, ponieważ rozbicie ich na mniejsze porcje wymagałoby sprzęgania ich za pomocą wywołań między modułami w celu osiągnięcia pożądanych rezultatów.

Miary spójności (od najlepszej do najgorszej):

* spójność funkcjonalna

* spójność sekwencyjna

* spójność komunikacyjna

* spójność proceduralna

* spójność czasowa

* spójność logiczna

* spójność przypadkowa

Próba podzielenia spójnego moduły spowodowałaby jedynie zwiększenie sprzężenia i zmniejszenie czytelności - Larry Constantine

Zastosowanie wskaźnika LCOM może pomóc architektom znaleźć klasy, które są przypadkowo sprzężone i nigdy nie powinny być pojedynczymi klasami. Wiele wskaźników oprogramowania ma poważne braki, dotyczy to również LCOM. Jedyne, co ten wskaźnik może znaleźć, to strukturalny brak spójności, nie ma możliwości logicznego określenia, czy poszczególne elementy pasują do siebie.

Sprzężenie dośrodkowe (ang. afferent coupling) mierzy liczbę połączeń przychodzących do artefaktu kodu (składnika, klasy, funkcji itd.).
Sprzężenie odśrodkowe (ang. efferent coupling) mierzy liczbę połączeń wychodzących do innych artefaktów kodu.

Splątanie (ang. connascence) - Dwa elementy są splątane, jeśli zmiana jednego z nich wymagałaby modyfikacji drugiego w celu utrzymania ogólnej poprawności systemu - Meilir Page-Jones

Ogólnie rzecz biorąc, branżowe wartości progowe dla CC sugerują. że wartość poniżej 10 jest dopuszczalna, pomijając inne względy, takie jak złożone dziedziny. Uważamy że próg ten jest bardzo wysoki i wolelibyśmy, aby wartość ta była niższa niż 5, co oznacza spójny, dobrze sfaktoryzowany kod.

### Parametry architektury

Parametry architektury spełniają trzy kryteria:

* określają poza dziedzinowe względy projektowe - parametry architektury określają operacyjne i projektowe kryteria sukcesu (np. wydajność)

* wpływają na niektóre strukturalne aspekty projektu - czy dany parametr architektury wymaga szczególnych względów konstrukcyjnych, aby zapewnić pomyślne działanie aplikacji np. bezpieczeństwo i obsługa płatności

* mają decydujące lub duże znaczenie dla działania aplikacji - obsługa każdego parametru zwiększa złożoność projektu. Dlatego powinniśmy wybierać jak najmniejszą liczbę parametrów architektury.

Architekt odkrywa parametry architektury na co najmniej trzy sposoby:

* na podstawie zagadnień dziedzinowych

* wymagań

* i dorozumianej wiedzy na temat danej dziedziny

### Macierz ryzyka

Macierz ryzyka wykorzystuje dwa wymiary do kwalifikacji ryzyka: ogólny wpływ ryzyka i prawdopodobieństwo jego wystąpienia. Każdy z tych wymiarów ma trzy oceny: niską (1), średnią (2) i wysoką (3). Liczby te są mnożone przez siebie w każdej siatce macierzy, co daje obiektywną wartość liczbową reprezentującą to ryzyko. [...] Liczby 1 i 2 są uważane za niskie ryzyko, liczby 3 i 4 za średnie ryzyko, a liczby od 6 do 9 to wysokie ryzyko.

Stosując macierz oceny ryzyka, należy najpierw rozważyć wymiar wpływu, a w drugiej kolejności wymiar prawdopodobieństwa.

Risk storming dzieli się na trzy podstawowe etapy:

* identyfikacja - każdy uczestnik samodzielnie identyfikuje obszary ryzyka w ramach architektury

* konsensus - opiera się na współpracy, a jego celem jest osiągnięcie przez wszystkich uczestników konsensusu co do ryzyka w ramach architektury

* ograniczanie - zazwyczaj wiąże się ze zmianami lub udoskonaleniami architektury w celu wyeliminowania lub ograniczenia ryzyka

W przypadku niesprawdzonych lub nieznanych technologii należy zawsze przypisać najwyższą ocenę ryzyka (9), ponieważ dla tego wymiaru nie można zastosować macierzy ryzyka.


## Książki

Matthias Noback, _Object Design Style Guide_, Manning

Martin Fowler, _Architektura systemów zarządzania przedsiębiorstwem. Wzorce projektowe_, Helion

Mark Richards i Neal Ford, _Podstawy architektury oprogramowania dla inżynierów_, Helion

Kent Beck, _Wzorce implementacyjne_, Helion
