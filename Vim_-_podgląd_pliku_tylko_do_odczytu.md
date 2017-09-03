Vim - podgląd pliku tylko do odczytu
====================================

Otwieranie pliku poprzez program less ma jedną wadę. Ten program nie oferuje podświetlania składni pliku. Choć istnieją wtyczki, które dodają taką opcję do niektórych typów plików, to nie może to się równać z możliwościami edytora vim. Na szczęście edytor vim, posiada tryb tylko do odczytu. Dzięki temu jesteśmy chronieni przed przypadkowym zapisem do pliku. Dodatkowo nie jest tworzony żaden tymczasowy plik. Możemy go wywołać poprzez uruchomienie programu view.

``` bash
view ~/rpmbuild/SPECS/php5-redis.spec
#inny sposób wywoływania
vim -R ~/rpmbuild/SPECS/php5-redis.spec
```