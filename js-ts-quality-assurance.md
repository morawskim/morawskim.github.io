# JS/TS Quality Assurance

## type-coverage

`type-coverage` to narzędzie do sprawdzania pokrycia typów. Za jego pomocą ograniczamy przedostanie się typu `any` w kodzie źródłowym. Instalujemy pakiet `type-coverage`, a następnie wywołujemy polecenie `type-coverage`. Na wyjściu dostaniemy wynik np. `3160 / 3212 98.38%`. Dodając flagę `--details` zobaczymy miejsca w kodzie, gdzie nie stosujemy typowania. W środowisku CI przyda się flaga `--at-least`, która spowoduje zwrócenie błędu, jeśli współczynnik pokrycia jest mniejszy niż podana wartość.

[type-coverage](https://github.com/plantain-00/type-coverage)
