# Profilowanie kodu Xdebug/Blackfire

## Xdebug

Aby profilować kod za pomocą Xdebug musimy ustawić opcję `xdebug.profiler_enable_trigger` na wartość 1. Dzięki temu wysyłając ciasteczko `XDEBUG_PROFILE` lub parametr GET/POST o takim kluczu włączymy profiler.

W odpowiedzi HTTP dostaniemy nagłówek `X-Xdebug-Profile-Filename` z wartością, gdzie zapisał się nasz plik do dalszej analizy. Przy domyślnej konfiguracji będzie to katalog `/tmp`. Jednak jeśli korzystamy z serwera apache i systemd to katalog `/tmp` dla tej usługi może być ukryty. Wywołując polecenie `systemctl cat apache2.service` w konfiguracji jednostki `Service` zobaczymy `PrivateTmp=true`. Plik profilera zapisze się w jednym z katalogów `/tmp/systemd-private-*`. Jeśli profilujemy skrypt CLI to możemy skorzystać z funkcji `xdebug_get_profiler_filename` do pobrania nazwy pliku.

Profilując kod na zdalnym serwerze, nie będziemy mieć takich samych ścieżek do plików. W ustawieniach KCacheGrind musimy dodać katalog z projektem - `Ustawienia` -> `Ustawienia KCachegrind`. Przechodzimy do zakładki `Komentarze` i dodajemy katalog do `Katalogi źródłowe`. W KCacheGrind jedna jednostka czasu to 1/1 000 000 sekundy.

[Profiling PHP Scripts](https://xdebug.org/docs/profiler)

## Blackfire

Aby profilować kod za pomocą usługi blackfire potrzebujemy rozszerzenia PHP (tzw. probe) `blackfire`, a także agenta i klienta. W przypadku korzystania z kontenerów dockera, dodajemy konfigurację nowej usługi:
```
blackfire:
    image: blackfire/blackfire
    environment:
        BLACKFIRE_SERVER_ID: ~
        BLACKFIRE_SERVER_TOKEN: ~
        BLACKFIRE_LOG_LEVEL: 1
```

Zmienne środowiskowe `BLACKFIRE_SERVER_ID` i `BLACKFIRE_SERVER_TOKEN` powinniśmy mieć zdefiniowane w naszym pliku `.env`. Chcąc wyświetlać komunikaty diagnostyczne agenta, możemy ustawić zmienną środowiskową `BLACKFIRE_LOG_LEVEL` na wartośc  `4`. Będąc na kontenerze agenta, możemy wywołać polecenie `blackfire-agent -d`, aby wyświetlić konfigurację.

Instalacja rozszerzenia PHP w pliku Dockerfile opisana jest [w dokumentacji](https://blackfire.io/docs/integrations/docker/php-docker). Musimy pobrać rozszerzenie, umieścić je w katalogu `extension_dir` i utworzyć plik ini. Plik ten załaduje rozszerzenie `blackfire` i ustawi parametr `blackfire.agent_socket` na adres agenta.

Jeśli chcemy także profilować skrypty PHP lub żadania AJAX to niezbędny jest zainstalowanie narzędzia CLI blackfire i ustawienie zmiennych środowiskowych `BLACKFIRE_CLIENT_ID` i `BLACKFIRE_CLIENT_TOKEN`. [W dokumentacji](https://blackfire.io/docs/integrations/docker/php-docker#using-the-client-for-cli-profiling) opisano niezbędne kroki. Możemy także korzystając z [instrukcji instalacji](https://blackfire.io/docs/up-and-running/installation?action=install&mode=full&location=local&os=manual&language=php&agent=5fdd5ccf-b9eb-49a1-b965-3c6d9370815f) pobrać bezpośrednio klienta CLI.

Mając zdefiniowany kontener `blackfire`  w docker-compose to możemy skorzystać z poniższego polecenia do uruchomienia profilera:
`docker-compose run --rm --no-deps -v./body.json:/tmp/body.json blackfire blackfire --samples 10 curl -X POST -H'Host: service.lvh.me' -H "Content-Type: application/json" -d @/tmp/body.json http://HTTPD_SERVICE_NAME/path/to/endpoint`

### Troubleshooting

Kiedy korzystamy z rozszerzenia Blackfire w przeglądarce, do strony dołączany jest iframe Blackfire. Jeśli na stronie zdefiniowaliśmy `Content Security Policy` to iframe może zostać zablokowany. W takim przypadku musimy zadeklarować domenę `blackfire.io` jako zaufaną - `Content-Security-Policy: frame-src 'self' blackfire.io`.

### Asserts

Instalując pakiet `blackfire/php-sdk` możemy utworzyć test PHPUnit, w który wykorzystamy metryki `blackfire` do badania wydajności kodu. Tak jak przy instalacji klienta CLI, musimy dokonać konfiguracji. Ustawić odpowiednie zmienne środowiskowe lub utworzyć plik konfiguracyjny w katalogu domowym.

W przypadku frameworka Symfony nasz test powinien dziedziczyć po klasie `Symfony\Bundle\FrameworkBundle\Test\WebTestCase`. Dzięki temu uzyskujemy dostęp do metody statycznej `createClient`. Musimy do testu dołączyć trait `Blackfire\Bridge\PhpUnit\TestCaseTrait`. Następnie możemy już utworzyć metodę testującą.

```
/**
 * @group blackfire
 * @requires extension blackfire
 */
public function testGetTaskBlackfireSqlQueries(): void
{
    //wczytywanie testowych danych, tworzenie client

    $blackfireConfig = (new Configuration())
        ->assert('metrics.sql.count < 2');
    $this->assertBlackfire($blackfireConfig, function() use ($client, $task) {
        $client->request('GET', sprintf('/api/tasks/%d', $task->getId()), [], [], ['HTTP_ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json']);
    });
}
```

Adnotacja `group` umożliwiamy wywołanie (lub wykluczenie) testów blackfire, które trwają dłużej niż testy jednostkowe - `./bin/phpunit --group blackfire`.

Adnotacja `requires` pomija test, jeśli rozszerzenie `blackfire` nie jest dostępne. W przypadku, gdy mamy zainstalowane rozszerzenie, ale ciągle nasz test ma status "skipped" to wywołując phpunit dodajemy parametr `-v`. Wtedy otrzymamy komunikat z błędem.

```
1) App\Tests\Controller\TaskControllerTest::testGetTaskBlackfireSqlQueries
401:  while calling GET https://blackfire.io/api/v1/collab-tokens [context: NULL]
```
