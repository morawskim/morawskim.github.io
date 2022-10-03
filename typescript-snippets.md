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

## Generyczna fabryka

```
function factory<T extends MainClass<string>>(id: string, className: Type<T>): T {
  const obj = new className();
  obj.id = id;
  return obj;
}

const a = factory<MainClass<string>>("instance A", MainClass);
const b = factory<ChildClass>("instance b", ChildClass);
```

[Online demo](https://codepen.io/morawskim/pen/wvaxVvG)

## allowSyntheticDefaultImports

Ustawiając opcję kompilatora `allowSyntheticDefaultImports` na wartość true, możemy korzystać z składni domyślnego importu w przypadku gdy wybrany moduł nie posiada domyślnego eksportu. Zamiast `import * as …` możemy pisać `import Foo from 'foo';`.

https://www.typescriptlang.org/docs/handbook/compiler-options.html#compiler-options

## esModuleInterop

Kiedy próbujemy zaimportować moduł CommonJS do modułu ES6 możemy otrzymać błąd podobny do

> TS1259: Module '".../node_modules/@types/express/index"' can only be default-imported using the 'esModuleInterop' flag

Rozwiązanie polega na dodaniu do pliku `tsconfig.json`

```
{
  "compilerOptions": {
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    // ... reszta ustawień
  }
}

```

[Module can only be default-imported using esModuleInterop flag](https://bobbyhadz.com/blog/typescript-module-can-only-be-default-imported-esmoduleinterop)

## Exhaustiveness checking

`Exhaustiveness checking` - kompilator TS poinformuje nas, kiedy nie uwzględniliśmy wszystkich możliwych wartości.

https://2ality.com/2020/02/typescript-exhaustiveness-checks-via-exceptions.html

https://www.typescriptlang.org/docs/handbook/advanced-types.html#discriminated-unions

https://www.typescriptlang.org/docs/handbook/advanced-types.html#exhaustiveness-checking

[Playground Link](https://www.typescriptlang.org/play?#code/JYOwLgpgTgZghgYwgAgMoEcCucooN4BQyyA1qACYBcyARAM5Y4Q0DcRydwAXhNSJgFsARtDYBfAqEixEKAEoQEYOCADmAG3zsyIKrVxKVG5m2IB3YOTAALPoJFRTyaxGCrrYO8NEEJU6PBIyADCwFAImsiExDp6NAhhESbsUHDkwJh0Xg7iBARgAJ4ADiio1nAlyAC8aIy4yAA+yAqGapFNoeGabAQwmCBKwAD2IMhwdHTQYAByEABu0AAUAB5889AAlGsLUFHsNlBDZsggEMcAolCHUIs0AKqnyyVKEOTIQ0IAVoqetMgA1Mhlhtcr1+oMRmNcHBFlk0OUShs9sQ6BYwAhrMhYQA6WJI6LEZAIcYoeh1ZiUdiE5C4MCYKCjOjYzg8ZAAKg4zO4ECcxGJk30PyMmholOpxFp9MZ2Jcbg87M5Fis1l5yAA9Gr+aSEl0KVT1WqJRA6QzkABZOA2bEABQAkgqmal0pl2RyAEyq8gQeCYdSefVGk2jcaTKAzdY3Ogg9gSCR5BAjOhDTTY9RDVSLJgwvCxahk7C4GgAGg43OoAFYxBsQUA)
