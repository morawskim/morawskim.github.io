Less - follow mode
==================

Pliki logów możemy przeglądać komendą:

``` bash
tail -f /var/log/apache2/domain-access
```

Wszystkie nowe dane będą wyświetlane na ekranie. Less też potrafi wyświetlać nowe dane, które zostały zapisane do pliku. Wystarczy odpalić program z argumentem "+F". Możemy wyjść z trybu "follow mode" wciskając klawisze \[ctrl\] + \[c\]. Później możemy wrócić do monitorowania, wciskając klawisz \[shift\] + \[f\]. Zaletą lessa jest możliwość wyszukiwania i przeglądania całego pliku. Nie musimy otwierać pliku dziennika w innym programie.

``` bash
less +F /var/log/apache2/domain-access
```