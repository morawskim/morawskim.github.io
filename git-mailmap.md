# git .mailmap

W projekcie `ssorder` robiłem podsumowanie kto ile zrobił komitów.
Wywołałam polecenie `git shortlog -se`, aby zobaczyć autorów.

```
4 Marcin Morawski <marcin.morawski@XXXXXXXXXX>
129 Marcin Morawski <marcin@morawskim.pl>
18 Michal Zoltowski <michal.zoltowski@XXXXXXX>
5 Tomasz Malkowski <tomasz.malkowski@XXXXXXXX>
1 stasiu20 <michalXXXXXXXXXXXX@gmail.com>
```

Jak widać możemy zdefiniować kilka aliasów.
Pierwszy alias jest dla mnie - Marcin Morawski. Komitowałem zmiany za pomocą dwóch różnych adresów email
W podsumowaniu chcę, aby te dwa adresy email przynależały do jednej osoby.
Tworzymy więc plik `.mailmap` i wiersz `Marcin Morawski <marcin@morawskim.pl> <marcin.morawski@XXXXXXX>`
Dzięki temu, dwa wpisy zostaną połączone w jeden i zostanie użyty prywatny adres email (kolejność maili ma znaczenie).

Konto stasiu20 chcę połączyć z użytkownikiem `Michal Zoltowski`.
W tym przypadku musimy utworzyć alias zarówno na nazwę użytkownika, jak i adres email.
Wiersz dla `mailmap` będzie więc wyglądał następująco: `Michal Zoltowski <michal.zoltowski@XXXXXX> stasiu20 <michalXXXXXX@gmail.com>`.

Po wprowadzeniu tych zmian po ponownym wywołaniu polecenia `git shortlog -se` otrzymuje wynik z połączonymi kontami:
```
133 Marcin Morawski <marcin@morawskim.pl>
19 Michal Zoltowski <michal.zoltowski@XXXXXXX>
5 Tomasz Malkowski <tomasz.malkowski@XXXXXXX>
```

[https://blog.developer.atlassian.com/aliasing-authors-in-git/](https://blog.developer.atlassian.com/aliasing-authors-in-git/)

