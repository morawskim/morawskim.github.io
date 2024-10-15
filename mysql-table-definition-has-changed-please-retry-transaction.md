# MySQL - Table definition has changed, please retry transaction

W projekcie obliczaliśmy dane offline raz dziennie. Stare dane kasowałem korzystając z instrukcji `TRUNCATE`.
Gdy ktoś próbował pobrać dane, gdy instrukcja TRUNCATE się wykonała rzucany był bląd:
> Table definition has changed, please retry transaction

Rozwiązaniem było zmigrowanie na instrukcję `DELETE` zamiast `TRNCATE`.

[MySQL Bugs: #98677: "Table definition has changed, please retry transaction" when trying to select](https://bugs.mysql.com/bug.php?id=98677)
