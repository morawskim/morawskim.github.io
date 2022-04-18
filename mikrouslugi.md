# Mikrousługi

## Pojęcia

Średnia ruchoma - przeciętna wartość z ostatnich 30 sekund.

Komunikat syntetyczny - część systemy monitoringu sprawdzająca poprawność systemu. Komunikat syntetyczny to komunikat testowy, która nie ma wpływu na rzeczywiste procesy biznesowe. To sztuczne zamówienie lub użytkownik wykonujący sztuczne działania.

Uwalnianie danych (ang. data liberation) to identyfikacja i publikacja między dziedzinowych zbiorów danych w odpowiednich strumieniach zdarzeń.
Jest ono częścią strategii migracji dla architektur opartych na zdarzeniach. Między dziedzinowe zbiory danych obejmują wszelkie dane przechowywane w jednym magazynie danych.

## Wzorce

Strangler Fig - polega na utworzeniu nowego systemu obok starego systemu, który nadal działa. Stopniowo kolejne funkcje są przenoszone do nowego systemu, aż stary system nie jest potrzebny i można go wyłączyć.

[Transactional outbox](https://microservices.io/patterns/data/transactional-outbox.html)

Wzorzec rezerwacji

Wzorzec zapiekanka - zmniejsza ryzyko awarii, które mają poważne konsekwencje. Jest to wariant Progresywnego Kanarka, które utrzymuje pełny zestaw istniejących instancji, ale także wysyła kopię ruchu komunikatów przychodzących do nowych instancji. Dane wyjściowe z nowych instancji są porównywane ze starszymi.

Wzorzec Orkiestracja umożliwia elastyczne definiowanie przepływu pracy w ramach pojedynczej mikrousługi. Orkiestrator śledzi etapy przepływu pracy i rozpoznaje, które zostały zakończone, są w toku lub jeszcze nie zostały uruchomione. Orkiestrator przepływu pracy wysyła zdarzenia poleceń do podległych mu mikrousług, które wykonują wymagane zadania i odsyłają wyniki. Zwykle odbywa się to przez wysyłanie żądań i odpowiedzi za pośrednictwem strumienia zdarzeń.

## Porady

Taktyki w przypadku spowolnienia w transmisji zwrotnej:

* Limity czasu (ang. timeouts) - uznanie komunikatu za nieudane, jeśli odpowiedź nie zostanie dostarczona w ramach ustalonego limitu czasu

* Adaptacyjne limity czasu - użyj limitów czasu, ale nie jako stałe parametry konfiguracyjne. Dostosuj limity czasy na podstawie obserwowanych zachowań np. opóźnienie wynosi więcej niż trzy standardowe odchylenia od obserwowanego średniego czasu reakcji.

* wyłącznik automatyczny (ang. Circuit Breaker) - stale opóźniające się usługi oznaczamy jako martwe i nie wysyłamy do nich ruchu.

* ponawianie - próba ponowienia nieudanego komunikatu przez ponowne jego wysłanie wykorzystując algorytm Exponential Backoff.

* Inteligentny algorytm karuzelowy (ang. round robin) - zrównoważa obciążenia między poszególnymi instancjami usługi


Taktyki w przypadku przeciążenia mikrousługi, która otrzymuje zbyt dużo komunikatów:

* Adaptacyjne tłumiki - nie próbuj wykonywać całej pracy, jaka tylko się pojawia. Zamiast tego ustaw kolejkę pracy na maksymalną szybkość, którą można bezpiecznie obsłużyć.

* Ciśnienie wsteczne - udostępnia mikrousługom klientów metadane opisujące bieżące poziomy obciążenia.

* Zrzucenie obciążenia - odmów wykonania zadania, gdy został osiągnięty niebezpieczny poziom obciążenia. Odpowiednie metadane powinny zostać zwrócone do usług klienta, aby nie interpretowały one niewłaściwie tego zrzucania i nie wyzwalały wyłącznika.


Nie pokazuj decyzji implementacyjnych innym usługom. Dzięki temu będziemy mieć możliwość zmiany niemal wszystkiego niezależnie od innych elementów.

Żadne techniki zarządzania projektami nie mogą zapobiec inżynierskimi deficytom architektury monolitycznej.

Architektury monolityczne tworzą trzy negatywne implikacje:

* potrzebują większej koordynacji zespołu

* generują większy dług techniczny

* wdrożenia są bardziej ryzykowane, ponieważ wpływają na cały system


Komunikaty synchroniczne tworzą zależność między usługami. Nawet jeśli z nich korzystamy to warto publikować także asynchroniczne komunikaty.

"Bądźcie konserwatywni w tym, co robicie, bądźcie liberalni w tym, co przyjmujecie od innych" - Jon Postel

Ważniejsze jest utrzymywanie działającego systemu dla jak największej liczby użytkowników, dlatego dopuszcza się technikę zmniejszania obciążenia (ang. load shedding).

Unikaj dodawania w zdarzeniach pól `type`, które przeciążają znaczenie danego zdarzenia. Może to spowodować znaczne trudności w ewoluowaniu i utrzymywaniu formatu zdarzenia.

Implementacja brokera zdarzeń może również obsługiwać niepodzielne zapisywanie wielu zdarzeń w wielu osobnych strumieniach zdarzeń. Pozwala to producentowi na publikowanie swoich zdarzeń w wielu strumieniach zdarzeń w pojedynczej, niepodzielnej transakcji.

Gdy tylko jest to możliwe, najlepiej unikać implementowania transakcji rozproszonych, ponieważ mogą one znacznie zwiększyć ryzyko błędów i złożoność przepływu pracy. Trzeba wziąć pod uwagę cały szereg problemów, takich jak m.in. synchronizacja pracy między systemami, ułatwianie wycofywania zmian, zarządzanie przejściowymi awariami instancji czy łączność sieciowa.

Skalowanie mikrousługi i odzyskiwanie sprawności po awarii to w rzeczywistości ten sam proces. Dodanie instancji aplikacji związane z celowym skalowaniem długo działającego procesu lub koniecznością odzyskania instancji po awarii wymaga prawidłowego przypisania partycji wraz z ich stanami. Analogicznie, usunięcie instancji, celowe lub spowodowane awarią, wymaga ponownego alokowania przypisań i stanu danej partycji od innej aktywnej instancji, aby można było kontynuować przetwarzanie bez zakłóceń.


Pojedyncze współdzielone środowisko testowe jest powszechnie stosowaną strategią, gdy inwestycje w narzędzia są niewielkie. Wadą jest zwiększona trudność w kwestiach zarządzania danymi zdarzeń, zapewniania ich poprawności oraz jednoznacznego określania własności. Środowiska jednorazowe są preferowaną alternatywą, ponieważ zapewniają izolację dla testowanych usług i zmniejszają ryzyko i niedociągnięcia spowodowane wielodzierżawnością.

Niebiesko-zielone wdrożenia dobrze sprawdzają się w przypadku mikrousług, które konsumują ze strumieni zdarzeń. Mogą również przydawać się w w sytuacjach, kiedy zdarzenia są produkowane tylko ze względu na aktywność żądanie-odpowiedź.

## Książki

Richard Rodger, _Tao mikrousług. Projektowanie i wdrażanie_, Helion

Adam Bellemare, _Mikrousługi oparte na zdarzeniach. Wykorzystywanie danych w organizacji na dużą skalę_, Helion
