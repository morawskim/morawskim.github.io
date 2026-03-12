# jest

## node 20 i "Cannot use import statement outside a module"

Podczas uruchamiania testów za pomocą polecenia `npx jest` pojawił się błąd:

```
 FAIL  src/__tests__/MyTest.js
  ● Test suite failed to run

    Jest encountered an unexpected token

    Jest failed to parse a file. This happens e.g. when your code or its dependencies use non-standard JavaScript syntax, or when Jest is not configured to support such syntax.

    Out of the box Jest supports Babel, which will be used to transform your files into valid JS based on your Babel configuration.

    By default "node_modules" folder is ignored by transformers.

    Here's what you can do:
     • If you are trying to use ECMAScript Modules, see https://jestjs.io/docs/ecmascript-modules for how to enable it.
     • If you are trying to use TypeScript, see https://jestjs.io/docs/getting-started#using-typescript
     • To have some of your "node_modules" files transformed, you can specify a custom "transformIgnorePatterns" in your config.
     • If you need a custom transformation specify a "transform" option in your config.
     • If you simply want to mock your non-JS modules (e.g. binary assets) you can stub them out with the "moduleNameMapper" config option.

    You'll find more details and examples of these config options in the docs:
    ......
    ......

    SyntaxError: Cannot use import statement outside a module
```

Błąd `SyntaxError: Cannot use import statement outside a module` występuje przy korzystaniu z Node.js w wersji 20,
jeśli próbujemy uruchomić testy z użyciem ECMAScript Modules (ESM).

Aby rozwiązać problem, należy ustawić zmienną środowiskową `NODE_OPTIONS`, dodając flagę `--experimental-vm-modules`.

Dzięki temu testy uruchamiają się poprawnie.

## TypeScript

W projekcie chciałem napisać testy dla funkcji liczącej, czy faktura przekracza wartość 15 000 zł brutto (mechanizm podzielonej płatności).

Funkcję tę napisałem w TypeScript.
Przy próbie uruchomienia testów otrzymałem błąd:

```
SyntaxError: /var/www/XXX/src/invoice/Utils.ts: Unexpected token, expected "," (6:41)

      4 |
      5 | export class Utils {
    > 6 |     static convertDateToStringOrNull(date: Date|null) {
        |                                          ^
      7 |         return date ? dayjs(date).format('YYYY-MM-DD') : null;
      8 |     }
      9 |
```

Do obsługi TypeScript zainstalowałem pakiet ts-jest: ` npm i --save-dev ts-jest`

Następnie wygenerowałem przykładowy plik konfiguracyjny: `npx ts-jest config:init`

Domyślnie wyglądał on tak:

```
const { createDefaultPreset } = require("ts-jest");

const tsJestTransformCfg = createDefaultPreset().transform;

/** @type {import("jest").Config} **/
export default {
  testEnvironment: "node",
  transform: {
    ...tsJestTransformCfg,
  },
};
```

Jednak otrzymywałem błąd.

> ReferenceError: require is not defined in ES module scope, you can use import instead
This file is being treated as an ES module because it has a '.js' file extension and '/var/www/XXX/package.json' contains "type": "module". To treat it as a CommonJS script, rename it to use the '.cjs' file extension.

W package.json miałem:

```
{
  "type": "module",
.....
```

Przy takiej konfiguracji, Node traktuje wszystkie pliki .js jako ES Modules, a w ESM require nie działa.
Musiałem więc zastąpić linię require importem: `import { createDefaultPreset } from 'ts-jest';`

Po tym przy uruchamianiu testu pojawił się nowy błąd:

```
Module '"/var/www/XXX/node_modules/dayjs/index"' can only be default-imported using the 'esModuleInterop' flag 1 import dayjs from "dayjs";
~~~~~ node_modules/dayjs/index.d.ts:3:1 3 export = dayjs;
~~~~~~~~~~~~~~~ This module is declared with 'export =', and can only be used with a default import when using the 'esModuleInterop' flag.

````
Postanowiłem więc ustawić parametr `esModuleInterop` bezpośrednio w konfiguracji `ts-jest`, zamiast tworzyć osobny plik `tsconfig.json`:

`const tsJestTransformCfg = createDefaultPreset({tsconfig: {esModuleInterop: true}}).transform;`

Finalnie mój plik konfiguracyjny `jest.config.js` wyglądał tak:

```
// const { createDefaultPreset } = require("ts-jest");
import { createDefaultPreset } from 'ts-jest';
const tsJestTransformCfg = createDefaultPreset({tsconfig: {esModuleInterop: true}}).transform;

/** @type {import("jest").Config} **/
export default {
  testEnvironment: "node",
  transform: {
    ...tsJestTransformCfg,
  },
};
```
