# Webpack Analyzer Bundle

Plugin `Webpack Analyzer Bundle` pozwala nam wizualizować wynik webpack w formie interaktywnej mapy. Wyświetla wielkość każdego wynikowego bundle. Dzięki temu możemy odkryć, które bundle są ogromne i zacząć proces optymalizacji wielkości paczek.


Musimy zainstalować pakiet `webpack-bundle-analyzer` - `yarn add -D webpack-bundle-analyzer`.
Następnie w pliku konfiguracji webpack `webpack.config.js` wczytujemy plugin `const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;`

W przypadku konfiguracji przez pakiet `@symfony/webpack-encore` wystarczy dodać poniższy fragment kodu:
```
Encore.addPlugin(
    new BundleAnalyzerPlugin({
        analyzerMode: 'disabled',
        generateStatsFile: true,
        statsOptions: { source: false },
    })
);
```

W przypadku środowiska CI być może będziemy potrzebowali zmienić domyślną ścieżkę wynikowego pliku z statystykami: `statsFilename: process.env.CI ? path.join(process.env.CI_PROJECT_DIR, 'frontend/webpack/stats.json') : 'stats.json',`.

Podczas budowania wygenerowany zostanie plik `stats.json`. Możemy wizualizować jego dane wywołując polecenie `npx webpack-bundle-analyzer /sciezka/do/pliku/stats.json`.

Nie musimy korzystać z wizualizacji dostarczanej w ramach pluginu `webpack-bundle-analyzer`. Możemy skorzystać z internetowych narzędzi.

* http://webpack.github.io/analyse/

* https://chrisbateman.github.io/webpack-visualizer/ Dostępny także offline poprzez pakiet `webpack-visualizer-plugin`

* https://alexkuz.github.io/webpack-chart/
