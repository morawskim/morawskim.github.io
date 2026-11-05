# Golang kanały

Alex Rios, _System Programming Essentials with Go. System calls, networking, efficiency, and security practices with practical projects in Golang_, Packt Publishing

Kanały w Go mają trzy stany:

* nil — kanał nie został zainicjalizowany
* Otwarty (open) — pusty, niepusty
* Zamknięty (closed) — kanał został zamknięty za pomocą close().

### Kanał bez buforowania (unbuffered channel)

Kanał bez buforowania (unbuffered channel) może być dobrym wyborem w następujących sytuacjach:

* Gwarantowane dostarczenie (Guaranteed delivery)
Zapewnia, że wartość wysłana przez kanał zostanie odebrana przez inną goroutine.
Jest to szczególnie przydatne w sytuacjach, w których musimy mieć pewność, że dane zostaną przetworzone i nie zostaną utracone.

* Komunikacja jeden-do-jednego (One-to-one communication)
Kanały bez buforowania najlepiej sprawdzają się w komunikacji jeden-do-jednego pomiędzy goroutines.

* Równoważenie obciążenia (Load balancing)
Kanały bez buforowania mogą być wykorzystywane do implementowania wzorców równoważenia obciążenia, zapewniając równomierne rozdzielanie pracy pomiędzy worker goroutines.


### Kanały buforowane

Kanały buforowane oferują następujące możliwości:

* Asynchroniczna komunikacja (Asynchronous communication)
Kanały buforowane pozwalają na asynchroniczną komunikację pomiędzy goroutines.
Podczas wysyłania danych do kanału buforowanego nadawca nie zostanie zablokowany, dopóki w buforze kanału jest dostępne miejsce. Dzięki temu w niektórych przypadkach można zwiększyć przepustowość (throughput).

* Zmniejszenie rywalizacji (Reducing contention)
W sytuacji, gdy mamy wiele wysyłających i odbierających dane, użycie kanału buforowanego może zmniejszyć rywalizację (contention).
Przykładowo, we wzorcu producer-consumer możemy użyć kanału buforowanego, aby producenci mogli nadal produkować dane bez konieczności czekania, aż konsumenci nadążą z ich przetwarzaniem.

* Zapobieganie deadlockom (Preventing deadlocks)
Kanały buforowane mogą pomóc zapobiegać deadlockom poprzez zapewnienie pewnego poziomu buforowania.
Jest to szczególnie przydatne, gdy obciążenie systemu jest zmienne i nieprzewidywalne.

* Przetwarzanie wsadowe (Batch processing)
Kanały buforowane mogą być wykorzystywane do przetwarzania danych partiami (batch processing), w których dane są produkowane w jednym tempie, a konsumowane w innym.

### Zachowania kanału

Zachowanie kanału, gdy chcemy odczytać z niego dane:

* Próba odczytu z kanału przeznaczonego wyłącznie do zapisu (write-only channel) skutkuje błędem kompilacji.

* Jeśli kanał jest nil, odczyt z niego będzie blokował goroutine w nieskończoność, dopóki kanał nie zostanie zainicjalizowany.

* Jeśli kanał jest otwarty (open) i pusty (empty), odczyt zostanie zablokowany do momentu, aż dane będą dostępne.

* Jeśli kanał jest otwarty (open) i zawiera dane (not empty), odczyt zwróci dane znajdujące się w kanale.

* Jeśli kanał jest zamknięty (closed), odczyt zwróci wartość domyślną (zero value) dla typu kanału oraz false, które informuje o tym, że kanał jest zamknięty.


Zachowanie kanału, gdy chcemy wysłać do niego dane:

* Próba zapisu do kanału przeznaczonego wyłącznie do odczytu (read-only channel) skutkuje błędem kompilacji.

* Zapis do kanału nil będzie blokował goroutine w nieskończoność, dopóki kanał nie zostanie zainicjalizowany.

* Zapis do otwartego (open) i pełnego (full) kanału będzie zablokowany do momentu, aż w kanale pojawi się wolne miejsce.

* Zapis do otwartego (open) i niepełnego (not full) kanału zakończy się sukcesem i wartość zostanie umieszczona w kanale.

* Zapis do zamkniętego (closed) kanału spowoduje panic.


Zachowanie podczas zamykania kanału zależy od jego aktualnego stanu:

* Zamknięcie otwartego kanału zawierającego dane (open and not empty) – kanał zostaje zamknięty, ale dane znajdujące się w jego buforze nadal można odczytywać. Dopiero po opróżnieniu bufora kolejne próby odczytu zwrócą wartość domyślną (zero value) dla typu kanału oraz false

* Zamknięcie otwartego i pustego kanału (open and empty) – kanał zostaje natychmiast zamknięty. Próby odczytu zwrócą wartość domyślną (zero value) oraz false.

* Próba zamknięcia już zamkniętego kanału (closed) spowoduje panic.

* Próba zamknięcia kanału przeznaczonego wyłącznie do odczytu (read-only channel) skutkuje błędem kompilacji.


### Kiedy używać mutexów, a kiedy kanałów?

Używaj kanałów (channels), gdy:

* Przekazywać własność danych (Pass the ownership of data) – przekazywać dane pomiędzy goroutines, tak aby jedna goroutine przekazywała drugiej odpowiedzialność za ich dalsze wykorzystanie.

* Distribution of units of work – dystrybuować zadania pomiędzy wiele goroutines, np. w modelu worker pool.

* Komunikować wyniki w sposób synchroniczny – przekazywać wyniki pomiędzy goroutines, synchronizując ich działanie.


Używaj mutexów (mutexes), gdy:

* wiele goroutines ma dostęp do wspólnej pamięci podręcznej i może jednocześnie odczytywać lub modyfikować przechowywane w niej dane. Mutex zapewnia bezpieczny dostęp do tych danych.

* wiele goroutines korzysta z tych samych zmiennych lub struktur danych i może je modyfikować. Mutex chroni przed jednoczesnym dostępem, który mógłby prowadzić do race condition.
