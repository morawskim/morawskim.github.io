# Style architektoniczne

Antywzorzec lej architektoniczny (ang. sinkhole) - pojawia on się, gdy żądania przechodzą z jednej warstwy do drugiej jako proste przetwarzanie przelotowe, bez przeprowadzenia logiki biznesowej w obrębie każdej warstwy. Zazwyczaj dobrą praktyką jest zasada 80-20. [..] Jeśli tylko 20 procent żądań należy do kategorii leja, jest to do przyjęcia.

Orkiestracja jest koordynacją wielu usług poprzez wykorzystanie osobnej usługi mediatora, który kontroluje przepływ pracy transakcji i zarządza nim (jak dyrygent w orkiestrze).

Choreografia natomiast to koordynacja wielu usług, dzięki której każda z nich może komunikować się z inną bez korzystania z centralnego mediatora (jak tancerze w tańcu).

## Style architektoniczne

Style architektoniczne:

* Monolityczne
	* architektura warstwowa - jest dobrym rozwiązaniem dla małych, prostych aplikacji lub witryn internetowych.

	* architektura potokowa - topologia tej architektury składa się z potoków i filtrów. Potoki tworzą kanał komunikacyjny między filtrami. Filtry są autonomiczne, niezależne od innych filtrów i na ogól bezstanowe. Filtry powinny wykonywać tylko jedno zadanie. Złożone zadania powinny być obsługiwane przez sekwencję filtrów. Istnieją cztery rodzaje filtrów: wytwórczy (ang. producer), przekształcający (ang. transformer), testujący (ang. tester) (podobieństwo do funkcji reduce), odbiorczy (ang. consumer).

	* architektura mikrojądra (nazywany także architekturą wtyczek)

* Rozproszone

	* architektura oparta na usługach (ang. service-based) - jest odmianą stylu mikrousług i jest uważana za jeden z najbardziej pragmatycznych stylów architektonicznych, głównie ze względu na swoją elastyczność architektoniczną. Chociaż architektura bazująca na usługach jest architekturą rozproszoną, nie ma tego samego poziomu złożoności i kosztów co inne architektury rozproszone, takie jak mikrousługi lub architektura sterowana zdarzeniami, co czyni ją bardzo popularnym rozwiązaniem dla wielu aplikacji związanych z biznesem. W większości przypadków w ramach architektury bazującej na usługach występuje tylko jedna instancja każdej usługi dziedzinowej. Jednak ze względu na skalowalność, odporność na błędy i potrzeby przepustowości może występować wiele instancji usługi. Wiele instancji usługi zazwyczaj wymaga jakiegoś mechanizmu równoważenia obciążenia pomiędzy interfejsem użytkownika, a usługą, aby interfejs użytkownika mógł być przekierowany do sprawnej i dostępnej instancji usług.

	* architektura sterowana zdarzeniami

	* architektura przestrzenna (ang. space-based)

	* architektura zorientowana na usługi (ang. orchestration Drive Service Oriented Architecture)

	* architektura mikrousług

## Architektura rozproszona (mity, porady)

Mikrousługi są w dużym stopniu inspirowane ideami projektowania sterowanego dziedzinami (DDD), logicznego procesu projektowania dla projektów informatycznych. Mikrousługi powinny zawierać wszystkie elementy niezbędne do niezależnego działania (np. bazy danych).

Mity architektur rozproszonych:

* Sieć jest niezawodna

* Opóźnienie jest zerowe

* Przepustowość jest nieskończona

* Sieć jest bezpieczna

* Topologia nigdy się nie zmienia

* Jest tylko jeden administrator

