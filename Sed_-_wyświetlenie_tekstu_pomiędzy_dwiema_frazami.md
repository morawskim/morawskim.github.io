Sed - wyświetlenie tekstu pomiędzy dwiema frazami
=================================================

Jeśli logujemy do pliku wszystkie wywołania API, to może się zdarzyć że będziemy chcieli podejrzeć przykładowe wywołanie. Program sed pozwala nam wyświetlić linie, które znajdują się pomiędzy dwiema frazami. Poniższy przykład wyświetla wszystkie wywołania metody getProductParam.

``` bash
sed -n '/getProductParam>/,/getProductParam>/p' /path/to/file
```