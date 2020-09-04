# Symfony WebTest

W frameworku Symfony możemy testować kontrolery. Do przeprowadzenia tych testów potrzebujemy dodatkowego pakietu Symfony `browser-kit`. Do generowania danych testowych (ang. fixtures) warto wykorzystać pakiet `zenstruck/foundry`. Do cofania zmian w bazie danych możemy skorzystać z `dama/doctrine-test-bundle`. Te dwa pakiety dobrze ze sobą współpracują.

Nasza testująca klasa musi dziedziczyć po `Symfony\Bundle\FrameworkBundle\Test\WebTestCase`. Tworzymy fabrykę dla wybranej encji `./bin.console make:factory`, a także story poprzez polecenie `./bin/console make:story`. [Dokumentacja foundry](https://github.com/zenstruck/foundry) zawiera przykłady korzystania z story i fabryki.

W metodzie testującej tworzymy klienta HTTP symulującego przeglądarkę `$client = static::createClient();` Jeśli wcześniej załadowaliśmy story musimy wywołać statyczną metodę `static::ensureKernelShutdown();` aby wyłączyć kernel. W przeciwnym przypadku dostaniemy ostrzeżenie, a w nowszym Symfony zostanie zrzucony wyjątek. Jednak testując kontrolery często musimy być zalogowani. W przypadku pakietu `lexik/jwt-authentication-bundle` w [dokumentacji ](https://github.com/lexik/LexikJWTAuthenticationBundle/blob/276571c08633a14c5844766da49a6ea9563558f9/Resources/doc/3-functional-testing.md) mamy przykład metody, która pozwala nam zalogować się na wybrane konto i uzyskać token JWT. W przypadku Symfony 5.1 istnieje [metoda loginUser](https://symfony.com/doc/current/testing.html#testing-logging-in-users).

Do symulatora klienta HTTP możemy przekazać dodatkowe nagłówki HTTP. Niestandardowe nagłówki HTTP musimy poprzedzić prefiksem `HTTP_`. I tak, aby ustawić nagłówek `Accept` musimy utworzyć klucz `HTTP_ACCEPT`.
Wyjątki rzucone podczas testowania kontrolera przez symulator HTTP są przechwycane i zapisywane do logów. Utrudnia to debugowanie błędów. Możemy jednak wyłączyć łapanie wyjątków przez testowego klienta HTTP `$client->catchExceptions(false);`, dzięki temu błędy będą raportowane przez PHPUnit.

[Working with the Test Client](https://symfony.com/doc/current/testing.html#working-with-the-test-client)

[Etap 17: Testowanie](https://symfony.com/doc/current/the-fast-track/pl/17-tests.html)

[How to Simulate HTTP Authentication in a Functional Test](https://symfony.com/doc/5.0/testing/http_authentication.html)
