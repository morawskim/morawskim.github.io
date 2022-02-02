# Wydajność

* Wielkość bufora sieciowego - mniejszy bufor oznacza spadek zapotrzebowania na pamięć dla danego połączenia, co pomaga podczas skalowania systemu. Z kolei większy bufor poprawia przepustowość sieci.

* Polityki zarządzania buforem:
    * MRU (ang. Most Recently Used)
    * LRU (ang. Least Recently Used)
    * MFU (ang. Most Frequently Used)
    * LFU (ang. Least Frequently Used)
    * NFU (ang. Not Frequently Used)

* Stany bufora:
    * zimny - bufor jest pusty lub wypełniony niechcianymi danymi. Współczynnik trafności tego rodzaju bufora wynosi 0 (lub waha się w okolicach 0, gdy rozpocznie się proces rozgrzewania bufora).
    * gorący - bufor jest wypełniony najczęściej żądanymi danymi i charakteryzuje się wysokim współczynnikiem trafności.
    * rozgrzany - bufor jest wypełniony użytecznymi danymi, ale nie ma jeszcze wystarczająco wysokiego współczynnika trafności, aby mógł zostać uznany za gorący.
    * ciepło - "Ciepłość" bufora określa, jak zimny lub jak gorący jest bufor. Działanie poprawiające "ciepłość" bufora jest jednym z tych, które prowadzą do poprawy współczynnika trafności bufora.

* Bufor cykliczny jest rodzajem stałego bufora, który można wykorzystać do nieustannych transferów między komponentami. Działa więc jak bufor asynchroniczny. Tego rodzaju bufor jest implementowany za pomocą wskaźników początkowego i końcowego; są one przesuwane o każdy komponent, gdy dane są dodawane lub usuwane.

* Czas działania jest mierzony przez funkcję schedstats jądra i udostępniony przez plik `/proc/<PID>/schedstat`.

* Narzędzie DTrace używa tak zwanych programów pomocniczych ustack do sprawdzenia zawartości maszyny wirtualnej i konwersji stosów z powrotem na oryginalny program. Wspomniane programy pomocnicze istnieją dla Javy, Python i Node.js.

* Jeżeli wartość średniego obciążenia procesora przekracza liczbę procesorów w komputerze, najczęściej oznacza to stan nasycenia.

* Obciążenie wiążące się z operacjami wejścia-wyjścia charakteryzują się wysokim poziomem czasu systemu, wywołań systemowych oraz dobrowolnymi przełączeniami kontekstu, ponieważ wątki sa zablokowane w oczekiwaniu na zakończenie operacji wejścia-wyjścia.

* System Linux dodaje do średniego obciążenia zadanie polegające na przeprowadzeniu dyskowych operacji wejścia-wyjścia w nieprzerwanym stanie. Oznacza to, że średnie obciążenie nie może być dłużej interpretowane jako ilość dostępnych zasobów lub wystąpienie stanu nasycenia, ponieważ nie wiadomo, czy wyświetlana wartość odzwierciedla obciążenie procesora, czy dysku.

* Bufor strony - bufor systemu plików. Możliwy do dostrojenia parametr nosi nazwę swappines i pozwala zdefiniować poziom, do którego preferowane będzie zwalnianie pamięci z bufora stron zamiast przeprowadzania operacji wymiany.

* Skanowanie pamięci - szukaj nieustannego skanowania stron (trwającego dłużej niż 10 sekund); to typowy znak niewystarczającej ilości pamięci w komputerze. W systemie Linux można wydać polecenie `sar -B` i sprawdzić wartość wyświetloną w kolumnie pgscan.

* Stronicowanie pamięci to kolejny znak, że systemowi zaczyna brakować wolnej pamięci. W systemie Linux można wydać polecenie `vmstat`, a następnie sprawdzić wartość w kolumnach si i so (w danych wyjściowych słowo swapping oznacza stronicowanie anonimowe).

* Wynik działania mechanizmu OOM Killer jest rejestrowany w systemowym dzienniku zdarzeń (`/var/log/messages`), który można przeglądać na przykład za pomocą polecenie dmesg. Szukaj komunikatu "Out of memory".

* Jeżeli wartością kolumn si i so (polecenia vmstat) będzie nieustannie wartość niezerowa, oznacza to, że systemowi brakuje pamięci. [...] W systemach wyposażonych w ogromne ilości pamięci kolumny nie będą wyrównane i odczyt ich wartości może być nieco utrudniony. W takim przypadku spróbuj zmienić jednostki danych wyjściowych na megabajty, używając w tym celu opcji -S: `vmstat -Sm`

