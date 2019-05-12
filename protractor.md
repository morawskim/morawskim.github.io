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

https://www.protractortest.org/#/debugging

## onPrepare

W właściwości `onPrepare` konfiguracji protractora możemy zwrócić promise. W takim przypadku protractor będzie czekał na spełnienie promise, przed wykonaniem testów. Często wykorzystuje się tą funkcjonalność do zalogowania użytkownika do systemu. `onPrepare` może być zarówno funkcją jak i nazwą pliku. W przypadku pliku, protractor wczyta  i wykona zawartość pliku.

Przykład z logowaniem użytkownika
https://github.com/angular/protractor/blob/master/spec/withLoginConf.js
