# DDD

Dziedzina biznesowa definiuje główny obszar działalności firmy.
Jest to usługa, którą firma świadczy swoim klientom.

Eksperci dziedzinowi nie są analitykami zbierającymi wymagania ani inżynierami projektującymi system.
Są reprezentantami biznesu. To ludzie, którzy zidentyfikowali problem biznesowy i od których pochodzi cała wiedza biznesowa.
Analitycy systemowi i inżynierowie przekształcają własną wizję modeli dziedziny biznesowej w wymagania dotyczące oprogramowania, a następnie w kod źródłowy.
Oprogramowanie jest budowane po to, by rozwiązywało problemy ekspertów dziedzinowych.

Niezmienniki - reguły, które muszą być chronione (spełnione) przez cały czas.

Zarówno Skrypt transakcji, jak i Aktywny Rekord są lepiej dostosowane do poddziedzin o prostej logice biznesowej.

Objekt wartości jest obiektem, który można zidentyfikować na podstawie kompozycji jego wartości.

Należy również śledzić logikę biznesową poddziedzin zaimplementowaną w różnych bazach kodu: precedury składowane w bazie danych, funkcje bezserwerowe itd.

Model to uproszczona reprezentacja rzeczy lub zjawiska, która celowo uwypukla pewne aspekty, pomijając inne. Jest to abstrakcja stworzona z myślą o konkretnym zastosowaniu.
Model składający się wyłącznie z właściwości nazywany jest anemicznym modelem domeny i powinieneś tego unikać.
Model domeny musi być pełnym modelem biznesowym — zawierającym zarówno właściwości, jak i sposoby działania. Musi być spójny od momentu utworzenia i pozostać spójny we wszystkich swoich stanach.

DDD priorytetyzuje zrozumienia domeny i komunikację.

## Projektowanie stategiczne vs taktyczne

Jeśli celem wzorca strategicznego jest określenie granic podziału naszej domeny na wiele poddomen, to celem wzorca taktycznego jest identyfikacja komponentów wewnątrz każdego kontekstu ograniczonego.

### Projektowanie strategiczne

Celem projektu strategicznego jest zrozumienie problemu biznesowego (czyli Dziedziny) i podzielenie go na mniejsze, rozwiązywalne i powiązane ze sobą zadania.
Współpracujemy z ekspertami dziedzinowymi komunikując się językiem dziedziny.
Niezrozumienie Dziedziny Biznesowej skutkuje nieoptymalną implementacją oprogramowania biznesowego.
Według badań około 70% projektów oprogramowania nie jest dostarczanych na czas, w ramach budżetu lub zgodnie z wymaganiami klienta.
Strategiczny aspekt DDD dotyczy odpowiedzi na pytania "co?" i "dlaczego?" - tzn. jakie oprogramowanie budujemy i dlaczego je budujemy.

### Projektowanie taktyczne

Przekształca wnioski wyciągnięte podczas fazy projektowania strategicznego w architekturę oprogramowania.
Do tego celu korzystamy z Entity, DTO, ValueObject, Aggregate, zdarzeń domenowych itd.
Część taktyczna dotyczy odpowiedzi na pytanie "jak?" - tzn. w jaki sposób implementujemy każdy komponent.

## Poddziedziny

Poddziedziny charakteryzują się różnymi wartościami strategicznymi i biznesowymi.
W DDD można wyróżnić trzy typy poddziedzin: Podstawowe, Ogólne i Pomocnicze.

### Poddziedzina Podstawowa

Poddziedzina podstawowa jest źródłem przewagi konkurencyjnej.
To, co firma robi inaczej w porównaniu z jej konkurentami i co ją wyróżnia na tle konkurencji.
Poddziedziny te niekoniecznie są techniczne.

Poddziedziny Podstawowe są złożone, ponieważ prosta poddziedzina podstawowa może zapewniać jedynie krótkotrwałą przewagę konkurencyjną.

