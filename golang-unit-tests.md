# Go unit tests

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
