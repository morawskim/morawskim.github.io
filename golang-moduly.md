# Golang moduły

Alex Rios, _System Programming Essentials with Go. System calls, networking, efficiency, and security practices with practical projects in Golang_, Packt Publishing

Gdy moduł osiąga wersję 2 lub wyższą, główny numer wersji (major version) musi zostać uwzględniony w ścieżce modułu.
Na przykład wersja 2 modułu github.com/foo/bar jest identyfikowana jako github.com/foo/bar/v2.


Skonfiguruj Git oraz środowisko Go, aby umożliwić bezproblemową pracę z prywatnymi modułami Go przechowywanymi na GitHubie.
Utwórz plik .gitconfig, a następnie dodaj do niego następującą konfigurację:

```
[url "ssh://git@github.com/"]
    insteadOf = https://github.com/
```

Te wpisy informują Git, aby automatycznie korzystał z protokołu SSH za każdym razem, gdy napotka adres URL GitHuba.

## GOPRIVATE

Zmienna środowiskowa GOPRIVATE informuje narzędzia Go, aby nie próbowały pobierać wskazanych modułów z publicznego repozytorium proxy modułów Go.
Zamiast tego moduły są pobierane bezpośrednio z ich źródła, co jest niezbędne w przypadku prywatnych repozytoriów.

Aby skonfigurować GOPRIVATE dla pojedynczego prywatnego repozytorium, wykonaj w terminalu następujące polecenie, zastępując <org> i <project> nazwą organizacji GitHub oraz nazwą repozytorium:

`go env -w GOPRIVATE="github.com/<org>/<project>"`

Alternatywnie możesz skonfigurować GOPRIVATE dla wszystkich repozytoriów należących do danej organizacji:
`go env -w GOPRIVATE="github.com/<org>/*"`
