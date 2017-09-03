Vim - odczyt z stdin
====================

Jeśli chcemy przekazać wyjście jakiegoś polecenia do edytora vim możemy to zrobić w poniższy sposób:

``` bash
ls -la | vim -
```

Jeśli już mamy uruchomiony edytor to możesz w miejsce wskazanym przez kurs wkleić wyjście komendy. Wpierw musimy wejść w tryb "Normal". Następnie wywołujemy polecenie:

```
:read !date
```

Spowoduje to wstawienie obecnej daty w miejscu położenia kursora.