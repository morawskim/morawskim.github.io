# Monitorowanie

Podczas monitorowania systemu musimy wziąć pod uwagę poniższe cechy i dostosować je do konkretnych potrzeb:

* data resolution (jak często przesyłamy/pobieramy metryki systemu)
* data latency
* data diversity

Do monitorowania wydajności i reagowania potrzebujemy danych z małym opóźnieniem i dużą rozdzielczością.
Jednak do monitorowania wskaźników biznesowych nie potrzebujemy tak dużej rozdzielczości (np. ilość gotowych zamówień do wysyłki).

## Metody monitorowania

### Google

Cztery najważniejsze wskaźniki, które należy śledzić:

* Latency - czas potrzebny na dostarczenie żądania
* Traffic - liczba wysyłanych żądań
* Errors - wskaźnik nieudanych żądań
* Saturation - ilość pracy, która nie jest przetwarzana, która zwykle jest w kolejce

### RED

Metoda RED jest skoncentrowana na usługę i jest cenna do przewidywania doświadczeń klientów zewnętrznych korzystających z usługi.
Monitorowane metryki:

* Rate - Liczba otrzymanych żądań na sekundę
* Errors - Liczba nieudanych żądań na sekundę
* Duration - Czas trwania każdego żądania. Daje on wyobrażenie o tym, jak dobrze działa usługa i jak bardzo nieszczęśliwi mogą być użytkownicy.

### USE

Metoda USE jest skoncentrowana na zasobie sprzętowym (procesor, dysk, interfejsy sieciowe, pamięć RAM).
Dla każdego z nich należy monitorować:

* Utilization -  Średni czas, w którym zasób był zajęty obsługą żądań, lub ilość aktualnie wykorzystywanej pojemności zasobu. Przykładowo dysk, który jest zapełniony w 90%, miałby wykorzystanie w 90%
* Saturation -  Ilość pracy, której zasób nie był w stanie przetworzyć. Zwykle jest ona umieszczana w kolejce. Przykładowo jeśli na uruchomienie czeka 10 procesów, wartość nasycenia wynosi 10.
* Errors -  Liczba błędów, które wystąpiły. Przykładowo dysk, który zawiera błędne sektory.