Poddziedziny podstawowe są również nazywane Dziedzinami Podstaowymi.
Nazwa Poddziedzina podstawowa jednak lepiej odróżnia je od Dziedziny Biznesowej.

Poddziedziny ciągle ewoluują i poddziedzina podstawowa może przekształcić się w poddziedzinę ogólną.

### Poddziedzina Ogólna

Poddziedziny ogólne to działania, które wszystkie firmy wykonują w ten sam sposób.
Są na ogół złożone i trudne do zaimplementowania.
Poddziedziny ogólne nie zapewniają jednak firmie żadnej przewagi konkurencyjnej.
Nie ma potrzeby innowacji ani optymalizacji.

Często są to obszary, w których nie ma potrzeby wymyślania koła na nowo i można skorzystać z istniejących rozwiązań lub zlecićje na zewnątrz.

Przykładem może być mechanizm uwierzytelniania i autoryzacji użytkownika.
Zamiast pisać własny mechanizm, możemy skorzystać z najlepszych praktyk i gotowych rozwiązań np. OpenID Connect.

### Poddziedziny Pomocnicze

Poddziedziny pomocnicze wspierają działalność firmy. Jednak w przeciwieństwie do poddziedzin podstawowych nie zapewniają przewagi konukrencyjnej.

Logika tej poddziedziny jest prosta. Są to podstawowe operacje ETL i interfejsy CRUD.

W celu rozróżnienia poddziedziny pomocniczej od ogólnej możemy odpowiedzieć na pytanie: "czy byłoby łatwiej i taniej stworzyć własną implementację zamiast integrować zewnętrzną". Jeśli tak, to jest to poddziedzina pomocnicza.

## Konteksty Ograniczone (ang. Bounded Context)

Kontekst Ograniczony (ang. Bounded Context) definiuje granice podsystemu, w którym pojęcie domenowe ma jednoznaczne znaczenie, ogranicza zasięg definicji i modeluje konkretny obszar biznesowy.
Nie współdzieli danych modelu z innymi kontekstami.
Różne bounded contexty muszą komunikować się ze sobą przez jasno zdefiniowane API.
Inny kontekst ograniczony może reprezentować te same encje biznesowe, ale modelować je w celu rozwiązania innego problemu.


Język wszechobecny powinien być spójny w zakresie swojego kontekstu ograniczonego.
Jednak w różnych kontekstach ograniczonych te same terminy mogą mieć różne znaczenia.


Poddziedziny się odkrywa, konteksty ograniczone się projektuje.
Podział dziedziny na konteksty ograniczone jest strategiczną decyzją projektową.


Kontekst ograniczony i związany z nim język wszechobecny powinny być implementowane, rozwijane i utrzymywane tylko przez jeden zespół.
Żadne dwa zespoły nie powinny współdzielić pracy w tym samym kontekście ograniczonym.
Zespół może pracować nad wieloma kontekstami ograniczonymi.

### Wzorce

**Wzorzec klient-dostawca** ustanawia wyraźną relację góra – dół między kontekstami.
Kontekst znajdujący się wyżej w hierarchii dostarcza usługi lub dane, a kontekst niżej w hierarchii jest od niego zależny.
Dostawca (wyżej) musi sprawić, by klient (niżej) mógł polegać na jego usługach, co sprzyja współpracy.


**Wzorzec kooperacji** dotyczy kontekstów ograniczonych implementowanych przez zespoły o dobrze ugruntowanej komunikacji.
W najprostszych przypadkach są to konteksty ograniczone zaimplementowane przez jeden zespół.
Dotyczy to również zespołów z celami zależnymi od siebie, w których sukces jednego zespołu zależy od sukcesu drugiego i odwrotnie.
Głównym kryterium w tym przypadku jest jakość komunikacji i współpracy pomiędzy zespołami.


**Wzorzec partnerstwa** - integracja między kontekstami ograniczonymi jest koordynowana w sposób doraźny.
Gdy jeden zespół powiadomi inny o zmianach w interfejsie API, drugi dostosuje się do tych zmian.

