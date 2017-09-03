Postfix - podgląd wiadomości zalegającej w kolejce
==================================================

Musimy uzyskać numer identyfikacyjny wiadomości

``` bash
mailq
#wynik polecenia
-Queue ID- --Size-- ----Arrival Time---- -Sender/Recipient-------
E12B244291      337 Thu Jun 25 18:25:28  pi
                                         marcin@dom.example

31463444EB      481 Thu Jun 25 18:25:28  pi@raspberry.local.domain
                                         marcin@dom.example
```

Pierwsza kolumna wyświetla identyfikator wiadomości, który podajemy do jako argument do polecenia postcat.

``` bash
sudo postcat -vq E12B244291
```