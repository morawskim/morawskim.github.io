# TypeScript - Non-Null Assertion Operator !

Operator ` Non-Null Assertion Operator` służy do stwierdzenia, że jego argument nie może mieć wartości `NULL` ani `undefined` w czasie wykonywania. Najczęściej jest wykorzystywany kiedy mamy włączoną opcję  kompilatora `--strictNullChecks`.

Tego operatora możemy użyć, gdy kompilator nie jest w stanie sprawdzić, czy zmienna nie może być pusta/niezdefiniowana.


Przykładowy błąd kompilacji:
```
Object is possibly 'null'.

8     return str.substring(0, str!.length / 2);
             ~~~
```

Rozwiazaniem jest użycie operatora `!`
`return str!.substring(0, str!.length / 2);`