Koordynacja integracji jest w tym przypadku dwukierunkowa. Żaden zespół nie dyktuje języka, który ma być używany do zdefiniowania kontraktu.
Zespoły mogą pracować nad różnicami i wybierać najbardziej odpowiednie rozwiązanie. Ponadto obie strony współpracują przy rozwiązywaniu wszystkich możliwych problemów z integracją. Żaden zespół nie jest zainteresowany zablokowaniem drugiego.

Wzorzec ten nie wydaje się odpowiedni dla zespołów rozproszonych geograficznie, ponieważ może stanowić wyzwanie dla synchronizacji i komunikacji.


**Wspólne jądro** - dwa lub więcej kontekstów ograniczonych jest zintegrowanych przez współdzielenie modelu, należącego do wszystkich korzystających z tego modelu.
Wspólny model jest zaprojektowany zgodnie z potrzebami wszystkich kontekstów ograniczonych.
Dodatkowo współdzielony model musi być spójny we wszystkich kontekstach ograniczonych, które go stosują.
Współdzielona część jest zarządzana wspólnie przez zespoły odpowiedzialne za każdy kontekst.


**Konformista** - konsument dostosowuje się do modelu usługodawcy
Kontekst działający w dole strumienia przetwarzania (konformista) przyjmuje model i protokoły komunikacyjne kontekstu z góry strumienia bez wpływania na niego.
Ten wzorzec jest stosowany, gdy kontekst z dołu strumienia ma niewielką kontrolę nad kontekstem z góry i musi dostosować się do jego sposobu działania.


**Wartstwa Antykorupcyjna** - konsument tłumaczy model usługodawcy na model odpowiadający potrzebom konsumenta.
Wzorzec warstwy zapobiegającej uszkodzeniu (ACL, ang. Anti-Corruption Layer) wprowadza warstwę, która tłumaczy i dostosowuje modele dwóch kontekstów ograniczonych.
Warstwa ta zapobiega zanieczyszczeniu kontekstu docelowego przez model kontekstu źródłowego, pozwalając każdemu z nich zachować integralność.


**Usługa otwartego hosta** - usługodawca implementuje model zoptymalizowany pod kątem potrzeb konsumenta.
Polega na udostępnianiu możliwości kontekstu ograniczonego poprzez dobrze zdefiniowany interfejs usługi, czyniąc go otwartym hostem dla interakcji z innymi kontekstami.
Wzorzec ten promuje luźne powiązania i jasne kontrakty między kontekstami.


**Różne drogi** - powielenie określonych funkcji jest tańsze niż współpraca i integracja.
Wzorzec odrębnych dróg rozwiązuje problem złożoności, która pojawia się, gdy dwie odrębne części systemu muszą się rozwijać niezależnie.
Wzorzec ten polega na identyfikacji w ramach domeny kontekstów ograniczonych, które mają minimalną interakcję i mogą być rozwijane oraz utrzymywane oddzielnie.
Poprzez wyraźne rozdzielenie tych kontekstów zespoły mogą skupić się na konkretnych potrzebach i regułach każdego obszaru domeny, nie będąc hamowanymi przez zawiłości innych obszarów.

## Encje, Agregaty i Repozytoria

Encja to obiekt, który jest przede wszystkim definiowany przez unikatowy identyfikator, często nazywany jest tożsamością.
Ta tożsamość odróznia jedna encję od drugiej, nawet jeśli ich pozostałe atrybuty są identyczne.

Optimistic locking - przed wywołaniem operacji wywołujący odczytuje bieżącą wartość wersji encji. Podczas aktualizacji dane zostaną zmodyfikowane tylko wtedy, gdy wersja będzie równa początkowo odczytanej wartości.

Agregat jest granicą egzekwowania spójności. Jego logika musi weryfikować wszystkie przychodzące modyfikacje i dbać o to, aby nie były sprzeczne z regułami biznesowymi.

