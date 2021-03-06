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
    const raw = fs.readFileSync(pathToConfigFile);

    return JSON.parse(raw);
}

/**
 * @type {Cypress.PluginConfig}
 */
module.exports = (on, config) => {
    // `on` is used to hook into various events Cypress emits
    // `config` is the resolved Cypress config

    // accept a configFile value or use development by default
    const file = config.env.configFile || 'docker';
    const configurationFromFile = getConfigurationByFile(file);

    return { ...configurationFromFile, env: { ...configurationFromFile.env, ...config.env } };
}
```

## Docker i CI

Cypress dostarcza kilka rodzaj [obrazów dockera](https://docs.cypress.io/examples/examples/docker.html#Images) do uruchamiana testów lokalnie czy też w procesie CI. Do uruchamiania testów lokalnie możemy skorzystać z obrazu `cypress/included:<VCYPRESS_VERSION>` - `docker run --rm -it -v $(PWD)/frontend/e2e:/e2e -w /e2e cypress/included:6.2.1 --env configFile=ssorder-develop`. Chcąc zintegrować cypresss z GitLab CI/CD korzystamy z obrazów `cypress/browsers` np. `cypress/browsers:node14.7.0-chrome84`, który zawiera przeglądarkę chrome. Dostępne są także wariant z chromem i firefoxem. Następnie instalujemy cypress i uruchamiamy testy wywołujące polecenie - `npx cypress run --browser chrome --env configFile=ssorder-develop`

[Run Cypress with a single Docker command](https://www.cypress.io/blog/2019/05/02/run-cypress-with-a-single-docker-command/)

W przypadku problemów z działaniem przeglądarki Chrome w Docker możemy spróbować przekazać dodatkowe flagi do chrome - [Add additional flags when running Chrome](https://github.com/cypress-io/cypress/issues/3633)

Przykładowe zadanie dla GitLab CI/CD do uruchomienia testów e2e wykorzystując przeglądarkę chrome wraz z przechowywaniem artefaktów z testów:

```
cypress:
  image: cypress/browsers:node14.7.0-chrome84
  stage: qa
  script:
    - pushd frontend/e2e
    - npm ci
    - $(npm bin)/cypress verify
    - $(npm bin)/cypress run --browser chrome --env configFile=ssorder-develop
  artifacts:
    expire_in: 1 week
    when: always
    paths:
      - frontend/e2e/cypress/
  rules:
    - if: '$CI_PIPELINE_SOURCE == "schedule"'
```

[Cypress tests in Docker on GitLab](https://gitlab.com/cypress-io/cypress-example-docker-gitlab)

## Retries

Polecenia które odpytują drzewo DOM są automatycznie ponawiane aż do przekroczenia parametru limitu czasu (timeout). Dzięki temu nasze testy są bardziej niezawodne. Dodanie do aplikacji asynchronicznego kodu nie powoduje niepowodzenia testów.
Jednak tylko ostatnie polecenie w łańcuchu podlega ponawianiu. [Takie zachowanie może doprowadzić do pewnych błędów.](https://docs.cypress.io/guides/core-concepts/retry-ability.html#Only-the-last-command-is-retried)

[Use should with a callback](https://docs.cypress.io/guides/core-concepts/retry-ability.html#Use-should-with-a-callback)

Testy uruchomione na serwerze ciągłej integracji mogą czasem się nie powieść. Najczęściej jest to spowodowane losowymi problemami z siecią. Cypress może ponownie uruchomić testy zakończone niepowodzeniem, aby zredukować błędy kompilacji CI. W pliku konfiguracyjnym `cypress.json` dodajemy klucz "retries" z opcjami `runMode` i `openMode`.

```
{
  "retries": {
    // Configure retry attempts for `cypress run`
    // Default is 0
    "runMode": 2,
    // Configure retry attempts for `cypress open`
    // Default is 0
    "openMode": 0
  }
}
```

[Test Retries](https://docs.cypress.io/guides/guides/test-retries.html)

## Typy TypeScript

Definiując własne polecenia w cypress i korzystając z TypeScript musimy rozszerzyć interfejs `Chainable` o deklarację naszych poleceń. Musimy utworzyć plik `support/index.d.ts` z zawartością:

```
/// <reference types="cypress" />

declare namespace Cypress {
    interface Chainable {
        /**
         * A command for receiving an access token
         */
        getAuthToken(userName: string, password: string): Chainable<string>;
    }
}

```

[Types for custom commands](https://docs.cypress.io/guides/tooling/typescript-support.html#Types-for-custom-commands)

## Filmy i zrzuty ekranu w wysokiej rozdzielczości

Zrzuty ekranu i film z przebiegu testu są ważną częścią w analizie niepoprawnych testów. W trybie headless testy są odpalane w przeglądarce z rozdzielczością 1000 x 660. Możemy zmienić te ustawienia, ale musimy to zrobić dla każdej przeglądarki oddzielnie. Dodatkowo w pliku konfiguracyjnym ustawiamy dwa parametry: `viewportWidth` i `viewportHeight`. Możemy je także przekazać jako argumenty `--config viewportWidth=1920,viewportHeight=1080`.

W pliku `plugins/index.js` w eksportowanej funkcji (`module.exports`) dodajemy poniższy kod:

```
// let's increase the browser window size when running headlessly
// this will produce higher resolution images and videos
// https://on.cypress.io/browser-launch-api
on('before:browser:launch', (browser = {}, launchOptions) => {
    console.log(
        'launching browser %s is headless? %s',
        browser.name,
        browser.isHeadless,
    )

    // the browser width and height we want to get
    // our screenshots and videos will be of that resolution
    const width = 1920
    const height = 1080

    console.log('setting the browser window size to %d x %d', width, height)

    if (browser.name === 'chrome' && browser.isHeadless) {
        launchOptions.args.push(`--window-size=${width},${height}`)

        // force screen to be non-retina and just use our given resolution
        launchOptions.args.push('--force-device-scale-factor=1')
    }

    if (browser.name === 'electron' && browser.isHeadless) {
        // might not work on CI for some reason
        launchOptions.preferences.width = width
        launchOptions.preferences.height = height
    }

    if (browser.name === 'firefox' && browser.isHeadless) {
        launchOptions.args.push(`--width=${width}`)
        launchOptions.args.push(`--height=${height}`)
    }

    return launchOptions
});
```

[Generate High-Resolution Videos and Screenshots](https://cypress-io.ghost.io/blog/2021/03/01/generate-high-resolution-videos-and-screenshots/)

[DEMO](https://github.com/bahmutov/cypress-wikipedia/tree/abc02b74e12ba3f3c38de5635fef6bf4b2875213)
