# Automatyczne usuwanie nieaktywnych metryk Prometheusa w PHP

W jednym z projektów PHP chcieliśmy wystawiać własne metryki aplikacji.
Była to aplikacja działająca na PHP-FPM, metryki przechowywaliśmy w bazie danych.
W PHP-FPM nie można przechowywać danych w pamięci pomiędzy kolejnymi requestami, dlatego Prometheus pobierał metryki z endpointu `/metrics`, który odczytywał je z bazy.

Takie rozwiązanie ma jednak wadę.
Po kilku miesiącach w bazie gromadzi się wiele przestarzałych metryk, które od dawna nie były aktualizowane.
Nadal były zwracane przez endpoint `/metrics`, mimo że w praktyce nie miały już żadnego znaczenia.

W innych językach, np. w Go, problem nie występuje.
Metryki są przechowywane w pamięci i znikają po restarcie poda lub aplikacji.

Zdecydowałem się dodać kolumne `last_updated` do tabli `prometheus__values`:

```
ALTER TABLE prometheus__values ADD COLUMN last_updated DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
```

Zmiana nie wymagała żadnych modyfikacji w SDK Prometheusa dla PHP.
Zarówno podczas tworzenia nowej metryki, jak i aktualizacji istniejącej, kolumna last_updated jest automatycznie ustawiana na bieżący czas.

Dzięki temu mogę okresowo usuwać metryki, które nie były aktualizowane od ponad X dni.

Efektem jest mniejsza liczba metryk zwracanych przez endpoint `/metrics`, a także mniejsze cardinality.