* Synchroniczna operacja zapisu ma miejsce wtedy, gdy plik jest otwarty z opcją `O_SYNC` lub jej wariantami: `O_DSYNC` bądź `O_RSYNC`. [...] Niektóre systemy plików oferują opcje montowania pozwalające na wymuszenie tego, aby wszystkie operacje zapisu plików były przeprowadzane synchronicznie.

* [..] przeprowadzenie nieblokujących operacji wejścia-wyjścia. Operacje takie mogą być przeprowadzane dzięki użyciu opcji `O_NONBLOCK` lu b`O_NDELAY` wywołania systemowego `open()`. Powoduje to, że operacje odczytu i zapisu generują błąd typu EAGAIN, zamiast blokować, co nakazuje aplikacji ponowić próbę nieco później. (Obsługa takiego rozwiązania zależy od systemu plików, który może honorować nieblokowanie jedynie dla zalecanych lub obowiązkowych blokad pliku).

* Systemy plików oparte na extentach alokują ciągłą przestrzeń dla plików (extenty) i powiększają ją, jeśli zachodzi potrzeba. Kosztem obciążenia związanego z przestrzenią takie rozwiązanie poprawia wydajność strumieniowania, a także może poprawić wydajność losowych operacji wejścia-wyjścia, ponieważ dane pliku znajdują się obok siebie.

* W pewnych rodzajach obciążenia można osiągnąć lepszą wydajność po skonfigurowaniu dla nich oddzielnych systemów plików i urządzeń dyskowych. Tego rodzaju podejście jest określane jako użycie "oddzielnych napędów", ponieważ w przypadku dysków mechanicznych dwie losowe operacje wejścia-wyjścia wyszukujące dane dla dwóch różnych zadań charakteryzują się szczególnie kiepską wydajnością. [..]. Na przykład baza danych odniesie duże korzyści z posiadania oddzielnych systemów plików i dysków dla plików dzienników zdarzeń i plików samej bazy danych.

* Kluczową opcją dla poprawy wydajności w tune2fs jest `tune2fs -O dir_index /dev/<DISK>`. Opcja ta powoduje użycie haszowanych struktur B-tree, co przyśpiesza operacje wyszukiwania w ogromnych katalogach.

* W przypadku środowiska biznesowego wszelkie dyskowe operacje wejścia-wyjścia trwające powyżej 10 ms uznaję za wolne, a przy tym za potencjalne źródło problemów związanych z wydajnością. Z kolei w środowisku przetwarzania w chmurze istnieje nieco większa tolerancja dla wyższych wartości opóźnienia, zwłaszcza w przypadku aplikacji sieciowych, w których można się spodziewać wysokiego opóźnienia między siecią i przeglądarką internetową klienta. W tego rodzaju środowiskach dyskowe operacje wejścia-wyjścia mogą stać się problemem, gdy będą trwały dłużej niż 100 ms.

* Praktycznie jednak każdy poziom wykorzystania dysku może się przekładać na gorszą wydajność, ponieważ dyskowe operacje wejścia-wyjścia z reguły są wolne. Między poziomami 0% i 100% może znajdować się punkt (powiedzmy 60%), w którym wydajność dysku nie będzie dłużej satysfakcjonująca ze względu na większe prawdopodobieństwo wystąpienia kolejkowania w samym dysku bądź w systemie operacyjnym.

* iotop - za pomocą trybu rozszerzonego można wyszukać obciążone dyski (poziom wykorzystania przekraczający 60%), długie średnie czasy obsługi (na przykład powyżej 10 ms) oraz wysokie wartości IOPS.

* ionice - W systemie Linux polecenie ionice można wykorzystać do wskazania klasy szeregowania operacji wejścia-wyjścia oraz priorytetu procesu. Przykład użycia: `ionice -c 3 -p <PID>`. Powyższe polecenie powoduje przypisanie procesorowi o identyfikatorze `PID` klasy szeregowania 3. To może być zalecane w przypadku długo trwających operacji tworzenia kopii zapasowej, aby takie zadanie jak najmniej przeszkadzało obciążeniu produkcyjnemu.

## TCP

* Długość kolejki nawiązanych połączeń TCP może być także ustawiona przez aplikację jako argument `backlog` dla funkcji `listen()`.

