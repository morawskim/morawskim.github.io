Column - wyrównywanie kolumn
============================

Często pracując w powłoce, chcemy wyrównać kolumny wyjścia jakiegoś programy, aby rezultat był czytelniejszy. Do tego służy program column.

``` bash
echo -e "aaaaaaa bbbbbbbbb e\ncccc dddddddddddddddddddddddd" | column -t

#wynik polecenia
aaaaaaa  bbbbbbbbb                 e
cccc     dddddddddddddddddddddddd
```

Domyślnie separatorem jest spacja. Lepiej zastosować znak tabulatora, który jest znacznie rzadziej wykorzystywany. Musimy dodać parametr "s". Dodatkowo, aby w powłoce Bash wprowadzić znak tabulatora musimy wpierw wcisnąć klawisze \[ctrl\] + \[v\] i dopiero potem \[tab\].

``` bash
cat test | column -t -s '      '
ab c        d e     ef ff
zxc zxczxc  222 22  ffff
ff ff       5 55    v v
```

Podobnie jeśli otworzymy taki plik w edytorze vim, możemy całą zawartość pliku przefiltrować przez program column. W trybie poleceń wpisujemy i zatwierdzamy:

``` vim
%!column -t -s'^I'
```

W vim'ie jeśli chcemy wprowadzić znak tabulatora to wciskamy \[ctrl\] + \[v\] a następnie klawisz \[tab\].