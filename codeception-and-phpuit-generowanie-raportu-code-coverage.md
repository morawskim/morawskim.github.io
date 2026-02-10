# Codeception & PHPUit - generowanie raportu code coverage

W projekcie mieliśmy legacy system, który wykorzystywał Codeception do uruchamiania testów jednostkowych.
Testy te były testami PHPUnit.

Celem było wygenerowanie raportu pokrycia kodu testami (code coverage) - `XDEBUG_MODE=coverage vendor/bin/codecept run unit -c common ./common/tests/unit/ --xml  --coverage-xml`.
Problem polegał na tym, że w wygenerowanym raporcie pojawiało się również pokrycie klas z katalogu `vendor`,
czego nie chcieliśmy.

Źródłem problemu okazała się konfiguracja Codeception.

Poprawna konfiguracja, umieszczona w pliku `codeception.yml`, wygląda następująco:

```
# ...
coverage:
    enabled: true
    include:
        - "/*"
    exclude:
        - tests/*
        - views/*
        - runtime/*
        - config/*
```

## Mechanizm generowania raportu coverage

Punktem wejścia do generowania raportu jest klasa: `\SebastianBergmann\CodeCoverage\CodeCoverage`.
Do jej konstruktora przekazywana jest instancja: `\SebastianBergmann\CodeCoverage\Filter` w parametrze `$filter`.

Klasa Filter odpowiada za decyzję, które pliki są uwzględniane w raporcie coverage, a które są z niego wykluczane.

Podczas analizy kodu zwróciłem uwagę na prywatną metodę `applyFilter` klasy `CodeCoverage`,
która wykorzystuje przekazaną instancję Filter do usunięcia zebranych danych pokrycia dla plików.


Po uruchomieniu debuggera okazało się, że instancja CodeCoverage
jest tworzona w metodzie: `\Codeception\Coverage\PhpCodeCoverageFactory::build()`.

Metoda ta jest wywoływana przez klasę: `\Codeception\Coverage\Subscriber\Printer`.
W tym miejscu Codeception tworzy własną instancję `\Codeception\Coverage\Filter`, która jest wrapperem dla klasy Filter pakietu phpunit.

Analizując metodę `whiteList()` tej klasy, doszedłem do kluczowego wniosku.

Konfiguracja `exclude` nie działa jako globalny filtr.
Elementy podane w exclude jedynie usuwają wpisy,
które wcześniej zostały dodane przez include.

Jeżeli konfiguracja zawierała wyłącznie sekcję `exclude`,
bez jawnie zdefiniowanej listy plików/katalogów w include,
to wszystkie pliki (w tym vendor/) nadal trafiały do raportu coverage.

Z tego wynika, że kluczowe jest skonfigurowanie sekcji include
(jako "białej listy" plików dopuszczonych do raportu).
W takiej konfiguracji pliki spoza include — w tym katalog vendor -
nie są w ogóle brane pod uwagę, a jawne wykluczanie vendor staje się zbędne.
