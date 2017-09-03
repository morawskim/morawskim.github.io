Find - exec i potok
===================

Nie możemy użyć w parametrze exec symbolu potoku. Musimy odpalić powłokę sh (lub inną) w exec i przekazać jej polecenie które chcemy wykonać. Tak jak poniżej.

``` bash
find -iname 'EXAMPLE.pl.log*' -exec sh -c "grep '/admin/nota/cyklRozliczeniowy' {} | grep -Po 'POST /admin/nota/cyklRozliczeniowy/\d+/\d+(/\d+)?' | sort | uniq -d " \; -print
./Feb-2017.2/EXAMPLE.pl.log.1
./Mar-2017.5/EXAMPLE.pl.log.1
./Mar-2017.7/EXAMPLE.pl.log.1
./Mar-2017.6/EXAMPLE.pl.log.1
./Mar-2017.1/EXAMPLE.pl.log.1
POST /admin/nota/cyklRozliczeniowy/32726/1
./Mar-2017.4/EXAMPLE.pl.log.1
./Feb-2017.4/EXAMPLE.pl.log.1
POST /admin/nota/cyklRozliczeniowy/31804/4
./Mar-2017.8/EXAMPLE.pl.log.1
./Mar-2017.3/EXAMPLE.pl.log.1
./Feb-2017/EXAMPLE.pl.log.1
./Mar-2017.2/EXAMPLE.pl.log.1
./Feb-2017.3/EXAMPLE.pl.log.1
./Feb-2017.1/EXAMPLE.pl.log.1
./Mar-2017/EXAMPLE.pl.log.1
```