* Pakiety zagubione i przepełnienia wskazują na nasycenie interfejsu sieciowego.

* Informacje o tym, jakie parametry są aktualne dostępne dla TCP, można znaleźć, wyszukując tekst tcp w danych wyjściowych sysctl - `sudo sysctl -a | grep tcp`

* Maksymalną wielkość bufora gniazd dla wszystkich rodzajów protokołów, zarówno dla odczytu (rmem_max), jak i zapisu (wmem_max) można ustawić za pomocą poniższych parametrów: `net.core.rmem_max = 16777216` i `net.core.wmem_max = 16777216`. Wartości są podawane w bajtach. Aby zapewnić możliwość obsługi połączeń o szybkości 10GbE, może być potrzeba ustawienia powyższym parametrom wartości 16 MB lub więcej. Następny prezentowany parametr pozwala na automatyczne dostrojenie bufora otrzymywanych danych TCP: `tcp_moderate_rcvbuf = 1`. Kolejne przedstawiane parametry powodują automatyczne dostrojenie parametrów dla buforów odczytu i zapisu TCP: `net.ipv4.tcp_rmem = 4096 87380 16777216` i `net.ipv4.tcp_wmem = 4096 65536 16777216`. Każdy parametr ma trzy wartości: minimalną, domyślną i maksymalną liczbę bajtów do użycia. Stosowana wielkość jest automatycznie dostrajana do wartości domyślnej. W celu poprawy przepustowości TCP warto zwiększyć wartość maksymalną. Zwiększenie wartości minimalnej i domyślnej spowoduje, że połączenia będą zużywać większą ilość pamięci, co może okazać się niepotrzebne.

* Pierwsza kolejka backlog jest przeznaczona dla półotwartych połączeń: `tcp.max_syn_backlog = 4096`. Z kolei druga kolejka backlog jest przeznaczona dla połączeń przekazywanych funkcji `accept()`: `net.core.somaxconn = 1024`. Oba wymienione parametry mogą wymagać zwiększenia wartości domyślnych, na przykład do 4096 i 1024 lub więcej, aby lepiej obsłużyć duże skoki obciążenia.

* Poniższy parametr umożliwia zwiększenie długości kolejki backlog urządzenia sieciowego dla poszczególnych procesorów: `net.core.netdev_max_backlog = 10000`. Ta wartość również może wymagać zwiększenia, na przykład do 10 000 dla kart sieciowych w standardzie 10 GbE.

* System Linux obsługuje dołączane algorytmy kontroli przeciążenia. Poniższe polecenie powoduje wyświetlenie listy aktualne dostępnych algorytmów: `sysctl net.ipv4.tcp_available_congestion_control`.

* `nstat -asz` network statistics tool

* Statystki z pliku `/proc/net/netstat` możemy sprawsować za pomocą awk - `awk '{for(i=1;i<=NF;i++)title[i] = $i; getline; print title[1]; for(i=2;i<=NF;i++)printf " %s: %s\n", title[i], $i }' /proc/net/netstat`

* Opcje gniazda. Wielkość bufora można dostroić przez aplikację za pomocą funkcji setsockopt. Zwiększenie wielkości (aż do omówionej wcześniej wielkości maksymalnej narzucanej przez system) może poprawić wydajność przepustowości sieci.

Inne parametry TCP, które można ustawić, to między innymi:

```
net.ipv4.tcp_sack = 1
net.ipv4.tcp_fack = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 0
```

Rozszerzenia SACK i FACK mogą poprawić wydajność przepustowości w sieciach charakteryzujących się dużym opóźnieniem, choć odbywa się to kosztem większego zużycia procesora.
Parametr `tcp_tw_reuse` pozwala na ponowne użycie sesji TIME-WAIT, gdy taka możliwość wydaje się bezpieczna. W ten sposób można zapewnić większą liczbę połączeń między dwoma komputerami, na przykład między serwerem WWW i bazą danych, bez osiągnięcia 16 bitowego ograniczenia portu ephemeral z sesjami w TIME-WAIT.
Z kolei `tcp_tw_recycle` to inny sposób na ponowne użycie sesji TIME-WAIT, choć nie jest tak bezpieczny jak `tcp_tw_reuse`.

## Książki

Brendan Gregg, _Wydajne systemy komputerowe. Przewodnik dla administratorów systemów lokalnych i w chmurze_, Helion
