# Algorytmy

### Automatyczne rozwiązywanie konfliktów

Przeprowadzono ciekawe badania nad automatycznym rozwiązywaniem konfliktów spowodowanych
jednoczesnymi modyfikacjami danych. Warto wspomnieć o kilku obszarach takich badań:

* Typy CRDT (ang. conflict-free replicated datatypes) [32, 38] to rodzina struktur danych obejmujących zbiory, odwzorowania, listy uporządkowane, liczniki itd., które mogą być jednocześnie
edytowane przez wielu użytkowników i które automatycznie eliminują konflikty w sensowny sposób. Niektóre typy CRDT zostały zaimplementowane w bazie Riak 2.0 [39, 40].

* Trwałe struktury danych z możliwością scalania [41] bezpośrednio śledzą historię zmian (podobnie jak robi to system kontroli wersji Git) i używają funkcji scalania trójstronnego (w typach CRDT używane jest scalanie dwustronne).

* Mechanizm OT (ang. operational transformation) [42] to algorytm rozwiązywania konfliktów
używany w aplikacjach do edycji zespołowej takich jak Ehterpad [30] i Google Docs [31]. Został
zaprojektowany specjalnie z myślą o jednoczesnej edycji uporządkowanych list elementów, np.
list znaków w dokumencie tekstowym.

[Odnośniki](https://github.com/ept/ddia-references/blob/master/chapter-05-refs.md)

Martin Kleppmann, "Przetwarzanie danych w dużej skali. Niezawodność, skalowalność i łatwość konserwacji systemów"

### Leslie Lamport OTP

Leslie Lamport, "Password Authentication with Insecure Communication", Communications of the ACM 24.11 (November 1981)

[Lamport OTP system](https://security.stackexchange.com/questions/90909/lamport-otp-system)
