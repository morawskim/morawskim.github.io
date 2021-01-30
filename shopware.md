# Shopware

## Storefront i TypeScript

Shopware korzysta z `webpack` do budowania paczek js. Możemy dodać loader, który przetworzy nam kod TS na kod JS.
Najpierw instalujemy dwa pakiety npm `@babel/core` i `@babel/preset-typescript`.

Tworzymy plik `<PLUGIN>/src/Resources/app/storefront/build/webpack.config.js` i wklejamy zawartość:

```
const { join, resolve } = require('path');

module.exports = () => {
    return {
        resolve: {
            extensions: [ '.ts' ],
        },
        module: {
            rules: [
                {
                    test: /\.ts$/,
                    use: [
                        {
                            loader: 'babel-loader',
                            options: {
                                presets: [join(__dirname, '../..', 'node_modules', '@babel', 'preset-typescript')]
                            },
                        }
                    ],
                    include: [
                        join(__dirname, '../..', 'storefront', 'src'),
                    ]
                }
            ]
        }
    };
}
```

W zależności gdzie mamy katalog `node_modules` będziemy musieli dostosować ściezki do katalogów. Musimy korzystać z składni `use` a nie bezpośrednio z `loader`, ponieważ moduł npm Shopware `@shopware-ag/webpack-plugin-injector` nadpisuje właściwość `include` - [https://github.com/shopware/webpack-plugin-injector/blob/515f4f78bf09a031d8bdbc13a4494bea9536511d/index.js#L285](https://github.com/shopware/webpack-plugin-injector/blob/515f4f78bf09a031d8bdbc13a4494bea9536511d/index.js#L285)
