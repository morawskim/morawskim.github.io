# Webpack - Module aliasing

W plikach JS importujemy moduły wykorzystując ścieżki relatywne - `
import Utility from '../../utilities/date';`. Nie wyglądają one zbyt ładnie. Dodatkowo generują problem w przypadku przeniesienia pliku w innego miejsce nie korzystając z możliwości refaktoryzacji środowisk programistycznych. Rozwiązaniem jest utworzenie aliasu do modułów aplikacji. W przykładowym projekcie mamy taką strukturę:

```
.
├── node_modules
├── package.json
├── package-lock.json
├── src
│   ├── component
│   ├── model
│   ├── page
    //....
│   └── service

├── tsconfig.json
└── webpack.config.js
```


W pliku `webpack.config.js`  konfigurujemy klucz `resolve.alias`:

```
const path = require('path');

module.exports = {
  //...
  resolve: {
    alias: {
      "@": path.resolve(__dirname, 'src')
    }
  }
  //...
};
```

Jeśli korzystamy z pakietu `@symfony/webpack-encore` to wywołujemy metodę `addAliases`:

```
Encore
    //...
    .addAliases({
        '@': path.resolve(__dirname, 'src')
    })
    //...
```

W obu przypadkach zostanie utworzony alias `@`, który wskazuje na ścieżkę `src`. Teraz wykorzystując nasz alias jesteśmy w stanie zaimportować dowolny moduł wykorzystując ścieżkę absolutną - `import {AppCtxProvider } from '@/context';`
Jeśli korzystamy z TypeScript to korzystając z aliasu otrzymamy błąd `TS2307: Cannot find module '@/context' or its corresponding type declarations.`. Musimy do pliku konfiguracyjnego `tsconfig.json` dodać parametry `baseUrl` i `paths`:

```
{
  "compilerOptions": {
    //...
    "baseUrl": ".",
    "paths": {
      "@/*": ["src/*"]
    }
  }
}
```

W przypadku gdy błąd nie zniknął polecenie `npx tsc --traceResolution` może nam pomóc.

[Webpack resolve.alias](https://webpack.js.org/configuration/resolve/#resolvealias)

[The Right Usage of Aliases in Webpack and TypeScript](https://medium.com/better-programming/the-right-usage-of-aliases-in-webpack-typescript-4418327f47fa)