Agregat pełni również rolę granicy transakcji. Wszystkie zmiany stanu agregatu powinny być implementowane transakcyjnie jako jedna atomowa operacja.

Stan agregatu może być modyfikowany wyłącznie przez jego logikę biznesową.
Wszystkie procesy lub obiekty zewnętrzne w stosunku do agregatu mogą jedynie odczytywać jego stan.
Stan agregatu może się zmienić tylko w wyniku wywołania odpowiednich metod publicznego interfejsu agregatu.

Żadna operacja systemowa nie może zakładać transakcji obejmującej wiele agregatów.
Zmiana stanu agregatu może być zatwierdzona tylko pojedynczo - po jednym agregacie na transakcję bazy danych.

Ograniczenie jednego egzemplarza agregatu na transakcję zmusza do starannego projektowania granic agregatu tak, aby projekt uwzględniał niezmienniki i reguły biznesowe.
Konieczność zatwierdzania zmian w wielu agregatach sygnalizuje niewłaściwie dobrane  granice transakcji, a co za tym idzie - błędne granice agregatu.

Uzasadnieniem odwoływania się do zewnętrznych agregatów za pomocą identyfikatora jest podkreślenie, że obiekty nie nalezą do granicy danego agregatu oraz zadbanie o to, aby każdy Agregat miał własną granicę transakcji.

Agregaty powinny być zaprojektowane tak, aby były jak najmniejsze, o ile wymagania dotyczące spójności danych w dziedzinie biznesowej są nienaruszone.

Definiowanie odpowiednich granic agregatów jest kluczowe w DDD.
Agregaty nie powinny być zbyt duże, co może prowadzić do problemów z wydajnością i złożonością, ani zbyt małe, co może powodować brak spójności.
Celem jest hermetyzacja powiązanych zmian i utrzymanie spójności w ramach agregatu.

Repozytoria są wykorzystywane do zarządzania agregatami, a nie pojedynczymi encjami, ponieważ agregaty reprezentują spójność w modelu domeny.
Projekt repozytorium i modelu domeny powinien odzwierciedlać potrzeby domeny, a nie mechanizmy przechowywania danych.
Często wraz z repozytoriami stosuje się wzorzec jednostki pracy (ang. Unit of Work) do zarządzania transakcjami i dbania o niepodzielność operacji.

Klasa fasady oferuje uproszczony interfejs do skomplikowanego podsystemu, składającego się z wielu powiązanych ze sobą komponentów.
Chociaż klasa fasady ułatwia dostęp, może oferować tylko częściową funkcjonalność w porównaniu z bezpośrednią interakcją z podsystemem.
Głównym zadaniem jest zmiejszenie złożoności dla klientów poprzez dostarczanie abstrakcji wyższego poziomu.

Zasada odwrócenia zależności DIP (ang. Dependency Inversion Principle) to kolejne potężne narzędzie w arsenale refaktoryzacji.
Zgodnie z DIP moduły wysokiego poziomu nie powinny zależeć od modułów niskiego poziomu, a zamiast tego oba powinny zależeć od abstrakcji.

Funkcje dopasowania (ang. fitness functions), służą do automatyzacji wielu aspektów zarządzania architekturą.
Funkcje dopasowania są niezbędne w monitorowaniu i egzekwowaniu zasad architektonicznych w miarę ewolucji systemu.
Dzięki nim architektura pozostaje zgodna z zamierzonymi celami.

## Usługi dziedziny (domenowe) i aplikacji

Zdarzenie dziedziny to komunikat opisujący istotne wydarzenie, które miało miejsce w dziedzinie biznesowej.

Logikę biznesową, która nie należy do żadnego agregatu ani obiektu wartośći, ale wydaje się istotna, można zaimplementować w usłudze dziedziny.

Usługa dziedziny (ang. domain service) jest obiektem bezstanowym implementującym logikę biznesową. W większości przypadków organizuje ona wywołania różnych komponentów systemu w celu wykonania obliczeń lub analizy.

