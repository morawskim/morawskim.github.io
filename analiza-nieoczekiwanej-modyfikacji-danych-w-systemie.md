# Analiza nieoczekiwanej modyfikacji danych w systemie

W projekcie wystąpiła sytuacja, w której zostały zmodyfikowane dane, których nikt nie potrafił wyjaśnić.
Pobrałem kopię bazy danych z dnia poprzedzającego modyfikację (kiedy spodziewałem się, że stare dane były widoczne po raz ostatni), a także z dnia, w którym doszło do nadpisania danych.

Ze względu na to, że baza miała rozmiar kilkudziesięciu gigabajtów, jej pełny import na moim środowisku trwałby kilka godzin.
Zdecydowałem się więc wyodrębnić tylko interesującą mnie tabelę za pomocą polecenia:
`zcat ./dumpdb.gz | sed -n -e '/CREATE TABLE.*`mytable`/,/Table structure for table/p' >  mytable.dump`

W pliku `mytable.dump` znalazły się wyłącznie dane tej jednej tabeli.
Za pomocą `grep` przefiltrowałem rekordy, aby odnaleźć interesujący mnie wiersz.
Zawierał on – zgodnie z oczekiwaniami – stare, jeszcze niemodyfikowane dane.

Następnie pobrałem zrzut bazy z dnia kolejnego i ponownie wyciąłem z niego dane tej samej tabeli, filtrując je do tego samego rekordu.
Tym razem rekord był już zmodyfikowany, co potwierdziło, że zmiana nastąpiła w ciągu jednego dnia.

Aby zlokalizować miejsce w kodzie, które mogło odpowiadać za tę modyfikację, przeszukałem projekt pod kątem wystąpień nazwy kolumny z analizowanej tabeli.
W ten sposób trafiłem na fragment kodu, który potencjalnie mógł zmieniać dane – był on wykonywany w trakcie wywoływania konkretnej akcji w systemie w przypadku spełnienia kilku warunków.

Pobrałem logi dostępu serwera HTTP z produkcji i wyciąłem z nich wpisy z interesującego mnie dnia:
`zcat access-logs.gz | sed -n -e '/.*08/Jul/2025/,/.*09/Jul/2025/p' >  logs08`

Następnie, korzystając z uzyskanego wycinka, przefiltrowałem żądania po konkretnej ścieżce:
`cat logs08 | grep 'POST /controller\/myaction'`

Podczas dalszej analizy kodu okazało się, że wspomniana akcja modyfikowała również inne pola oraz zapisywała datę zdarzenia w innej tabeli. Dzięki tej dacie mogłem jednoznacznie powiązać wpis w logach z modyfikacją rekordu.

To potwierdziło moją hipotezę: dane mogły zostać zmienione w wyniku wywołania tej konkretnej akcji, przy spełnieniu określonych warunków – co nie było powszechnie wiadome w zespole.
