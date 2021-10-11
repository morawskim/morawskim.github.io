# Rector

Rector pozwala nam automatycznie zrefaktoryzować kod.

Instalujemy rector - `composer require rector/rector --dev`
Następnie tworzymy plik `rector.php` i wklejamy:
```
// rector.php
use Rector\PHPUnit\Set\PHPUnitSetList;
use Symfony\Component\DependencyInjection\Loader\Configurator\ContainerConfigurator;

return function (ContainerConfigurator $containerConfigurator): void {
    $containerConfigurator->import(PHPUnitSetList::PHPUNIT_60);
};

```

Naszym zadaniem jest zrefaktoryzowanie testów do PHPUnit w wersji 6. To wydanie jako pierwsze wprowadziło przestrzenie nazw. Dlatego wpierw odpalamy rector (inaczej dostaniemy błędy że klasa `PHPUnit_Framework_TestCase` nie istnieje) - `./vendor/bin/rector process tests/`. Nasze przypadki testowe zostaną zmodyfikowane.

Możemy teraz dokonać aktualizacji PHPUnit do wersji 6 - `composer require phpunit/phpunit "^6.0" --dev --update-with-dependencies`.

Powtarzamy kroki, aż dojdziemy do najnowszej wersji PHPUnit.

W przypadku frameworka Symfony, w którym pakiet PHPUnit jest instalowany w innym katalogu, podczas wywoływania polecenia musimy dodać parametr autoload-file: `--autoload-file=bin/.phpunit/phpunit-6.5/vendor/autoload.php`.

[Still on PHPUnit 4? Come to PHPUnit 8 Together in a Day](https://tomasvotruba.com/blog/2019/11/04/still-on-phpunit-4-come-to-phpunit-8-together-in-a-day/)
