# MongoDB

## Porady/Dobre praktyki

* Serwer podległy powinien mieć możliwość pozostania w trybie offline przez przynajmniej 8 godzin. Zwiększenie wielkości dziennika zdarzeń replikacji zapewni dodatkową ilość czasu w przypadku awarii sieci itd. Dzięki temu możemy uniknąć konieczności ponownej pełnej synchronizacji któregokolwiek węzła.

* Za pomocą parametru `wtimeout` możemy określić maksymalny czas oczekiwania na potwierdzenie, że operacja zapisu została zreplikowana. Jeśli błąd ma być zgłoszony gdy wymagany poziom replikacji nie zostanie osiągnięty w trakcie 500ms, to parametrowi `wtimeout` przypisujemy wartość 500. Jeśli nie podamy wartości dla `wtimeout`, a replikacja z jakiegokolwiek powodu nigdy nie wystąpi, operacja będzie blokowała aplikację w nieskończoność.

* Zasada osadzania dokumentu vs oddzielna kolekcja -  użyj osadzania dokumentu jeśli obiekt potomny nigdy nie pojawia się poza kontekstem jego obiektu nadrzędnego. W przeciwnym razie obiekty potomne przechowuj w oddzielnej kolekcji. W przypadku osadzenia dokumentów mamy nieco większą wydajność działania, natomiast odwołania zapewniają większą elastyczność.
