# TypeScript TS7016 Could not find a declaration file for module

Tworząc projekt przez narzędzie `create-react-app` (`npx create-react-app <PROJECT> --template typescript`) mamy utworzoną strukturę projektu z konfiguracją webpack i typescript. Domyślnie w pliku `tsconfig.json` mamy włączony tryb `strict`. Zgodnie z dokumentacją (https://www.typescriptlang.org/docs/handbook/compiler-options.html) opcja ta włącza następujące flagi:
>Enable all strict type checking options.
>Enabling --strict enables --noImplicitAny, --noImplicitThis, --alwaysStrict, --strictBindCallApply, --strictNullChecks, --strictFunctionTypes and --strictPropertyInitialization.

W przypadku, kiedy do projektu dodamy moduł, który nie zawiera definicji, dostaniemy błąd:
```
TS7016: Could not find a declaration file for module 'react-with-styles-interface-aphrodite'. '/home/marcin/projekty/html5-examples/react.js/react-dates/node_modules/react-with-styles-interface-aphrodite/lib/aphroditeInterface.js' implicitly has an 'any' type.   Try `npm install @types/react-with-styles-interface-aphrodite` if it exists or add a new declaration (.d.ts) file containing `declare module 'react-with-styles-interface-aphrodite';`
```

Możemy ustawić w pliku `tsconfig.json` opcję `noImplicitAny` na wartość `false`.
Albo zignorować błąd dodając adnotację `// @ts-ignore` nad importem modułu:
```
// @ts-ignore
import aphroditeInterface from 'react-with-styles-interface-aphrodite';
```

Jednak lepszym rozwiązanie jest utworzenie pliku definicji i jawne zadeklarowanie modułu.
Robimy to tworząc plik `index.d.ts` w głównym katalogu projektu.
Następnie do nowo utworzonego pliku dopisujemy deklarację brakującego modułu - `declare module 'react-with-styles-interface-aphrodite';`.
W pliku `tsconfig.json` w kluczu `include` dopisujemy `index.d.ts`. Nasz plik tsconfig.json` powinien wyglądać mniej więcej tak:

``` javascript
{
  "compilerOptions": {
....
  },
  "include": [
    "src",
    "index.d.ts"
  ]
}
```
