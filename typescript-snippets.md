# typescript - snippets

## Reprezentacja typu funkcji konstruktora
```
export interface Type<T> extends Function {
    new (...args: any[]): T;
}
```

Dzięki takiej deklaracji typu `Type` możemy utworzyć mapę. Gdzie klucz to łańcuch znakowy.
A wartość nazwa funkcji konstruktora, która implementuje wybrany interfejs `T`.

## Korzystanie z typu wyliczeniowego w szablonie angulara
Musimy utworzyć publiczny zmienną i przypisać do niej typ wyliczeniowy.
Dzięki słowu kluczowemu `typeof`, w szablonie będzie działać podpowiadanie wartości typu wyliczeniowego.

```
public refundValueTypeEnum: typeof RefundValueTypeEnum = RefundValueTypeEnum;
```
