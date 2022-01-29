# Symfony Bundle

## Tłumaczenia

Tworzymy nową klasę Bundle (zgodnie z [konwencją nazewniczą Symfony](https://symfony.com/doc/current/bundles/best_practices.html#bundle-name)) dziedziczącą po  `\Symfony\Component\HttpKernel\Bundle\Bundle`.
Dzięki FrameworkExtension i konwencji wszystkie pliki tłumaczeń przechowywane w katalogu `src/Resources/translations/` naszego bundle są [automatycznie rejestrowane](https://github.com/symfony/symfony/blob/bba4c8d490b76eb6859e9801fcff1cb1428e4132/src/Symfony/Bundle/FrameworkBundle/DependencyInjection/FrameworkExtension.php#L1334)
