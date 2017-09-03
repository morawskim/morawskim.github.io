SSH, API i proxy
================

Podczas integracji z API REST, wykorzystuje bibliotekę Guzzle. Pozwala ona ustawić serwer proxy.

``` php
//konfiguracja klienta guzzle
//...
'proxy' => '127.0.0.1:8080'
//...
```

W przypadku problemu z API (np. 500) Guzzle rzuca nam wyjątek. Jeśli nie logujemy odpowiedzi serwera, możemy mieć problem z określeniem przyczyny błędu. Pomocny tu będzie serwer proxy. W tym przykładzie ja zastosowałem serwer proxy ZAP proxy (owasp-zap). Nasłuchuje on na porcie 8080.

Wpier możemy sprawdzić lokalnie, czy wszystko jest poprawnie skonfigurowane. Wydajemy poniższe polecenie:

``` bash
curl --proxy localhost:8080 -k google.com
```

W oknie ZAP proxy powinien pojawić się nowy wiersz. Możemy teraz połączyć się z zdalnym serwerem tworząc tunel. Usługa sshd musi zezwalać na tworzenie tuneli zdalnych.

``` bash
ssh user@host -R 8080:localhost:8080
```

Jeśli na serwerze znajduje się program curl możemy ponownie sprawdzić, czy wszystko działa. Modyfikujemy konfigurację klienta guzzle, tak aby korzystał z serwera proxy. Powinniśmy zobaczyć wszystkie requesty klienta guzzle w zap proxy.