# valgrind

## Śledzenie deskryptorów plików

Valgrind monitoruje deskryptory plików otwierane i zamykane przez program.
Sprawdza, czy program poprawnie zamyka wszystkie otwarte deskryptory (np. plików, gniazd sieciowych) przed zakończeniem działania.
Na końcu działania programu raportuje, które deskryptory (jeśli jakieś) pozostały otwarte, co może wskazywać na wycieki zasobów.

```
valgrind --track-fds=yes ./prog_name
```
