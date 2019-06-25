# Protractor

## Wyłączenie trybu WebDriver Control Flow

Wraz z wprowadzeniem funkcjonalności async/await w standardzie es 2017, tryb promise w webdriverjs został oznaczony jako deprecated. Można zawczasu przygotować się do zmian i tworzyć testy e2e zgodnie z nowym flow.
Aby wymusić tworzenie testów w oparciu o async/await, musimy do pliku konfiguracyjnego `protactor` dodać klucz `SELENIUM_PROMISE_MANAGER` i ustawić wartość `false`.

https://www.protractortest.org/#/control-flow
https://github.com/SeleniumHQ/selenium/issues/2969
https://github.com/SeleniumHQ/selenium/wiki/WebDriverJs#moving-to-asyncawait

## Uruchomienie pojedynczego testu e2e

Uruchamianie wszystkich testów e2e może być czasochłonne.
W takim przypadku możemy uruchomić tylko test, nad którym obecnie pracujemy.
Wystarczy wywołać polecenie `protractor --specs='e2e/spec/plik.e2e-spec.ts' --grep="NazwaTestu"`

## Pluginy

Funkcjonalność protractora, możemy rozszerzać przez instalacje pluginów.

| Plugin | Opis |
|---|---|
| protractor-console-plugin | Plugin sprawdza po każdym teście logi przeglądarki pod względem wystąpień ostrzeżeń i błędów. Działa jedynie z przeglądarką chrome. |

## Debugowanie testów (lokalnie)

Jeśli nasze testy nie działają, musimy je debugować. Wraz z implementacją async/await debugowanie testów e2e protractora jest proste. Wywołujemy polecenie `node --inspect-brk node_modules/.bin/protractor <config_file.js>`.
W przeglądarce chrome wchodzimy na adres `chrome://inspect/#devices` i klikamy w link `inspect` przy naszym uruchomionym skrypcie protractora. Otwarte zostanie nowe okno chrome-devtools. Wykonywanie testów zostało wstrzymane. Ustawiamy breakpointy w wymaganym pliku spec i zezwalamy na dalsze wykonywanie skryptu.

Podczas debugowania testu, możemy otrzymać następujący błąd - `Error: Timeout - Async callback was not invoked within timeout specified by jasmine.DEFAULT_TIMEOUT_INTERVAL`.
W takim przypadku, możemy jedynie zwiększyć w konfiguracji protractora czas oczekiwania na wykonanie testu:
```
jasmineNodeOpts: {
    defaultTimeoutInterval: 90000
},
```

https://www.protractortest.org/#/debugging

## onPrepare

W właściwości `onPrepare` konfiguracji protractora możemy zwrócić promise. W takim przypadku protractor będzie czekał na spełnienie promise, przed wykonaniem testów. Często wykorzystuje się tą funkcjonalność do zalogowania użytkownika do systemu. `onPrepare` może być zarówno funkcją jak i nazwą pliku. W przypadku pliku, protractor wczyta  i wykona zawartość pliku.

Przykład z logowaniem użytkownika
https://github.com/angular/protractor/blob/master/spec/withLoginConf.js

## Uruchamianie testów e2e na kontenerze docker

Do odpalenia testów na kontenerze dockera potrzebujemy obrazu z node i przeglądarką chrome - np. `morawskim/node10-google-chrome:74.0.3729.131`. Ten obraz zawiera także sterownik chromedriver. Dzięki temu, nie potrzebujemy uruchamiać serwera selenium do przeprowadzenia testów e2e.

W pliku konfiguracyjnym protractor ustawiamy następujące właściwości:


```
    directConnect: true,
    capabilities: {
        'browserName': 'chrome',
        'chromeOptions': {
            'args': [
                '--no-sandbox',
                '--headless',
                '--window-size=1920,1080',
                '--disable-dev-shm-usage'
            ]
        },
    },
    chromeDriver: '/usr/local/bin/chromedriver',
```

Opcja `directConnect` jest wspierana tylko przez sterownik chrome i firefox. Za jej pomocą nie musimy łączyć się z serwerem selenium do przeprowadzenia testów e2e. `chromeDriver` to ścieżka to pliku z sterownikiem dla przeglądarki chrome. Testy odpalamy w kontenerze, który nie ma środowiska graficznego, dlatego musimy ustawić niezbędne argumenty startowe do uruchomienia chrome.

Przykładowa konfiguracja kontenera w `docker-compose.yml` może wyglądać następująco:
```
e2e:
        image: morawskim/node10-google-chrome:74.0.3729.131
        command: npm run e2e
        volumes:
            - ./:/app
        working_dir: /app
        depends_on:
            - traefik
        links:
            - traefik
        external_links:
            - traefik:ssorder.lvh.me
```

Gdzie komenda `npm run e2e` to alias dla `protractor protractor.conf.js` zapisany w pliku `package.json` (sekcja scripts).

## Zdalne debugowanie testów e2e (uruchomionych na kontenerze docker'a)

Mając konfigurację przygotowaną do uruchamiania testów e2e na kontenerze, wystarczy dodać dwa argumenty do opcji startowych przeglądarki chrome. `--remote-debugging-address=0.0.0.0` spowoduje nasłuchiwanie na połączenia, na wszystkich interfejsach sieciowych kontenera. `--remote-debugging-port=9222` ustawia domyślny port, na którym przeglądarka chrome będzie oczekiwała na połączenia. W `docker-compose.yml` musimy przekierować ruch na ten port. Po w prowadzeniu tych zmian, wywołujemy polecenie `node --inspect-brk=0.0.0.0:9229 ./node_modules/.bin/protractor protractor.conf.js` na kontenerze. W IDE np. PHPStorm musimy utworzyć nową konfigurację Run/Debug "Attach do node.js/chrome". Należy poprawnie ustawić mapowanie ścieżek między lokalnym systemem plików, a zdalnym (na kontenerze).

## Akceptowanie certyfikatów SSL

W przypadku przeglądarki firefox w konfiguracji protractora obiekt `capabilities` powinien zawierać właściwość `acceptInsecureCerts` z wartością `true`.

```
capabilities: {
    'browserName': 'firefox',
     acceptInsecureCerts: true
}

W przypadku przeglądarki chrome, nie miałem problemu z niezaufanymi certyfikatami SSL. Jednak zalecana jest taka konfiguracja:

```
capabilities: {
  browserName: 'chrome',
  chromeOptions: {
    args: ['--ignore-certificate-errors']
  }
}
```

## Cookbooks

[Przykłady użycia Protractora w różnych typowych scenariuszach.](https://github.com/angular/protractor-cookbook)
