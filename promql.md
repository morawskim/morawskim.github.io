# PromQL

## increase a zmiana wartości licznika z "brak danych" na 1

W projekcie skorzystałem z Prometheusa do liczenia liczby wysłanych powiadomień.
W raporcie chcieliśmy uzyskać przyrost wartości licznika (counter) w zadanym przedziale czasu.

Okazało się jednak, że w przypadku utworzenia nowego szeregu czasowego (czyli przejścia z wartości „brak danych” na 1), funkcja `increase()` zwraca wartość 0, a nie 1.
Jest to znany problem, opisany w zgłoszeniu: [increase() should consider creation of new timeseries as reset #1673](https://github.com/prometheus/prometheus/issues/1673)

Ponieważ mój szereg czasowy zawiera dodatkowe etykiety (labels), zastosowałem następujące zapytanie PromQL:

```
foo_notifications_sent_total - ((foo_notifications_sent_total offset 1h) or ((foo_notifications_sent_total) * 0))
```

Dzięki temu zapytaniu ręcznie obliczam przyrost licznika w ostatniej godzinie:

* Bieżąca wartość licznika: `foo_notifications_sent_total`

* Wartość sprzed godziny: `foo_notifications_sent_total offset 1h`

* jeśli nie ma wartości sprzed godziny, używam `foo_notifications_sent_total * 0`, co daje wektor o tych samych etykietach, ale z wartością 0

* od bieżącej wartości odejmuję wartość sprzed godziny (lub 0, jeśli brak danych)

W efekcie uzyskujemy prawidłowy przyrost licznika, nawet jeśli szereg czasowy został utworzony niedawno.
