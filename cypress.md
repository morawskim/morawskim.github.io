# Cypress

Cypress to biblioteka do przeprowadzenia testów e2e. Od wersji 4.4 zawiera wsparcie dla TypeScript.

## Instalacja i konfiguracja

Najlepiej wydzielić oddzielny katalog dla testów e2e z oddzielnymi zależnościami pakietów.

Instalujemy typescript - `npm install --save-dev typescript`. Następnie tworzymy plik `tsconfig.json` do którego wklejamy zawartość:

```
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["es5", "dom"],
    "types": ["cypress"]
  },
  "include": [
    "**/*.ts"
  ]
}
```

Następnie instalujemy pakiet cypress - `npm install cypress --save-dev`.
Po tych krokach powinniśmy być w stanie otworzyć i zweryfikować czy cypress działa wywołując polecenie - `npx cypress open` i odpalając jeden z przykładowych testów.

W katalogu gdzie instalowaliśmy cypress powinien znajdować się plik konfiguracyjny `cypress.json`. Jeśli go nie ma to go tworzymy i wklejamy minimalną konfigurację:

```
{
  "baseUrl": "http://sut.example.com"
}
```

Aby dodać własny test tworzymy plik `example_spec.ts` w katalogu `cypress/integration`.

[Cypress & TypeScript](https://docs.cypress.io/guides/tooling/typescript-support.html#Install-TypeScript)
[Installing Cypress](https://docs.cypress.io/guides/getting-started/installing-cypress.html)

## Testy parametryzowane

Cypresss dostarcza nam 5 sposobów na [parametryzację testów](https://docs.cypress.io/guides/guides/environment-variables.html). Choć możemy korzystać z pliku `cypress.json` pojawia się problem w zarządzaniu, gdy mamy więcej niż jedno środowisko i potrzebujemy oddzielnej konfiguracji dla każdego środowiska. Najlepszym sposobem jest więc utworzenie pluginu, który załaduje plik konfiguracyjny i scali ją z konfiguracją cypress. W [dokumentacji](https://docs.cypress.io/api/plugins/configuration-api.html#Usage) mamy przykład takiego pluginu.

Musimy tylko dostosować ścieżkę do plików konfiguracyjnego i domyślny plik konfiguracyjny. Następnie możemy odpalić cypress dodając argument `--env` z nazwą pliku konfiguracyjnego - `npx cypress open --env configFile=docker`

```
const fs = require('fs-extra')
const path = require('path')

function getConfigurationByFile(file) {
    const pathToConfigFile = path.resolve('./cypress', 'config', `${file}.json`)

    return fs.readJson(pathToConfigFile)
}

/**
 * @type {Cypress.PluginConfig}
 */
module.exports = (on, config) => {
    // `on` is used to hook into various events Cypress emits
    // `config` is the resolved Cypress config

    // accept a configFile value or use development by default
    const file = config.env.configFile || 'docker'

    return getConfigurationByFile(file)
}
```
