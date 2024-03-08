# Golang i Kubernetes

## CPU

Ustawiając limity czasu procesora kontenerowi możemy spowodować, że aplikacja w Go nie będzie działać wydajnie. Ustawienie 500m pozwala korzystać aplikacji z 1 rdzenia przez 50% czasu.

W przypadku węzła, gdzie jest więcej niż 1 rdzeń CPU znacząco to wpływa na wydajność.
Domyślnie środowisko wykonawcze Go uruchamia tyle wątków do obsługi gorutine, ile jest rdzeni CPU.
Ustawiając zmienną środowiskową `GOMAXPROCS` ograniczamy tworzenie tych wątków. Tym samym redukujemy czas przełączania kontekstu.
