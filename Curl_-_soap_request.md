Curl - soap request
===================

Dokument SOAP możemy wysłać przez curl. Musimy ustawić odpowiednie nagłówki (np. Content-Type). Przekazujemy do curla ścieżkę do dokumentu XML.

Przykładowe wywołanie:

``` bash
curl --header "Content-Type: text/xml;charset=UTF-8" --data @/home/marcin/.PhpStorm2017.1/config/scratches/scratch_15.xml 'ws.dpd-city.dev/?ws=1
```