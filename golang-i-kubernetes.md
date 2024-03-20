# Golang i Kubernetes

## CPU

Ustawiając limity czasu procesora kontenerowi możemy spowodować, że aplikacja w Go nie będzie działać wydajnie. Ustawienie 500m pozwala korzystać aplikacji z 1 rdzenia przez 50% czasu.

W przypadku węzła, gdzie jest więcej niż 1 rdzeń CPU znacząco to wpływa na wydajność.
Domyślnie środowisko wykonawcze Go uruchamia tyle wątków do obsługi gorutine, ile jest rdzeni CPU.
Ustawiając zmienną środowiskową `GOMAXPROCS` ograniczamy tworzenie tych wątków. Tym samym redukujemy czas przełączania kontekstu.

## Pamięć

Kiedy aplikacja działa w kontenerze w klastrze Kubernetes, środowisko Go domyślnie nie jest świadome limitów pamięci przydzielonych do kontenera. 
Jeśli na serwerze mamy 16GB pamięci, Go uzna że tyle jest dostępnej pamięci i proces GC będzie zachodził znacznie rzadziej. Tym samym ten jeden kontener będzie ciągle alokował nową pamięć do osiągnięcia limitu.

Rozwiązaniem jest ustawienie zmiennej środowiskowej `GOMEMLIMIT`.
Zmienna ta ustawia "soft limit", co oznacza, że środowisko wykonawcze Go nie gwarantuje, że użycie pamięci nie przekroczy tego  limitu. W przypadku zbliżania się do limitu działanie GC będzie bardziej agresywne i częstsze.

Wartość do GOMEMLIMIT możemy pobrać z przydzielonych limitów, ale brakuje możliwości ustawienia pewnego buforu - [Allow setting an environment variable to some fraction or multiple of a resource field #91514 ](https://github.com/kubernetes/kubernetes/issues/91514)
```
env:
  - name: GOMEMLIMIT
    valueFrom:
      resourceFieldRef:
        resource: limits.memory
```