Usługi dziedziny ułatwiają koordynację pracy wielu agregatów. Zawsze jednak należy pamiętać o ograniczeniach wzorca agregatu polegającym na modyfikowaniu tylko jednego egemplarza agegatu w jednej transakcji bazy danych.
Usługi dziedziny służa do implementacji logiki obliczeniowej, która wymaga odczytu danych z wielu agregatów.


Usługi domenowe są integralną częścią modelu domeny, hermetyzując logikę biznesową, która nie pasuje naturalnie do żadnego agregatu.
Są one wykorzystywane, gdy dana operacja lub proces obejmuje wiele encji lub gdy dane zachowanie nie przynależy do żadnej konkretnej encji.
Usługi domenowe są czyste, co oznacza, że nie powodują efektów ubocznych i zazwyczaj nie polegają na systemach zewnętrznych, takich jak bazy danych czy systemy komunikacyjne.

W przypadku gdy musimy obliczyć całkowitą cenę zamówienia, uwzględniając różne rabaty i podatki, możemy skorzystać z usługi domenowej.
Nie umieszczamy tej logiki w agregacie/encji, ponieważ obejmuje ona wiele encji i obiektów wartości, a dodatkowo naruszałoby to zasadę pojedynczej odpowiedzialności.


Usługi aplikacji znajdują się ponad warstwą domeny, koordynując działania obiektów domenowych w celu realizacji konkretnych przypadków użycia.
Pełnią one rolę pomostu między warstwą prezentacji (na przykład interfejsem API lub interfejsem użytkownika) a warstwą domeny, zajmując się zagadnieniami takimi jak zarządzanie transakcjami, uwierzytelnianie i autoryzacja.
W przeciwieństwie do usług domenowych usługi aplikacji mogą wywoływać efekty uboczne i wchodzić w interakcję z systemami zewnętrznymi.


Główna różnica między usługami domenowymi a usługami aplikacji tkwi w ich zakresie i tym, na czym się skupiają.
Usługi domenowe zawierają logikę charakterystyczną dla danej dziedziny, która obejmuje wiele encji, natomiast usługi aplikacji koordynują wykorzystanie obiektów domenowych w celu realizacji zadań wyższego poziomu.

Zdarzenia integracyjne między kontekstami. Zdarzenia integracyjne odgrywają kluczową rolę.
Dzięki nim różne konteksty ograniczone w apliacji browarniczej pozostaną zsynchronizowane i eefektywnie komunikukją  się między sobą.

## Event storming

Modele odczytu są reprezentowane przez zielone karteczki samoprzylepne.

Systemy zewnętrzne są reprezentowane przez różowe karteczki samoprzylepne.

Agregaty są reprezentowane jako duże żółte karteczki samoprzylepne, z poleceniami po lewej stronie i zdarzeniami po prawej stronie.

Korzyści z warsztatów EventStorming:

* budowanie języka wszechobecnego

* modelowanie procesu biznesowego

* poznawanie nowych wymagań biznesowych

* odzyskanie wiedzy o dziedzinie

* odkrywanie sposobów na ulepszanie istniejącego procesu biznesowego

* wdrażanie nowych członków zespołu

Zdalne sesje EventStormingu są bardziej skuteczne przy mniejszej liczbie uczestników.
W osobistej sesji EventStormingu może uczestniczyć nawet 10 osób. Sesje online najlepiej ograniczyć do pięciu uczestników. Gdy potrzeba więcej uczestników do dzielenia się wiedzą, można zorganizować wiele sesji, a następnie porównać i scalić uzyskane modele.

## Porty i adaptery

Abstrakcyjne porty są implementowane przez konkretne adaptery w warstwie infrastruktury.

Architektura Porty i adaptery jest również znana jako sześciokątna, cebulowa lub czysta.

## Książki

Alessandro Colla i Alberto Acerbis, _Refaktoryzacja domenowa. Przewodnik DDD po przekształcaniu architektury monolitycznej w systemy modularne i mikrousługi_, Helion
