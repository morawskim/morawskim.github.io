# Mikrousługi

## Pojęcia

Średnia ruchoma - przeciętna wartość z ostatnich 30 sekund.

Komunikat syntetyczny - część systemy monitoringu sprawdzająca poprawność systemu. Komunikat syntetyczny to komunikat testowy, która nie ma wpływu na rzeczywiste procesy biznesowe. To sztuczne zamówienie lub użytkownik wykonujący sztuczne działania.

## Wzorce

Strangler Fig - polega na utworzeniu nowego systemu obok starego systemu, który nadal działa. Stopniowo kolejne funkcje są przenoszone do nowego systemu, aż stary system nie jest potrzebny i można go wyłączyć.

[Transactional outbox](https://microservices.io/patterns/data/transactional-outbox.html)

Wzorzec rezerwacji

Wzorzec zapiekanka - zmniejsza ryzyko awarii, które mają poważne konsekwencje. Jest to wariant Progresywnego Kanarka, które utrzymuje pełny zestaw istniejących instancji, ale także wysyła kopię ruchu komunikatów przychodzących do nowych instancji. Dane wyjściowe z nowych instancji są porównywane ze starszymi.

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


## Książki

Richard Rodger, _Tao mikrousług. Projektowanie i wdrażanie_, Helion
