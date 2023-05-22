# Go unit tests/benchmark

* Kiedy musimy zamknąć/wyczyścić zasoby używane podczas testu użyj `t.Cleanup()`. W przeciwieństwie do funkcji odroczonej (`defer`), Cleanup działa również w przypadku paniki.

* Kiedy musimy wykonać jakieś zadanie przed uruchomieniem testów lub po, Golang umożliwia nam utworzenie funkcji `TestMain` per pakiet ([Dokumentacja](https://pkg.go.dev/testing#hdr-Main)). W przeciwieństwie do funkcji `init`, nie jest ona wywoływana podczas wykonywania programu.

```
func TestMain(m *testing.M) {
  // pre-process
  os.Exit(m.Run())
  // post-process
}
```

* Podczas uruchamiania testów powinniśmy dodać flagę `-race`. która włącza detektor wyścigu dostępu do danych. Włączenie tego trybu wydłuża czas wykonywania naszych testów, a także zwiększa zużycie pamięci.

* Testy powinniśmy odpalać się w losowej kolejności. Dzięki temu mamy większość pewność, że nasze testy faktycznie są odizolowane i nie wpływają na siebie nawzajem. Aby włączyć tą funkcję  dodajemy flagę `-shuffle=on`. Korzystając z trybu verbose na wyjściu wyświetli się "ziarno" (ang. seed) - liczba użyta do odpalenia testów w losowej kolejności. Jeśli nasze testy nie przejdą, to możemy w następnej próbie odpalić testy z jawnie zdefiniowaną wartością seed ustanawiając wartość parametru `-shuffle` nie na "on" tylko na tą wartość np. 1684051051229704221

* Gdy w teście wydajności musimy na przykład przygotować dane, które pochłaniają sporo czasu, możemy zresetować/wstrzymać licznik czasu. Struktura `testing.B` dostarcza nam niezbędne metody takie jak `ResetTimer` czy `StopTimer` i `b.StartTimer`.  Wykorzystując je jesteśmy w stanie oddzielić kod inicjujący test od testowanego kodu.

* Podczas wykonywania testów wydajności warto ustawić maksymalną wydajność procesora. Wywołując polecenie `cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor` zobaczymy aktualną politykę skalowania częstotliwości procesora.
Dostępne polityki są dostępne na wyjściu polecenia `cpupower frequency-info`. Komendą `sudo cpupower frequency-set -g performance` ustawimy maksymalną wydajność dla każdego rdzenia CPU.
