# MySQL Explain

PHPStorm (i pozostałe narzędzia JetBrains) nie umożliwiają pobrania wyniku `EXPLAIN` w formacie zgodnym z narzędziem [pt-visual-explain](https://docs.percona.com/percona-toolkit/pt-visual-explain.html).

MySQL obsługuje format JSON, jednak narzędzie Percony już nie.
Możemy natomiast skorzystać z narzędzia online [https://mysqlexplain.com](https://mysqlexplain.com), które prezentuje wynik polecenia `EXPLAIN` w czytelnej, graficznej formie.
W tym narzędziu korzystamy z formatu JSON.

Jeśli prywatność jest istotna i nie chcemy udostępniać wyniku polecenia `EXPLAIN`, powinniśmy połączyć się do bazy przez konsolowy klient MySQL i wykonać zapytanie z `EXPLAIN`.
W przypadku dużych zapytań możemy skorzystać z polecenia: `tee /sciezka/do/pliku` które zapisuje wyniki zapytań SQL do pliku.

Wynik zapytania `EXPLAIN` przekazujemy następnie do `pt-visual-explain`. W tym celu możemy uruchomić kontener: `docker run --rm -it -u $UID -v $PWD:/project -w /project perconalab/percona-toolkit:3.7 bash`.
