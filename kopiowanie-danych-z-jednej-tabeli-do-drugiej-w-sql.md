# Kopiowanie danych z jednej tabeli do drugiej w SQL

Podczas migracji danych konieczne jest zachowanie oryginalnych danych na czas tworzenia i weryfikacji poprawności procesu.
Dzięki temu możemy wielokrotnie testować migrację od początku, korzystając z niezmienionych danych.
Po pomyślnym zakończeniu testów i upewnieniu się, że wszystko działa poprawnie, można ostatecznie przeprowadzić migrację i usunąć tymczasową tabelę ze środowiska deweloperskiego.

Skopiowanie struktury tabeli

```sql
CREATE TABLE nowa_tabela LIKE oryginalna_tabela;
```

Skopiowanie danych do nowej tabeli

```sql
INSERT INTO nowa_tabela SELECT * FROM oryginalna_tabela;
```

Po skopiowaniu danych możemy przeprowadzić testy na nowej tabeli. Jeśli coś pójdzie nie tak, zawsze możemy skasować dane z nowej tabeli i ponownie je załadować z oryginalnej tabeli.
