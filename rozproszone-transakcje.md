# Rozproszone transakcje

## Mity dotyczące obliczeń rozproszonych

* Opóźnienie jest zerowe
* Przepustowość jest nieograniczona
* Sieć jest bezpieczna
* Topologia się nie zmienia
* Jest jeden administrator
* Koszt transmisji jest zerowy
* Sieć jest jednorodna.

Na przestrzeni lat inni autorzy dodali więcej mitów do pierwotnej listy.
Choć nie są one oficjalnie częścią oryginalnego zestawu, często omawia się je w kontekście współczesnych systemów rozproszonych.

* System jest spójny
* System jest przewidywalny
* System ma nieograniczone zasoby
* System jest bezstanowy
* Skalowanie jest łatwe
* Awarie są rzadkie
* Czas jest spójny

## Saga

Wzorzec Saga stanowi alternatywne podejście do obsługi transakcji rozproszonych w środowiskach, w których silne gwarancje spójności oferowane przez protokół dwufazowego zatwierdzania (2PC) mogą być niewykonalne ze względu na problemy z wydajnością i dostępnością.

Zamiast wymuszać globalne zatwierdzenie lub wycofanie, wzorzec Saga dzieli transakcję na sekwencję mniejszych, niezależnych kroków, z których każdy jest w stanie wykonać działania kompensacyjne w celu cofnięcia zmian w przypadku wystąpienia błędu.

Wzorzec Saga zwiększa odporność na błędy i skalowalność poprzez wyeliminowanie blokowania zasobów, ponieważ każdy krok kończy się niezależnie, bez oczekiwania na globalne zatwierdzenie.
Jednak wzorzec ten wiąże się również z kompromisem: spójnością ostateczną zamiast ścisłej atomowości.
Oznacza to, że zanim transakcja zostanie w pełni zakończona lub skompensowana w przypadku awarii, tymczasowo mogą być widoczne stany pośrednie.
Wzorzec Saga jest dobrze dostosowany do aplikacji, w których akceptowalny jest pewien stopień elastyczności, a dostępność systemu jest priorytetem.

### Orkiestracja vs choreografia

Istnieją dwa główne podejścia do implementacji wzorca Saga: choreografia i orkiestracja.
W przypadku choreografii usługa reaguje na zdarzenia niezależnie, umożliwiając zdecentralizowany przepływ bez centralnego koordynatora.
Orkiestracja polega natomiast na centralnym orkiestratorze sagi, który kontroluje przebieg wykonania i obsługuje kompensacje.

Oba podejścia umożliwiają realizację przepływów pracy obejmujących wiele usług, ale różnią się sposobem rozdzielenia kontroli i odpowiedzialności.
Te różnice są kluczowe przy implementacji sag, ponieważ wpływają na wzorce komunikacji, przydzielanie odpowiedzialności i zarządzanie transakcjami.
Wybór między nimi bezpośrednio wpływa na skalowalność, łatwość utrzymania, odporność na błędy i ogólną złożoność systemu.


Choreografia opiera się na interakcjach sterowanych zdarzeniami, a usługi reagują na zmiany stanu systemu.
Każda usługa nasłuchuje interesujących ją zdarzeń i decyduje, jak postępować, na podstawie własnej logiki — bez centralnego koordynatora zarządzającego procesem.
Zamiast tego usługi współpracują ze sobą poprzez zdarzenia, aby osiągnąć cel biznesowy.


Orkiestracja z kolei wprowadza dedykowany komponent — orkiestrator — który jawnie zarządza przepływem pracy.
Orkiestrator jest odpowiedzialny za wywoływanie usług, obsługę odpowiedzi i podejmowanie decyzji o kolejnych krokach na podstawie logiki biznesowej.


Mimo swoich zalet choreografia niesie ze sobą wyzwania.
Wraz ze wzrostem liczby usług (i warunków awarii) rosną również złożoność i koszty operacyjne.
Ponieważ nie ma centralnego kontrolera, śledzenie ogólnego postępu procesu może być trudne, a debugowanie i monitorowanie stają się skomplikowane, gdyż prześledzenie przepływu przez wiele usług i zdarzeń wymaga znacznego wysiłku.
Ponadto, jeśli zdarzenie nie zostanie prawidłowo obsłużone lub usługa go nie przetworzy, niezamierzone konsekwencje mogą rozprzestrzenić się w systemie, prowadząc do kaskadowych awarii.
Koszt obsługi wycofywania transakcji może nieoczekiwanie wzrosnąć, szczególnie w systemach o rosnącej liczbie interakcji między usługami.


Centralna rola menedżera procesu jest jednocześnie jego największą siłą i największą słabością.
Poprzez konsolidację logiki biznesowej, zarządzania stanem, obsługi błędów i podejmowania decyzji w jednym miejscu zapewnia on ustrukturyzowany i kontrolowany przepływ pracy.
Jednak ta centralizacja sprawia również, że menedżer procesu staje się pojedynczym punktem awarii i wprowadza ścisłe powiązania, co sprawia, że system staje się mniej elastyczny i trudniej w nim wprowadzać zmiany.


Choreografia umożliwia wprowadzenie zdecentralizowanych, sterowanych zdarzeniami przepływów pracy, które zwiększają elastyczność i skalowalność, ale mogą prowadzić do skomplikowanej obsługi błędów i trudniejszego debugowania.
Orkiestracja z kolei centralizuje kontrolę procesu poprzez orkiestrator, ułatwiając monitorowanie i kompensację, ale wprowadzając ściślejsze powiązania.

Gdy usługi powinny być luźno powiązane i niezależne, bardziej odpowiednim wyborem jest choreografia.
Jeśli natomiast przepływ pracy wymaga wyraźnej kontroli nad kolejnością wykonywania, orkiestracja zapewnia ustrukturyzowane podejście.

## Książki

Alessandro Colla i Alberto Acerbis, _Refaktoryzacja domenowa. Przewodnik DDD po przekształcaniu architektury monolitycznej w systemy modularne i mikrousługi_, Helion
