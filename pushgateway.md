# Pushgateway

## Pułapki

Jeśli wiele instancji (np. aplikacji, usług) wysyła metryki do jednego Pushgateway, to staje się on kluczowym elementem całego monitoringu.
Oznacza to, że jeśli Pushgateway przestanie działać, wszystkie te metryki mogą zostać utracone, a dodatkowo duża liczba połączeń może spowodować spowolnienie działania systemu.

W standardowym podejściu Prometheus automatycznie sprawdza, czy instancje działają, wykorzystując metrykę up (każde zapytanie do usługi zwraca informację, czy jest ona aktywna).
Jeśli jednak metryki są wysyłane przez Pushgateway, Prometheus nie ma bezpośredniego połączenia z instancjami, więc nie może wykryć, czy dana instancja przestała działać.

Każda metryka przesłana do Pushgateway pozostaje tam na zawsze, dopóki nie zostanie ręcznie usunięta przez API.
Oznacza to, że jeśli jakaś usługa przestanie wysyłać dane (bo np. została wyłączona), to jej stare metryki nadal będą dostępne w Prometheusie, co może prowadzić do błędnych analiz i nieaktualnych danych.

[When to use the Pushgateway](https://prometheus.io/docs/practices/pushing/)

[Common pitfalls when using the Pushgateway](https://www.robustperception.io/common-pitfalls-when-using-the-pushgateway/)
