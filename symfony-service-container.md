# Symfony Service Container

## Autowiring i typy abstrakcyjne

W projekcie zainstalowałem pakiet `lcobucci/clock`, aby pobierać informacje o aktualnej dacie z pośrednika i w efekcie pominąć wywołania systemowe. Pakiet ten dostarcza dwie implementacje. Do testów służy implementacja `Lcobucci\Clock\FrozenClock`. Konfigurując Service Container w Symfony chciałem wykorzystać abstrakcyjny typ danych, niż konkretną implementację. Autowire nie działa bezpośrednio z interfejsem. Musimy utworzyć alias usługi. W klasie w konstruktorze dodałem parametr o typie `Lcobucci\Clock\Clock`. W pliku `services.yml` zarejestrowałem usługę `Lcobucci\Clock\SystemClock: ~`. Następnie dla typu abstrakcyjnego utworzyłem alias do konkretnej implementacji `Lcobucci\Clock\Clock: '@Lcobucci\Clock\SystemClock'`. Dzięki temu framework Symfony podczas tworzenie mojej usługi automatycznie wstrzyknął wybraną implementację typu `Lcobucci\Clock\Clock`.

[autowiring and interfaces](https://symfony.com/doc/current/service_container/autowiring.html#working-with-interfaces)
