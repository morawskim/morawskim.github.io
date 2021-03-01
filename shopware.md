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

Do naszej eksportowanej funkcji przekazywany jest także obiekt konfiguracji (webpack z dodatkowymi danymi Shopware).
Jeśli chcemy coś zmienić w domyślnej konfiguracji, to możemy to zrobić modyfikując ten obiekt.

W zależności gdzie mamy katalog `node_modules` będziemy musieli dostosować ściezki do katalogów. Musimy korzystać z składni `use` a nie bezpośrednio z `loader`, ponieważ moduł npm Shopware `@shopware-ag/webpack-plugin-injector` nadpisuje właściwość `include` - [https://github.com/shopware/webpack-plugin-injector/blob/515f4f78bf09a031d8bdbc13a4494bea9536511d/index.js#L285](https://github.com/shopware/webpack-plugin-injector/blob/515f4f78bf09a031d8bdbc13a4494bea9536511d/index.js#L285)

## Tagi Shopware

### Walidator koszyka

Implementując interfejs `\Shopware\Core\Checkout\Cart\CartValidatorInterface` jesteśmy w stanie weryfikować stan koszyka. Możemy ją wykorzystać w celu sprawdzenia reguł biznesowych np. dotyczących adresu wysyłkowego. Naszą usługę musimy oznaczyć tagiem `shopware.cart.validator`.

### Cart processor

Implementując interfejs `\Shopware\Core\Checkout\Cart\CartProcessorInterface` i oznaczając usługę tagiem  `shopware.cart.processor`, możemy zaimplementować logikę modyfikującą koszyk.

### Cart collector

Implementując interfejs `\Shopware\Core\Checkout\Cart\CartDataCollectorInterface` i oznaczając usługę
tagiem `shopware.cart.collector` możemy zaimplementować logikę, która np. doda do każdej pozycji koszyka
dodatkowe właściwości np. dodatkowe atrybuty produktów.

### CMS data resolver

Tworząc własne elementy CMS, najczęściej musimy dynamicznie pobierać dane. W takim przypadku tworzymy usługę,
która implementuje interfejs `\Shopware\Core\Content\Cms\DataResolver\Element\CmsElementResolverInterface` i
oznaczyć ją tagiem `shopware.cms.data_resolver`. Warto wzorować się na domyślnych implementacjach Shopware.

Do pobrania podstawowych danych na stronie (np. nawigacja) wstrzykujemy usługę implementującą interfejs `\Shopware\Storefront\Page\GenericPageLoaderInterface` i wywołujemy metodę `load`. Do pobierania strony CMS wstrzykujemy usługę, która implementuje interfejs `\Shopware\Core\Content\Cms\SalesChannel\SalesChannelCmsPageLoaderInterface`. Następnie możemy wywołać metodę `load` - `$page = $this->cmsPageLoader->load($request, $salesChannelContext);`. W zmiennej `$page` będziemy mieć dostępne wszystkie bloki z danymi niezbędnymi do wyświetlenia strony. Możemy skorzystać z domyślnego widoku `@Storefront/storefront/page/content/index.html.twig` do wyświetlenia strony.

## Panel admina (build dev)

W wersji Shopware `6.3.4.1` nie możemy zbudować wersji deweloperskiej panelu administratora. Możemy spróbować wywołać polecenie ` ./psh.phar administration:watch`. Zmodyfikowałem więc plik konfiguracyjny webpack `vendor/shopware/platform/src/Administration/Resources/app/administration/webpack.config.js`

1. Ustawiłem jawnie tryb `mode` na wartość `development`
1. Parametr `devtool` ustawiłem na wartość `eval-source-map`
1. Zakomentowałem cały blok ustawiający opcję `optimization.minimizer`
1. Zmieniłem w definicji pluginu `webpack.DefinePlugin` wartość zmiennej `NODE_ENV` na `'"development"'`. Ten krok powoduje kilka efektów ubocznych. Parę skryptów js przestanie działać, bo weryfikują one w jakim środowisku uruchomiony jest panel administratora (np. `vendor/shopware/platform/src/Administration/Resources/app/administration/src/core/application.js:515`.

Po tych zmianach i zbudowaniu części administracyjnej rozszerzenie deweloperskie Vue powinno działać, a także powinniśmy mieć dostęp do niezminimalizowanych plików js.

```
--- src/Administration/Resources/app/administration/webpack.config.js	2021-02-20 10:20:21.679972552 +0100
+++ webpack.config.js	2021-02-20 10:20:04.000000000 +0100
@@ -84,7 +84,9 @@
 console.log();

 const webpackConfig = {
-    mode: isDev ? 'development' : 'production',
+    //mode: isDev ? 'development' : 'production',
+    mode: 'development',
+
     bail: isDev ? false : true,
     stats: {
         all: false,
@@ -108,7 +110,6 @@
                 devServer: {
                     host: process.env.HOST,
                     port: process.env.PORT,
-                    disableHostCheck: true,
                     open: true,
                     proxy: {
                         '/api': {
@@ -135,7 +136,8 @@
         }
     })(),

-    devtool: isDev ? 'eval-source-map' : '#source-map',
+    // devtool: isDev ? 'eval-source-map' : '#source-map',
+    devtool: 'eval-source-map',

     optimization: {
         moduleIds: 'hashed',
@@ -152,22 +154,22 @@
             minSize: 0
         },
         ...(() => {
-            if (isProd) {
-                return {
-                    minimizer: [
-                        new TerserPlugin({
-                            terserOptions: {
-                                warnings: false,
-                                output: 6
-                            },
-                            cache: true,
-                            parallel: true,
-                            sourceMap: false
-                        }),
-                        new OptimizeCSSAssetsPlugin()
-                    ]
-                };
-            }
+            // if (isProd) {
+            //     return {
+            //         minimizer: [
+            //             new TerserPlugin({
+            //                 terserOptions: {
+            //                     warnings: false,
+            //                     output: 6
+            //                 },
+            //                 cache: true,
+            //                 parallel: true,
+            //                 sourceMap: false
+            //             }),
+            //             new OptimizeCSSAssetsPlugin()
+            //         ]
+            //     };
+            // }
         })()
     },

@@ -198,7 +200,6 @@
         alias: {
             vue$: 'vue/dist/vue.esm.js',
             src: path.join(__dirname, 'src'),
-            // ???
             // deprecated tag:v6.4.0.0
             module: path.join(__dirname, 'src/module'),
             scss: path.join(__dirname, 'src/app/assets/scss'),
@@ -424,7 +425,8 @@
     plugins: [
         new webpack.DefinePlugin({
             'process.env': {
-                NODE_ENV: isDev ? '"development"' : '"production"'
+                // NODE_ENV: isDev ? '"development"' : '"production"'
+                NODE_ENV: '"development"'
             }
         }),
         new MiniCssExtractPlugin({
```

## Reguły

Dla każdej metody płatności/wysyłki możemy przypisać regułę dostępności. W przypadku gdy np. zawartość koszyka nie będzie spełniać wymogów reguły dana opcja wysyłki/płatności zostanie zablokowana i nie będzie można złożyć zamówienia. Shopware dostarcza wiele wbudowanych reguł. Wystarczy wyszukać klasy z tagiem `shopware.rule.definition` - `./bin/console debug:container --tag shopware.rule.definition`. Jeśli chcemy utworzyć własną regułę musi ona także dziedziczyć po klasie `\Shopware\Core\Framework\Rule\Rule`. Aby pokazać naszą nową regułę w panelu administratora, musimy utworzyć dekorator dla usługi RuleConditionService (`vendor/shopware/platform/src/Administration/Resources/app/administration/src/app/service/rule-condition.service.js`). Przykładowy dekorator z rejestracją domyślnych reguł shopware jest zdefiniowany w pliku `vendor/shopware/platform/src/Administration/Resources/app/administration/src/app/decorator/condition-type-data-provider.decorator.js`.

[Register a custom rule via plugin](https://docs.shopware.com/en/shopware-platform-dev-en/how-to/custom-rule)
