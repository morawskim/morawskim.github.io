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

## User-Defined Type Guards
W TypeScript nie możemy używac operatora `instanceof` do sprawdzenia, czy objekt implementuje interfejs.
Operator `instanceof` sprawdza tylko typ konstruktora funkcji. Musimy skorzystać z tzw. User-Defined Type Guards - https://www.typescriptlang.org/docs/handbook/advanced-types.html#user-defined-type-guards

```
export function isRootControlErrorStateMatcher(errorStateMatcher: ErrorStateMatcher): errorStateMatcher is RootControlErrorStateMatcher {
    const matcher: RootControlErrorStateMatcher = errorStateMatcher as RootControlErrorStateMatcher;
    return typeof matcher.setRootControl === 'function' && typeof matcher.getRootControl === 'function';
}
```

Type guards są wykorzystywane wraz z deklarowaniem zmiennej o typie `unknown`.
Różnica między `any` a `unknown` polega na tym, że ta pierwsza wyłącza sprawdzanie typów.
W przypadku typu `unknown` musimy korzystać z operatora `typeof` lub type guards.

```
const b: unknown = {a: 'b'};
console.log(b.a); // błąd kompilacji Property 'a' does not exist on type 'unknown'.
```

## Enum type checking

Deklarujemy nasz typ wyliczeniowy `Roles`.

```
export enum Roles {
    ROLE_ADMIN = 'ROLE_ADMIN',
    ROLE_SUPER_ADMIN = 'ROLE_SUPER_ADMIN',
    ROLE_USER = 'ROLE_USER',
}
```
Następnie definiujemy klasę lub interfejs, gdzie mamy właściwość `roles` typu `Roles[]`.

```
export default interface User {
    id: number
    roles: Roles[]
}
```

Finalnie możemy sprawdzić, czy użytkownik posiada wymaganą rolę tworząc metodę/funkcję
```
export function isSuperAdmin(user: User) {
    return user.roles.indexOf(Roles.ROLE_SUPER_ADMIN) > -1;
}
```
