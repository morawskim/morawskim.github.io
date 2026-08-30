# MySQL

* Włączenie trybu „ścisłego” polega na ustawieniu trybu `STRICT_ALL_TABLES` lub `STRICT_TRANS_TABLES` (albo obu jednocześnie).
W tym trybie serwer zachowuje się znacznie bardziej restrykcyjnie w zakresie akceptowania nieprawidłowych wartości danych.
W szczególności oznacza to odrzucenie nieprawidłowych wartości zamiast ich automatycznej zmiany na najbliższą poprawną wartość.


* Jeżeli podzapytanie zwraca pojedynczy rekord, można użyć konstruktora rekordu do porównania zbioru wartości (czyli krotki) z wynikiem podzapytania.
Poniższe zapytanie zwraca rekordy prezydentów, którzy urodzili się w tym samym mieście i stanie, w którym urodził się John Adams:
`select last_name, first_name, city, state FROM president where (city, state) = (SELECT city, state FROM president where last_name = 'Adams' AND first_name = 'John');`


* Aby sprawdzić, jakie zestawy znaków i sortowania są dostępne na serwerze, wykonaj poniższe zapytania.
> show character set;
> show collation;


* Dowolny ciąg tekstowy może zostać przekonwertowany z zastosowaniem wskazanego kodowania znaków:
`CONVERT(ciag_tekstowy USING kodowanie_znakow);`

* Metoda polegająca na wskazaniu kodowania znaków oraz funkcja `CONVERT` nie są tym samym.
Wskazanie kodowania znaków nie powoduje modyfikacji ciągu tekstowego podczas jego interpretacji ani nie zmienia jego wartości.


* Dane wyjściowe poniższego zapytania pokazują, że komunikacja między klientem a serwerem odbywa się z zastosowaniem zestawu znaków `latin1`:

```
SHOW VARIABLES LIKE 'character\_set\_%';
```


* Aby używać zestawu znaków utf8, należy zmienić wartości trzech zmiennych:
> set character_set_client = utf8
set characterset_results = utf8
set character_set_connection = utf8

Jednak w takim przypadku znacznie wygodniejsze jest użycie instrukcji `SET NAMES`.
Poniższa instrukcja jest odpowiednikiem trzech poprzednich instrukcji:

```
set names 'utf8'
```


* Zmienna systemowa `max_sort_length` wpływa na operacje porównywania i sortowania wartości typu `BLOB` oraz `TEXT`.
Podczas tych operacji używanych jest jedynie pierwszych `max_sort_length` bajtów.
W przypadku kolumn typu `TEXT` korzystających z wielobajtowego zestawu znaków oznacza to, że operacja porównania może uwzględniać mniejszą liczbę znaków niż wynikałoby to z wartości zmiennej `max_sort_length`.
Jeżeli przy domyślnej wartości `max_sort_length`, wynoszącej 1024 bajty, powoduje to problemy podczas porównywania lub sortowania wartości, należy zwiększyć wartość tej zmiennej przed wykonaniem tych operacji.


* Wartości ENUM mogą być przetwarzane szybko, ponieważ wewnętrznie są reprezentowane w postaci wartości liczbowych.


* Typ `SET` jest podobny do typu `ENUM` pod tym względem, że podczas tworzenia kolumny `SET` definiujesz listę dozwolonych wartości.
Wspomniana lista może składać się z maksymalnie 64 elementów.
W przeciwieństwie do typu `ENUM`, wartością kolumny typu `SET` może być dowolna liczba elementów wybranych z tej listy.
Jednym z przykładów zastosowania typu `SET` jest przechowywanie zestawu wartości, które nie wykluczają się wzajemnie, jak ma to miejsce w przypadku typu `ENUM`.


* Każda baza danych ma własny podkatalog w katalogu danych MySQL.
Tabele, widoki i wyzwalacze w bazie danych odpowiadają plikom w podkatalogu danej bazy danych.


* W przypadku `InnoDB` maksymalna wielkość systemowej przestrzeni tabel wynosi 4 miliardy stron o rozmiarze 16 KB.
Maksymalna wielkość przestrzeni tabel jest również związana z rozmiarem poszczególnych tabel `InnoDB` przechowywanych w tej przestrzeni tabel.


* Istnieje również możliwość wykonywania zapytań do tabel `GLOBAL_VARIABLES` i `SESSION_VARIABLES` w bazie danych `INFORMATION_SCHEMA` w celu uzyskania informacji o zmiennych systemowych. Na przykład:

```
select * from INFORMATION_SCHEMA.GLOBAL_VARIABLES where VARIABLE_NAME LIKE '%binlog%'
```


