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

## Tagi Shopware

### Walidator koszyka

Implementując interfejs `\Shopware\Core\Checkout\Cart\CartValidatorInterface` jesteśmy w stanie weryfikować stan koszyka. Możemy ją wykorzystać w celu sprawdzenia reguł biznesowych np. dotyczących adresu wysyłkowego. Naszą usługę musimy oznaczyć tagiem `shopware.cart.validator`.

### Cart processor

Implementując interfejs `\Shopware\Core\Checkout\Cart\CartProcessorInterface` i oznaczając usługę tagiem  `shopware.cart.processor`, możemy zaimplementować logikę modyfikującą koszyk.

### Cart collector

Implementując interfejs `\Shopware\Core\Checkout\Cart\CartDataCollectorInterface` i oznaczając usługę tagiem `shopware.cart.collector` możemy zaimplementować logikę, która np. doda do każdej pozycji koszyka dodatkowe właściwości np. dodatkowe atrybuty produktów.