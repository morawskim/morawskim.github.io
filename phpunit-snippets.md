# phpunit

## Pomiń testy w przypadku braku rozszerzenia PHP

W projekcie `yii2-utils` utworzyłem klasę `\mmo\yii2\actions\SlugGenerator`, która generuje nam slug.
Wykorzystuje ona klasę `\yii\helpers\Inflector`, która korzysta z rozszerzenia `intl`.
Podczas uruchomienia testów w środowisku, gdzie nie ma tego rozszerzenia otrzymujemy negatywny wynik testów.

`phpunit` obsługuje pomijanie testów, jeśli warunki nie są spełnione. Jednym z warunków może być zainstalowane rozszerzenie PHP. Dodając adontację `@requires extension intl` do testu jednostkowego ograniczyłem wykonywanie testów.
Nie otrzymuje fałszywych informacji o niepowodzeniu testów wynikających z braku rozszerzenia `intl`.
O pozostałych warunkach wstępnych, które ograniczają wykonywanie testów można przeczytać w [dokumentacji](https://phpunit.readthedocs.io/en/8.5/incomplete-and-skipped-tests.html#skipping-tests-using-requires).



