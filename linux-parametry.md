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