* Poniższe wywołanie powoduje założenie blokady o nazwie `Nellie` i oczekiwanie maksymalnie 10 sekund na jej uzyskanie:

```
GET_LOCK('Nellie', 10);
```


## Optymalizacja / Wydajność

* `STRAIGHT_JOIN` wymusza na optymalizatorze użycia tabel we wskazanej kolejności.
Normalnie optymalizator MySQL samodzielnie ustala kolejność skanowania tabel, która pozwala na możliwie szybkie pobranie rekordów. Jednak czasami może dokonać nieoptymalnego wyboru.
Jeżeli wykryjesz tego rodzaju sytuację, możesz wymusić kolejność wybraną przez siebie, używając słowa kluczowego `STRAIGHT_JOIN`.
Złączenie wykonane za pomocą `STRAIGHT_JOIN` wymusza przetwarzanie lewej tabeli przed prawą tabelą.


* Regularne wykonywanie instrukcji `OPTIMIZE TABLE` pozwala na eliminację lub ograniczenie ilości zmarnowanego miejsca we fragmentowanych tabelach `MyISAM` lub `InnoDB` oraz chroni tabele przed spadkiem wydajności podczas ich użytkowania.


* Wyższy poziom współbieżności można uzyskać w przypadku tabel `InnoDB` niż `MyISAM`.
W tabeli `InnoDB` obie operacje aktualizacji mogą przebiegać jednocześnie, o ile klienci nie aktualizują tego samego rekordu.
Natomiast w przypadku `MyISAM` silnik nakłada blokadę na tabelę dla pierwszego klienta, co powoduje, że drugi klient musi poczekać na zakończenie operacji zainicjowanej przez pierwszego klienta.


* Innym efektem przechowywania każdej tabeli w postaci oddzielnych plików jest wydłużenie czasu otwierania tabel wraz ze wzrostem ich liczby.
Operacje otwierania tabel są mapowane na operacje otwierania plików dostarczane przez system operacyjny.
Ich wydajność zależy między innymi od efektywności mechanizmów systemowych odpowiedzialnych za wyszukiwanie plików w katalogu.
Zazwyczaj nie stanowi to problemu, ale sytuacja może się zmienić, jeśli w bazie danych znajduje się bardzo duża liczba tabel.
Na przykład systemy plików XFS lub JFS zapewniają dobrą wydajność działania nawet w przypadku bardzo dużej liczby małych plików.
Jeśli zastosowanie innego systemu plików nie jest możliwe, konieczne może być ponowne przemyślenie struktury tabel pod kątem wymagań aplikacji i odpowiednie dostosowanie tej struktury.


* Zmienna `innodb_buffer_pool_size` ma jedynie wartość globalną.
Określa rozmiar bufora przechowującego dane i indeksy tabel `InnoDB`.


* Dwie zmienne, które można zwiększyć w celu poprawy wydajności, to `read_buffer_size` i `sort_buffer_size`.
Zmienne te określają rozmiar bufora używanego odpowiednio podczas operacji odczytu i sortowania.
Należy jednak zachować ostrożność, ponieważ wspomniane bufory są alokowane dla każdej sesji.
Dlatego ustawienie bardzo dużych wartości tych zmiennych może w rzeczywistości doprowadzić do spadku wydajności z powodu nadmiernego wykorzystania dostępnych zasobów systemowych.

## Kopia zapasowa / Backup

* Tworzenie kopii zapasowych z użyciem opcji `--opt` jest powszechnie stosowane, ponieważ pozwala przyspieszyć cały proces.
Należy jednak pamiętać, że opcja `--opt` ma również swoją cenę.
Optymalizuje ona proces tworzenia kopii zapasowej, a nie dostęp innych klientów do bazy danych.
W rezultacie użycie opcji `--opt` uniemożliwia innym użytkownikom aktualizowanie tabel w trakcie tworzenia kopii zapasowej, ponieważ nakłada jednoczesną blokadę na wszystkie tabele.


* W celu utworzenia kopii zapasowej tabel `InnoDB` użyj opcji `--single-transaction`.
Dzięki temu operacja zostanie przeprowadzona w ramach jednej transakcji, co pozwoli uzyskać spójną kopię zapasową.


* Jeżeli baza danych zawiera procedury składowane, wyzwalacze i zdarzenia, możesz jawnie dołączyć je do danych wyjściowych za pomocą opcji `--routines`, `--triggers` i `--events`.
Wszystkie wymienione opcje mają również odpowiadające im warianty `--skip` (na przykład `--skip-triggers`), które powodują wykluczenie odpowiednich obiektów z kopii zapasowej.
Domyślnie wyzwalacze są dołączane do kopii zapasowej, ponieważ są powiązane z tabelami, natomiast procedury składowane i zdarzenia nie są dołączane.


