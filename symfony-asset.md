# Symfony Asset

## Symfony Asset Component

Do zarządzania plikami CSS i JS w nowszych wersjach Symfony służy pakiet `symfony/webpack-encore-bundle`. Jednak jeśli nie potrzebujemy webpacka i budowania bundle, możemy skorzystać z komponentu [Asset](https://symfony.com/doc/5.0/components/asset.html).

W pliku `config/packages/framework.yaml` dodajemy konfigurację dla pakietu `app`. Dzięki deklaracji nowego pakietu, nie zmieniamy domyślnego położenia zasobów CSS/JS zainstalowanych przez polecenie `./bin/console assets:install`. W usłudze w którym chcemy wygenerować linki do zasobów wstrzykujemy usługę `\Symfony\Component\Asset\Packages` i za pomocą metody `getUrl` generujemy URL - `$packages->getUrl('sweetalert/sweetalert2.min.css', 'app')`.

```
assets:
    packages:
        app:
            base_path: '/assets'
```

[Framework configuration for assets](https://symfony.com/doc/current/reference/configuration/framework.html#assets)

[Twig asset function](https://github.com/symfony/twig-bridge/blob/ca6b2f6ad6b278d45a8e7f8d53b14bf991fad725/Extension/AssetExtension.php#L51)
