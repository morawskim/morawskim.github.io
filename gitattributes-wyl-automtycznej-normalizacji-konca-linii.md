# gitattributes - wył automatycznej normalizacji końca linii

Korzystam z globalnego pliku `.gitattributes`.
Wymusza on automatyczną normalizację znaków końca linii dla plików php.
Jednak podczas pracy nad jednym z projektów, nie mogłem wysłać zmian z zmienionymi znakami końca linii.
Można to zrobić tworząc kolejny plik `.gitattributes`, który nadpisze globalne ustawienie.

Do pliku `.gitattributes` dodajemy linię:
```
*.php -text
```

Po tej zmianie git nie zmodyfikuje znaków końca linii.
```
git check-attr --all -- ./library/FormHelper.php
./library/FormHelper.php: diff: php
./library/FormHelper.php: text: set

```

```
git check-attr --all -- ./controllers/BuyController.php
./controllers/BuyController.php: diff: php
./controllers/BuyController.php: text: unset
```
