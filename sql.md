## SQL

## Porady / Dobre praktyki
John L. Viescas, Douglas J. Steele, Ben G. Clothier, _Mistrzowski SQL. 61 technik pisania wydajnego kodu SQL_, Helion

* Klucz główny powinien być kluczem surogatowym. Klucz naturalny (ang. meaningful key) to na przykład numer PESEL, czy też numer telefonu. Klucz surogatowy (ang. meaningless key) to liczba ustalana przez bazę danych. Choć klucze naturalne mogą wydawać się dobrym rozwiązaniem, rzadko sprawdzają się w praktyce. Klucz podstawowy powinien być niepowtarzalny i niezmienny. Z definicji klucze naturalne je spełniają te wymagania, ale nie można zapomnieć o czynniku ludzkim. Użytkownicy mogą błędnie wprowadzić swój numer PESEL czy też numer telefonu.

* Należy pamiętać o ważnej zasadzie: Kolumny są kosztowne. Rekordy są tanie. Należy rozważyć alternatywę, gdy projekt bazy wymaga dodawania lub usuwania kolumn.

* Sygnałem ostrzegawczym, że projekt jest w 3NF, ale nie spełnia wymagań wyższych form normalnych, jest relacja tabeli z więcej niż jedną inną tabelą.

* Zdenormalizowane bazy danych dobrze radzą sobie z intensywnymi operacjami odczytu, ponieważ dane znajdują się w mniejszej liczbie tabel, a potrzeba złączenia tabel jest mniejsza lub zupełnie nie istnieje.

* Jeżeli większość rekordów zawiera wartość `NULL` w indeksowanej kolumnie, indeks prawdopodobnie nie będzie specjalnie użyteczny, o ile nie wyszukujesz zawsze czegoś innego niż `NULL`. Indeks ten może zajmować dużo miejsca, chyba że Twój system bazodanowy pozwala wykluczyć wartości `NULL`  z indeksu.

* MySQL traktuje wartości `NULL` jako różniące się od siebie. Dlatego możesz tworzyć indeksy typu `UNIQUE` i wstawiać wiele wartości `NULL` do kolumny pokrytej indeksem `UNIQUE`.

* Jeżeli kardynalność kolumny jest niska (duża część rekordów indeksu ma taką samą wartość), indeks nie da dużych korzyści.

* Indeksy filtrowane są tworzone poprzez dodanie klauzuli `WHERE` do deklaracji indeksu. Zysk w wydajności w porównaniu do indeksów tradycyjnych może być znaczący, jeżeli istnieje wartość często wykorzystywana w klauzuli `WHERE`, ale obejmująca jedynie niewielki procent wszystkich rekordów w tabeli.

* Indeksy filtrowane mogą być wykorzystywane do implementacji unikalności wartości dla podzbioru danych (np. tylko tych, gdzie `WHERE active = 'Y'`).

* Rozważ, czy partycjonowanie tabeli da korzyści podobne do indeksów filtrowanych (bez dodatkowego narzutu w postaci konieczności utrzymywania kolejnego indeksu).

* Jeśli w klauzuli `WHERE` wykorzystamy funkcję, oznacza iż dla zapytania nie zostanie wykorzystany indeks.

* Dobrym zwyczajem jest stosowanie funkcji `DATEADD` do implementacji filtrowania zakresu da. Użytkownik wprowadzając zakres dat` '2021-10-04' - '2021-10-05'` oczekuje `>= '2021-10-04'` i ` < '2021-10-05'`.

* Nie polegaj na niejawnych konwersjach dat; wykorzystaj funkcje do jawnej konwersji literałów dat.

* Nie wykorzystuj funkcji dla kolumn typu `datetime`, ponieważ dla takich zapytań system nie będzie mógł korzystać z indeksów.

* Pamiętaj że błędy zaokrąglania mogą powodować, iż wartości dat i czasu będą niedokładne używaj `>=` i `<` zamiast `BETWEEN`.

* Zbyt dużo kolumn w klauzuli GROUP BY może negatywnie wpłynąć na wydajność zapytania, a także utrudnić czytanie, zrozumienie i przepisywanie zapytania.

* Wykorzystanie podzapytania skorelowanego może być bardzo kosztowne, ponieważ system bazodanowy musi wykonać podzapytanie dla każdego rekordu. Jednak czasami podzapytanie, nawet skorelowane, może być bardziej wydajne niż wykorzystanie GROUP BY.

* Generalnie podzapytania można użyć wszędzie tam, gdzie można użyć nazwy tabeli.

* Przechodzimy do półek, odnajdujemy rekord, z którego odczytujemy wartość CustCity i wracamy do katalogu, aby odszukać kolejną pozycję. Właśnie to oznacza operacja sprawdzenia klucza (ang. Key Lookup). Operacja przeszukania indeksu (ang. Index Seek) reprezentuje przeglądanie katalogu, podczas gdy sprawdzenie klucza oznacza przejście do regałów i pobranie dodatkowych informacji niezawartych w fiszce.

