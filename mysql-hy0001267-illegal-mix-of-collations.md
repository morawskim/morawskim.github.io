# MySQL - [HY000][1267] Illegal mix of collations

Osoba z działu Data Analysis zgłosiła problem z zapytaniem SQL. Otrzymywała błąd:

>[HY000][1267] Illegal mix of collations (utf8mb4_0900_ai_ci,COERCIBLE) and (utf8mb4_general_ci,COERCIBLE) for operation '='

Ja korzystałem z klienta MySQL wbudowanego w PHPStorm.
Po wywołaniu polecenia: `SHOW SESSION VARIABLES LIKE 'collation\_%';` otrzymałem wynik:

```
+--------------------+------------------+
|Variable_name       |Value             |
+--------------------+------------------+
|collation_connection|utf8mb4_0900_ai_ci|
|collation_database  |utf8mb4_unicode_ci|
|collation_server    |utf8mb4_0900_ai_ci|
+--------------------+------------------+
```

Natomiast osoba z działu analizy, po wykonaniu tego samego zapytania, otrzymała trochę inne dane:

```
+--------------------+------------------+
|Variable_name       |Value             |
+--------------------+------------------+
|collation_connection|utf8mb4_general_ci|
|collation_database  |utf8mb4_unicode_ci|
|collation_server    |utf8mb4_0900_ai_ci|
+--------------------+------------------+
```

Jawne ustawienie kodowania dla połączenia poleceniem: `SET @@session.collation_connection = 'utf8mb4_0900_ai_ci';` rozwiązało problem.

Analityk korzystał z HeidiSQL. Możliwe, że w tym programie istnieje opcja konfiguracji domyślnego kodowania dla połączenia.
