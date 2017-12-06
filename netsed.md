# netsed

Za pomocą programu `netsed` można utworzyć prosty serwer proxy. Dzięki temu, bez modyfikacji pliku hosts, można udostępnić aplikację web. Poniższe polecenie zmienia nazwę nagłówka `Accept-Encoding`, aby serwer HTTP nie zwrócił nam skompresowanej strony. Bez tego podstawianie adresów url by nie działało.

```
netsed tcp 8080 127.0.0.1 80 's/Accept-Encoding/X-Accept-Encoding/' 's/work.morawskim.pl/toh.test/o' s/toh.test/work.morawskim.pl/i
```
