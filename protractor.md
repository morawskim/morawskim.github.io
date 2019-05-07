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

