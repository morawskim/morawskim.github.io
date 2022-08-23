# AWS lambda

* AWS zaleca umieszczenie funkcji Lambda w sieci VPC tylko wtedy, gdy jest to absolutne niezbędne do uzyskania dostępu do zasobu nieosiągalnego w inny sposób. Umieszczenie funkcji Lambda w sieci VPC powoduje wzrost złożoności, zwłaszcza przy potrzebie jednoczesnego uruchomienia dużej liczby kopii funkcji.

* Wdrożenie funkcji lambda w publicznej podsieci VPC nie daje jej dostępu do Internetu, ani publicznego adresu IP. W prywatnej podsieci dostęp do Internetu jest dostępny, jeśli podsieć zawiera bramę/instancję NAT.

* Limit współbieżności (1000 jednocześnie działających funkcji lambda) jest na konto AWS, a nie na pojedynczą funkcję. Jedna funkcja może więc wykorzystać cały dostępny limit. Możemy ustawiać limity per funkcja, dodatkowo jeśli potrzebujemy większej współbieżności to możemy utworzyć zgłoszenie z prośbą o zwiększenie tego limitu.

* Każde wywołanie funkcji Lambda musi się zakończyć w ciągu maksymalnie 15 minut.

* Moc obliczeniowa procesora i wydajności sieci są przydzielane funkcji Lambda na podstawie aprowizacji pamięci. Więcej pamięci == lepszy procesor i sieć.

* Maksymalny rozmiar skompresowanego pakietu wdrożeniowego (pliku zip) wynosi domyślnie 50MB.