* Opcja `--master-data` jest użyteczna podczas generowania na serwerze głównym pliku kopii zapasowej przeznaczonego do wczytania na serwerze podrzędnym w ramach replikacji.
Dzięki tej opcji plik kopii zapasowej zawiera informacje o pozycji w binarnym dzienniku zdarzeń serwera głównego, które pozwalają serwerowi podrzędnemu rozpocząć replikację od właściwego miejsca po wczytaniu zawartości kopii zapasowej.


## Odzyskiwanie / Recovery

* W celu sprawdzenia tabel `InnoDB` należy wykonać instrukcję `CHECK TABLE` lub użyć narzędzia `mysqlcheck`, które nawiązuje połączenie z serwerem i wykonuje wspomnianą instrukcję.


* Aby naprawić tabelę `InnoDB`, w której wykryto problemy, należy w pierwszej kolejności utworzyć jej kopię zapasową.
Następnie należy usunąć tabelę i ponownie ją utworzyć, korzystając z przygotowanego wcześniej pliku kopii zapasowej.
Poniższa sekwencja poleceń pokazuje, jak sprawdzić tabelę, utworzyć jej kopię zapasową, a następnie ponownie utworzyć tabelę `absence` w bazie danych `sampdb`.

```
mysqlcheck sampdb absense
mysqldump sampdb absense > absence.sql
mysql sampdb < absence.sql
```


* Narzędzie `mysqlcheck` jest dostępnym z poziomu wiersza poleceń interfejsem dla instrukcji `CHECK TABLE` i `REPAIR TABLE`.
Nawiązuje ono połączenie z serwerem i wykonuje odpowiednie instrukcje na podstawie użytych opcji.
Dlatego `mysqlcheck` może sprawdzać lub naprawiać tabele tych samych silników baz danych, które obsługują instrukcje `CHECK TABLE` i `REPAIR TABLE`.


* Po przywróceniu baz danych lub tabel z plików kopii zapasowych kolejnym krokiem jest ponowne wykonanie tych instrukcji zapisanych w binarnym dzienniku zdarzeń, które zostały wykonane po utworzeniu ostatniej kopii zapasowej.
W ten sposób tabele zostaną przywrócone do stanu, w jakim znajdowały się w chwili wystąpienia awarii.

## Parametry

### innodb_force_recovery=poziom

Dla niższych wartości parametru poziom silnik `InnoDB` stosuje bardziej konserwatywne strategie odzyskiwania.
Typową zalecaną wartością początkową jest `4`.
Po ustawieniu wspomnianej zmiennej silnik `InnoDB` pozwala na dodawanie i usuwanie tabel, ale ich zawartość jest dostępna wyłącznie w trybie tylko do odczytu.
Po uruchomieniu serwera utwórz kopię zapasową tabel `InnoDB` za pomocą narzędzia `mysqldump`, aby odzyskać możliwie dużą ilość informacji.

### innodb_log_buffer_size

Silnik innodb pr obuje buforować w pamięci informacje o każdej transakcji i zapisuje je na dysku w pojedyńczej operacji dyskowej po zakończeniu transkacji.

Jeżeli transakcja jest ogromna i przekracza wielkość bufora, aktywność dyskowa jest większa i zapis zawartości bufora na dysku może wystąpić wieloktronie jeszcze przed zakończeniem transakcji.

Zwiększenie wielkości bufora pozwala na buforowanie w pamięci większej liczby transakcji bez konieczności wcześniejszego ich zapisu na dysku.


### max_connections

Maksymalna liczba jednoczesnych połączeń z klientami obsługiwanych przez serwer.

W przypadku mocno obciążonego serwera może wystąpić konieczność zwiększenia tej wartości.

Na przykład, jeśli serwer MySQL jest używany przez aktywny serwer WWW do przetwarzania dużej liczby zapytań generowanych przez skrypty PHP, zbyt niska wartość tej zmiennej może spowodować odrzucanie połączeń, a w konsekwencji uniemożliwić obsługę części żądań odwiedzających witrynę internetową.


### max_allowed_packet

Maksymalny rozmiar, jaki może osiągnąć bufor podczas komunikacji z klientem.

Domyślny rozmiar bufora wynosi 1 MB, a maksymalna dozwolona wartość wynosi 1 GB.


Jeśli zachodzi potrzeba uruchomienia programów mysql lub mysqldump z ograniczeniem rozmiaru pakietu do 16 MB, użyj następujących poleceń:

mysql --max_allowed_packet=16M ....
mysqldump --max_allowed_packet=16M


## Książki

Paul DuBois, _MySQL. Vademecum profesjonalisty. Wydanie V_, Helion
