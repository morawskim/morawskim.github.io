# composer vendor patches

Podczas pracy nad projektem napotkałem problem związany z błędem typu deprecated, wynikającym z korzystania z biblioteki,
która nie była aktualizowana od kilku lat. Pomimo istnienia otwartych pull requestów zawierających poprawki eliminujące te ostrzeżenia
oraz dodające wsparcie dla nowszych wersji, zmiany te nie zostały zmergowane do głównej gałęzi projektu.

Rozważałem migrację do innej biblioteki, jednak biorąc pod uwagę, że biblioteka była wykorzystywana do generowania plików .docx,
a jakiekolwiek nieprzewidziane zmiany mogłyby wpłynąć na wynikowy dokument, nie chciałem ryzykować potencjalnych problemów.

Zamiast tego zdecydowałem się na użycie pluginu [cweagans/composer-patches](https://github.com/cweagans/composer-patches), który umożliwia nakładanie własnych poprawek na zewnętrzne zależności.
Wprowadziłem więc drobne modyfikacje w kodzie biblioteki i zastosowaliśmy je jako patch, zapewniając stabilność działania aplikacji przy jednoczesnym usunięciu ostrzeżeń deprecated.

Instalujemy pakiet `cweagans/composer-patches`: - `composer require cweagans/composer-patches`

Instalujemy narzędzie do generowania patchy `symplify/vendor-patches`: `composer require symplify/vendor-patches --dev`

Tworzymy kopię modyfikowanego pliku: `cp vendor/library/topatch/src/file.php vendor/library/topatch/src/file.php.old`

Modyfikujemy oryginalny plik: `vim vendor/library/topatch/src/file.php`

Generujemy łatkę: `vendor/bin/vendor-patches generate`

W katalogu `patches/` narzędzie powinno utworzyć plik `.patch` zawierający zmiany.
Od tej pory wywoływanie polecenia `composer install` będzie automatycznie aplikowało łatkę na kod w katalogu vendor.

[How to Patch a Package in Vendor, Yet Allow its Updates](https://tomasvotruba.com/blog/2020/07/02/how-to-patch-package-in-vendor-yet-allow-its-updates/)
