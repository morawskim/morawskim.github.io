# WebExtensions API

Rozszerzenie w przeglądarce buduje się wykorzystując standardowe technologie webowe - HTML, CSS i JavaScript. W skryptach JavaScript mamy dodatkowo dostęp do [specjalnego API przeglądarki](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/API).

Zakładamy nowy projekt i instalujemy pakiety `webpack webpack-cli typescript ts-loader @types/webextension-polyfill copy-webpack-plugin webextension-polyfill`.
Dodatkowo możemy zainstalować pakiet `web-ext` i `web-ext-plugin` (dla webpack). Ułatwia on budowanie wtyczki i jej przetestowanie w przeglądarce (oddzielny profil z gotową wtyczką do testów).

Tworzymy plik z konfiguracją dla TypeScipt `tsconfig.json`:

```
{
  "compilerOptions": {
    "strict": true,
    "module": "commonjs",
    "target": "es6",
    "esModuleInterop": true,
    "outDir": "dist/",
    "noEmitOnError": true,
  }
}
```

A także plik `webpack.config.mjs` z konfiguracją webpack:

```
import WebExtPlugin from 'web-ext-plugin';
import * as path from 'path';
import CopyPlugin from 'copy-webpack-plugin';
import webpack from 'webpack';
import { dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));

export default {
    mode: "production",
    entry: {
        background: path.resolve(__dirname, "background.ts"),
        contentScript: path.resolve(__dirname, "contentScript.ts"),
    },
    output: {
        path: path.join(__dirname, "dist"),
        filename: "[name].js",
        clean: true,
    },
    resolve: {
        extensions: [".ts", ".js"],
    },
    module: {
        rules: [
            {
                test: /\.tsx?$/,
                loader: "ts-loader",
                exclude: /node_modules/,
            },
        ],
    },
    plugins: [
        new CopyPlugin({
            patterns: [
                {from: "icons/", to: "icons/", },
                {from: "manifest.json", to: ".", },
            ]
        }),
        new WebExtPlugin({ sourceDir: path.join(__dirname, "dist"), buildPackage: true })
    ],
}
```

Możemy zacząć budować nowe rozszerzenie, lecz wpierw potrzebujemy utworzyć plik manifestu. Specyfikacje `manifest.json` możemy znaleźć w [dokumentacji](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json).
Mozilla udostępnia [wiele przykładów](https://github.com/mdn/webextensions-examples) na których możemy się wzorować i zbudować własne rozszerzenie.

Do zbudowania wtyczki wywołujemy polecenie `npx webpack --config webpack.config.mjs`.
Następnie mając zainstalowany pakiet `web-ext` wywołujemy w konsoli polecenie `web-ext run --source-dir ./dist/`, które spowoduje odpalenie nowej instancji przeglądarki Firefox z nowym profilem, który będzie miał zainstalowane nasze rozszerzenie.

[Browser Extensions](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions)
[Creating Chrome Extensions With TypeScript](https://betterprogramming.pub/creating-chrome-extensions-with-typescript-914873467b65)
[Random notes and tips about developing a browser extension](https://ninoseki.github.io/2020/05/16/browser-extension.html)

## Publikacja rozszerzenia

Rozszerzenie musi zostać podpisane, zanim będzie można je zainstalować w stabilnych wydaniach Firefox.
Proces odbywa się na stronie [https://addons.mozilla.org (AMO)](https://addons.mozilla.org) niezależnie od tego, czy publikujemy dodatek za pośrednictwem AMO czy dystrybuujemy rozszerzenie sami.
Zmiana flagi `xpinstall.signatures.required` na wartość `false` w `about:config` działa tylko w [wybranych wersjach przeglądarki Firefox](https://extensionworkshop.com/documentation/publish/signing-and-distribution-overview/#signing-your-addons):

> Unsigned extensions can be installed in the Developer Edition, Nightly, and ESR versions of Firefox, after toggling the xpinstall.signatures.required preference in about:config. To use this feature your extension must have an add-on ID.


[Signing and distributing your add-on](https://extensionworkshop.com/documentation/publish/signing-and-distribution-overview/)

[Add-on Policies](https://extensionworkshop.com/documentation/publish/add-on-policies/)

### web-ext sign

Na stronie [Manage API Keys](https://addons.mozilla.org/en-US/developers/addon/api/key/) generujemy klucze API do AMO.
Następnie tworzymy plik w katalogu domowym `.web-ext-config.js` w którym eksportujemy nasze klucze do API AMO.

Zawartość pliku `~/.web-ext-config.js` powinna prezentować się następująco:
```
module.exports = {
    sign: {
        apiKey: 'user:1...8',
        apiSecret: 'c.....2',
    }
};

```

W katalogu projektu możemy utworzyć kolejny plik konfiguracyjny dla web-ext `web-ext-config.js` w którym ustawiamy wartości dla niewrażliwych parametrów takich jak ignorowane pliki czy id rozszerzenia (pierwsza publikacja rozszerzenia spowoduje wygenerowanie id).

```
module.exports = {
    ignoreFiles: [
        'web-ext-artifacts/',
        '.gitignore',
        '.web-extension-id',
    ],
    sourceDir: "./dist/",
    artifactsDir: "./dist/web-ext-artifacts",
    sign: {
        channel: "unlisted",
        id: "{d.......3}",
    }
};
```

Finalnie możemy w pliku `package.json`  i sekcji "scripts" dodać akcję `sign`, która wywoła polecenie `web-ext sign`

```
{
  "scripts": {
    "sign": "web-ext sign"
  }
  # ....
}

```