* Koszt transportu jest zerowy (koszt transportu nie dotyczy tutaj opóźnień, ale raczej rzeczywistych kosztów pieniężnych związanych z wykonaniem "prostego połączenia REST-owego".

* Sieć jest homogeniczna

Inne kwestie związane z rozproszeniem:

* Rozproszone dzienniki zdarzeń

* Rozproszone transakcje

* Utrzymywanie i wersjonowanie kontraktów

Jest to jeden z kompromisów architektury rozproszonej wysoka skalowalność, wydajność i dostępność kosztem spójności i integralności danych.

Wysoce rozproszone architektury, takie jak mikrouslugi, zawierają zazwyczaj usługi o dużym stopniu szczegółowości i wykorzystują technikę rozproszonych transakcji znaną jako transakcję BASE (od ang. basic availability, soft state, eventual consistency, czyli podstawowa dostępność, miękki stan, ostateczna spójność), którego polegają na ostatecznej spójności i dlatego nie obsługują tego samego poziomu integralności bazy danych co transakcje ACID.


## Architektura sterowana zdarzeniami
W architekturze opartej na zdarzeniach wyróżniamy dwie podstawowe topologie: topologię mediatora i topologię brokera. Topologia mediatora jest powszechnie stosowana w przypadku, gdy musisz mieć kontrolę nad przebiegiem procesu przetwarzania zdarzenia, podczas gdy topologia brokera jest stosowana w przypadku, gdy potrzebujesz wysokiego stopnia responsywności i dynamicznej kontroli nad przetwarzaniem zdarzenia.

### Topologia brokera
W topologi brokera zaleca się, aby każdy procesor zdarzeń informował system o podjętych przez siebie działaniach, niezależnie od tego, czy mają one jakiekolwiek znaczenia dla innego procesora zdarzeń.

Możliwość ponownego uruchomienia transakcji biznesowej (odzyskiwalność) jest również czymś, co nie jest wspierane w topologi brokera. Ponowne wysłanie zdarzenia inicjującego nie jest możliwe, ponieważ jego wstępne przetwarzanie spowodowało, że asynchronicznie podjęte zostały inne działania.

Kompromisy topologii brokera:

| Zalety | Wady |
| -| - |
| Wysoce rozprzężone procesory zdarzeń | Kontrola przepływu pracy |
| Wysoka skalowalność | Obsługa błędów |
| Wysoka responsywność | Odzyskiwalność |
| Wysoka wydajność | Możliwość ponownego uruchomienia |
| Wysoka odporność na uszkodzenia | Niespójność danych |

### Topologia mediatora

Topologia mediatora w architekturze sterowanej zdarzeniami eliminuje niektóre niedoskonałości topologi brokera. Centralnym elementem tej topologi jest mediator zdarzeń, który zarządza przepływem pracy dla zdarzeń inicjujących wymagających koordynacji wielu procesorów zdarzeń i sprawuje kontrolę nad tym przepływem.

Jednak w topologii mediatora zdarzenia przetwarzania takie jak złóż-zamówienie, wyślij-mail i zrealizuj-zamówienie są poleceniami (czymś co musi się wydarzyć) w przeciwieństwie do zdarzeń (czegoś, co już się wydarzyło). Ponadto w topologi mediatora zdarzenie przetwarzania musi być przetworzone (polecenie), podczas gdy w topologii brokera może zostać zignorowane (reakcja).

Kompromisy topologi mediator

| Zalety | Wady |
| - | - |
| Kontrola przepływu pracy | Większe sprzężenie procesorów zdarzeń |
| Obsługa błędów | Mniejsza skalowalność |
| Odzyskiwalność | Gorsza wydajność |
| Możliwość ponownego uruchomienia | Mniejsza odporność na błędy |
| Lepsza spójność danych | Modelowanie złożonych przepływów pracy |

Jeśli użytkownik nie potrzebuje żadnych informacji zwrotnych (innych niż potwierdzenie lub wiadomość z podziękowaniem), po co kazać mu czekać? Responsywność polega na powiadomieniu użytkownika, że dana akcja została zaakceptowana i będzie niezwłocznie przetwarzana, podczas gdy wydajność polega na przyspieszeniu całego procesu.

### Problemy utraconych danych w kolejkach

Problem 1. (komunikat nigdy nie trafia do kolejki) można łatwo rozwiązać poprzez wykorzystanie utrwalonych kolejek komunikatów wraz z tzw. wysyłaniem synchronicznym (ang. synchronous send). Utrwalone kolejki komunikatów obsługują tzw. gwarantowane dostarczanie.

Problem 2 (Procesor zdarzeń B usuwa z kolejki następny dostępny komunikat i ulega awarii, zanim będzie w stanie przetworzyć zdarzenie) może być również rozwiązany za pomocą podstawowej techniki powiadamiania zwanej trybem potwierdzania klienta (ang. client acknowledge mode). Domyślnie, gdy komunikat opuszcza kolejkę, jest z niej natychmiast usuwany (tzw. tryb automatycznego potwierdzania). Tryb potwierdzania klienta zatrzymuje komunikat w kolejce i dołącza do niego identyfikator klienta, aby żadne inny odbiorca nie mógł go odczytać. W tym trybie, jeśli procesor zdarzeń B ulegnie awarii, komunikat będzie nadal przechowywany w kolejce, co zapobiegnie utracie danych w tej części przepływu komunikatów.

Problem 3. (Procesor zdarzeń B nie jest w stanie zachować komunikatu w bazie danych z powodu jakiegoś błędu związanego z danymi) można rozwiązać poprzez wykorzystanie transakcji ACID (niepodzielność, spójność, izolacja, trwałość) za pośrednictwem operacji zatwierdzania (ang. commit) w bazie danych. Wykonanie operacji zatwierdzania gwarantuje, że dane są zachowywane w bazie danych. Wykorzystanie techniki zwanej wsparciem ostatniego uczestnika (LPS, ang. last participant support) powoduje usunięcie komunikatu z utrwalonej kolejki i stanowi potwierdzenie, że przetwarzanie zostało zakończone, a komunikat nie zostanie utracony w trakcie przechodzenia z Procesora działań A aż do bazy danych.


Kompromisy modelu opartego na zdarzeniach

| Zalety w stosunku do modelu opartego na żądaniach | Kompromisy |
| - | - |
| Lepsze reagowanie na dynamiczne treści użytkowników | Wspieranie tylko ostatecznej spójności |
| Lepsza skalowalność i elastyczność | Mniejsza kontrola nad przepływem przetwarzania |
| Lepsza zwinność i zarządzanie zmianami | Mniejsza pewność co do wyniku przepływu zdarzeń |
| Lepsza przystosowalność i rozszerzalność | Utrudnione testowanie i usuwanie błędów |
| Lepsza responsywność i wydajność | - |
| Lepsze podejmowanie decyzji w czasie rzeczywistym | - |
| Lepsza reakcja wynikająca ze świadomości sytuacyjnej | - |

## Architektura przestrzenna

Architektura przestrzenna opiera się głównie na replikowanym buforze, choć można również zastosować buforowanie rozproszone.

Przy replikowanym buforowaniu każda jednostka przetwarzająca zawiera swój własny pamięciowy klaster danych, który jest synchronizowany pomiędzy wszystkimi jednostkami przetwarzającymi przy użyciu tego samego nazwanego bufora. Gdy dochodzi do aktualizacji bufora w jednej z jednostek przetwarzających, pozostałe jednostki są automatycznie aktualizowane o nowe informacje.

Replikowanie rozproszone wymaga zewnętrznego serwera lub usługi do przechowywania scentralizowanego bufora. W tym modelu jednostki przetwarzające nie przechowują danych w pamięci wewnętrznej, lecz zamiast tego używają własnościowego protokołu, aby uzyskać dostęp do danych z centralnego serwera buforującego. Buforowanie rozproszone zapewnia wysoki poziom spójności danych, ponieważ wszystkie dane znajdują się w jednym miejscu i nie muszą być replikowane. Model ten ma jednak mniejszą wydajność niż buforowanie replikowane, ponieważ dane z bufora muszą być dostępne zdalnie co zwiększa ogólne opóźnienia systemu. W buforowaniu rozproszonym występuje również problem z odpornością na błędy.

Gdy rozmiar bufora jest stosunkowo niewielki (poniżej 100 MB), a częstotliwość aktualizacji jest na tyle niska, że silnik replikacji produktu buforowania może nadążyć za aktualizacjami bufora, decyzja o tym, czy użyć replikowaneg, czy rozproszonego bufora, staje się kwestią wyboru między spójnością danych, a wydajnością i odpornością na błędy.

Buforowanie rozproszone a replikowanie:

| Kryteria wyboru | Buforowanie replikowane | Buforowanie rozproszone |
| - | - | -|
| Optymalizacja| Wydajność | Spójność |
| Rozmiar bufora| Mały (<100 MB) | Duży (>500 MB) |
| Rodzaj danych | Stosunkowo statyczne | Wysoko dynamiczne |
| Częstotliwość aktualizacji | Stosunkowo niska | Wysoka częstotliwość aktualizacji |
| Odporność na błędy | Wysoka | Niska |

Model near-cache to rodzaj buforowania hybrydowego, które łączy pamięciowe klastry danych z rozproszonym buforem. W tym modelu bufor rozproszony jest określany jako pełny bufor pomocniczy (ang. full backing cache), a każdy pamięciowy klaster danych zawarty w każdej jednostce przetwarzania jest określany jako bufor czołowy (ang. front cache). Bufor czołowy zawiera zawsze mniejszy podzbiór pełnego bufora pomocniczego i wykorzystuje politykę wysiedlania (ang. eviction policy) w celu usuwania starszych elementów, aby można było dodać nowsze.
[..] Wprawdzie bufory czołowe są zawsze zsynchronizowane z pełnym buforem pomocniczym, ale bufory czołowe zawarte w każdej jednostce przetwarzającej nie są synchronizowane pomiędzy innymi jednostkami przetwarzającymi współdzielącymi te same dane. Oznacza to, że przy wielu jednostkach przetwarzających współdzielących ten sam kontekst danych (np. profil klienta) prawdopodobnie wszystkie będą miały różne dane w swoim buforze czołowym.

Istnieje kilka czynników, które mają wpływ na ilość możliwych kolizji danych: liczba instancji jednostek przetwarzających zawierających ten sam bufor, częstotliwość aktualizacji bufora, rozmiar bufora i wreszcie opóźnienie replikacji systemu buforującego. Aby określić probabilistycznie, ile potencjalnych kolizji danych może wystąpić w oparciu o te czynniki, stosuje się następujący wzór:

Częstotliwość kolizji = `L * ( (CA^2)/R ) * OR`

`L` - oznacza liczbę instancji usług wykorzystujących ten sam nazwany bufor
`CA` oznacza częstotliwość aktualizacji w milisekundach (do kwadratu)
`R` - to rozmiar bufora (podany jako liczba wierszy)
`OR` - to opóźnienie replikacji systemu buforującego

Wzór ten jest przydatny do określenia odsetka kolizji danych, które prawdopodobnie wystąpią, a tym samym do wykonalności zastosowania replikowanego buforowania.
