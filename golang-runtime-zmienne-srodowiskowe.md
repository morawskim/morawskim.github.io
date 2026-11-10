# Golang runtime - zmienne środowiskowe

Alex Rios, _System Programming Essentials with Go. System calls, networking, efficiency, and security practices with practical projects in Golang_, Packt Publishing

## GOGC

`GOGC` to zmienna środowiskowa wykorzystywana przez środowisko uruchomieniowe Go do kontrolowania zachowania garbage collectora.

Pozwala regulować, jak często Garbage Collector powinien uruchamiać proces automatycznego zwalniania pamięci.

Domyślna wartość GOGC wynosi 100.
Wyznacza próg kolejnego uruchomienia GC na podstawie zajmowanej pamięci.
GOGC określa procentowy wzrost pamięci sterty (heap) przed kolejnym cyklem GC.

Ustawienie GOGC=off wyłącza automatyczne uruchamianie Garbage Collectora.

## GODEBUG

`GODEBUG` pozwala uzyskać szczegółowe informacje na temat wewnętrznego działania środowiska uruchomieniowego Go.
Ustawienie GODEBUG=gctrace=1 jest często wykorzystywane do uzyskiwania szczegółowych informacji o procesie garbage collection.

Przykładowy wynik:

> gc 1 @0.019s 2%: 0.015+2.5+0.003 ms clock, 0.061+0,.5/2.0/3.0+0.012 ms cpu, 4->4->1 MB, 5MB goal, 4 P

Rozłóżmy ten wynik na poszczególne elementy:

`gc 1` - numer kolejnego cyklu garbage collection

`@0.019s` - czas (w sekundach) od uruchomienia programu, w którym rozpoczął się dany cykl GC.

`2%` - procent całkowitego czasu działania programu, który został poświęcony na Garbage Collection.

`0.015+2.5+0.003 ms clock` - podział czasu trwania cyklu GC

* 0.015 ms - czas trwania fazy STW
* 2.5 ms - czas trwania fazy oznaczania i skanowania pamięci (concurrent mark and scan).
* 0.003 ms - czas trwania fazy STW mark termination

`0.061+0.5/2.0/3.0+0.012 ms cpu` - czas procesora (CPU) wykorzystany podczas cyklu GC

* 0.061 ms - czas CPU wykorzystany przez fazę STW sweep termination
* 0.5/2.0/3.0 - czas CPU wykorzystany przez fazę oznaczanie i skanowanie pamięci
* 0.012 ms - czas CPU wykorzystany przez fazę STW mark termination

`4->4->1 MB` - rozmiar sterty (heap) na początku, w połowie i na końcu cyklu GC

* 4 MB – rozmiar heap na początku cyklu
* 4 MB – rozmiar heap w połowie cyklu
* 1 MB – rozmiar heap po zakończeniu cyklu

`5 MB goal` - docelowy rozmiar heap, przy którym powinien rozpocząć się kolejny cykl GC
`4 P` - liczba procesorów logicznych (P – procesorów schedulera Go) wykorzystywanych przez runtime podczas cyklu GC

## GOMEMLIMIT

`GOMEMLIMIT` pozwala ustawić miękki limit (soft memory limit) zużycia pamięci przez środowisko uruchomieniowe Go.
Limit ten obejmuje nie tylko pamięć wykorzystywaną przez heap, ale również inne obszary pamięci zarządzane przez go.
