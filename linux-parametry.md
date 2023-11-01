# Parametry Linuxa

Ilya Grigorik, _Wydajne aplikacje internetowe. Przewodnik_, Helion

## TCP

`sysctl net.ipv4.tcp_window_scaling` - Zwraca wynik, czy system operacyjny Linux ma włączoną opcję dostrajania okna TCP. Wartość 1 oznacza że ma włączoną tą opcję.

`ss  --options  --extended --memory --processes --info` - wyświetlenie informacji o połączeniach sieciowych z statystykami protokołu TCP.

`cwnd` - rozmiar okna przeciążenia. Określony po stronie nadawcy limit danych jakie nadawca może wysyłać zanim odbierze potwierdzenie (pakiet ACK) od klienta.

`rwnd` - okno kontroli przepływu/odbioru. Zawiera informację o rozmiarze dostępnej przestrzeni w buforze przeznaczonej do przechowywania przychodzących danych.

Maksymalna ilość danych przesyłanych dla nowego połączenia TCP stanowi minimalne wartości `rwnd` i `cwnd`.

TCP posiada również mechanizm restartowania powolnego startu (`SSR` - ang. slow start restart), który resetuje okno przeciążenia danego połączenia po określonym czasie bezczynność. Mechanizm ten można wyłączyć (co jest zalecane).

`sysctl net.ipv4.tcp_slow_start_after_idle` powinno zwracać wartość 0.

`net.ipv4.tcp_max_syn_backlog` - ile połaczeń zostanie zaakceptowanych przez jądro przed zaakceptowaniem ich przez aplikację.

## sysctl

| Parametr | Opis|
| - | - |
| vm.overcommit_memory | W przypadku bazy danych Redis zalecaną wartość to 1 ("always overcommit, never check" - `man 5 proc` opis `/proc/sys/vm/overcommit_memory`). Gdy Redis musi zapisać stan pamięci na dysk (forma kopii bezpieczeństwa) tworzy proces potomny poprzez wywołanie systemowe fork . Takie wywołanie może wydawać się drogie, ale Linux obsługuje COW (copy on write), więc nie potrzebujemy dużo wolnej pamięci. Jednak Linux domyślnie zablokuje takie wywołanie ze względu na niewystarczająco ilość wolnej pamięci RAM. Zmieniając wartość tego parametru możemy wyłączyć ten mechanizm sprawdzający. |
