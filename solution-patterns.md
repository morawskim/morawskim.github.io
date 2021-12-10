# Solution patterns

### Materializowanie konfliktów

Skoro problem z fantomami polega na tym, że nie istnieje obiekt, do którego można zastosować
blokadę, może warto sztucznie dodać blokowany obiekt do bazy?
Na przykład w scenariuszu z rezerwacją sali konferencyjnej można sobie wyobrazić tabelę z pomieszczeniami i oknami czasowymi. Każdy wiersz tej tabeli odpowiada konkretnej sali w określonym
czasie (np. dla 15 minut). Można z góry utworzyć wiersze dla wszystkich możliwych kombinacji sal
i okien czasowych np. na sześć miesięcy wprzód.
Teraz transakcja, która chce dodać rezerwację, może zablokować (za pomocą instrukcji SELECT
FOR UPDATE) wiersze tabeli odpowiadające potrzebnej kombinacji sali i okien czasowych. Po zajęciu blokady można sprawdzić, czy nie występują sprzeczne rezerwacje, i dodać nową rezerwację
w opisany wcześniej sposób. Zauważ, że dodatkowa tabela nie służy do przechowywania informacji
o rezerwacjach. Stanowi ona wyłącznie kolekcję blokad używanych do zapobiegania jednoczesnym
modyfikacjom rezerwacji tej samej sali w tym samym czasie.
To podejście bywa nazywane materializowaniem konfliktów, ponieważ przekształca fantomy w konflikt związany z blokadą konkretnego zestawu wierszy z bazy [11]. Niestety, ustalanie tego, jak
materializować konflikty, może być trudne i narażone na błędy. Ponadto wprowadzanie mechanizmu zarządzania współbieżnością do modelu danych aplikacji jest bardzo nieeleganckie. Z tych
powodów materializowanie konfliktów należy traktować jak ostatnią deskę ratunku, jeśli żadne
inne rozwiązanie nie jest możliwe. W większości sytuacji dużo bardziej wskazane jest zapewnienie
sekwencyjności.

Martin Kleppmann, "Przetwarzanie danych w dużej skali. Niezawodność, skalowalność i łatwość konserwacji systemów"


### percolator

Na przykład usługi monitorowania mediów subskrybują kanały informacyjne z artykułami i materiałami z różnych mediów oraz szukają wiadomości ze wzmiankami na temat firm, produktów lub określonych zagadnień. W tym celu zapytania są formułowane z góry, a następnie stale dopasowywane do strumienia wiadomości. Podobne funkcje występują w niektórych witrynach. Na przykład użytkownicy witryn z ofertami sprzedaży nieruchomości mogą zażądać powiadomień o pojawieniu się na rynku nowych mieszkań pasujących do kryteriów wyszukiwania. Mechanizm
percolator w Elasticsearch [76] to jedna z możliwości zaimplementowania tego rodzaju przeszukiwania strumieni.

[Odnośniki](https://github.com/ept/ddia-references/blob/master/chapter-11-refs.md)

Martin Kleppmann, "Przetwarzanie danych w dużej skali. Niezawodność, skalowalność i łatwość konserwacji systemów"

### Nieprecyzyjne zegary

Jednym ze sposobów na poradzenie sobie z nieprecyzyjnymi zegarami z urządzeń jest rejestrowanie
trzech znaczników czasu [82]:

* Czasu wystąpienia zdarzenia według zegara z urządzenia.
* Czasu przesłania zdarzenia na serwer według zegara z urządzenia.
* Czasu odebrania zdarzenia przez serwer według zegara z serwera.
Odjęcie drugiego znacznika czasu od trzeciego pozwala oszacować różnicę między zegarem
z urządzenia a zegarem z serwera (przy założeniu, że opóźnienie sieciowe jest pomijalne w porównaniu z wymaganą precyzją znaczników czasu). Następnie możesz uwzględnić tę różnicę w znaczniku
czasu zdarzenia i oszacować w ten sposób rzeczywisty czas wystąpienia zdarzenia (przyjmując, że
odchylenie zegara z urządzenia nie zmieniło się między momentem wystąpienia zdarzenia a czasem
przesłania go na serwer).

[Odnośniki](https://github.com/ept/ddia-references/blob/master/chapter-11-refs.md)

Martin Kleppmann, "Przetwarzanie danych w dużej skali. Niezawodność, skalowalność i łatwość konserwacji systemów"

### Identyfikatory operacji

Aby operacja była idempotentna w ramach kilku etapów komunikacji sieciowej, nie wystarczy polegać na mechanizmie obsługi transakcji zapewnianym przez bazę. Trzeba uwzględnić przepływ żądań między punktami końcowymi.
Możesz np. wygenerować unikatowy identyfikator operacji (taki jak UUID) i umieścić go jako
ukryte pole formularza w aplikacji klienckiej. Możesz też obliczyć skrót wszystkich istotnych pól
formularza, aby uzyskać identyfikator operacji [3]. Jeśli przeglądarka dwukrotnie prześle żądanie
POST, oba żądania będą miały ten sam identyfikator operacji. Ten identyfikator można przekazywać
aż do bazy danych i upewniać się tam, że operacja o danym identyfikatorze jest wykonywana tylko
raz. Ilustruje to listing 12.2.
Listing 12.2. Zapobieganie zduplikowanym żądaniom za pomocą unikatowego identyfikatora
```
ALTER TABLE requests ADD UNIQUE (request_id);
BEGIN TRANSACTION;
INSERT INTO requests
 (request_id, from_account, to_account, amount)
 VALUES('0286FDB8-D7E1-423F-B40B-792B3608036C', 4321, 1234, 11.00);
UPDATE accounts SET balance = balance + 11.00 WHERE account_id = 1234;
UPDATE accounts SET balance = balance - 11.00 WHERE account_id = 4321;
COMMIT;
```
Na listingu 12.2 wykorzystano więzy unikatowości dotyczące kolumny request_id. Jeśli transakcja
spróbuje wstawić identyfikator, który już istnieje, polecenie INSERT zakończy się niepowodzeniem
i transakcja zostanie anulowana, co zapobiega dwukrotnemu jej wykonaniu.

[Odnośniki](https://github.com/ept/ddia-references/blob/master/chapter-12-refs.md)

Martin Kleppmann, "Przetwarzanie danych w dużej skali. Niezawodność, skalowalność i łatwość konserwacji systemów"
