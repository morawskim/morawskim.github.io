# PHP Quality Assurance

## PHP Coding Standards Fixer

`friendsofphp/php-cs-fixer` jest narzędziem do automatycznego formatowania kodu do jednego z standardów kodowania np. PSR-2. Tworzymy plik `.php_cs.dist` z konfiguracją:

```
<?php

$config = PhpCsFixer\Config::create()
    ->setRiskyAllowed(true)
    ->setRules([
        '@PSR2' => true,
        'array_syntax' => ['syntax' => 'short'],
        'fully_qualified_strict_types' => true,
        'blank_line_before_statement' => ['statements' => ['break', 'continue', 'declare', 'return', 'throw', 'try']],
        'class_attributes_separation' => ['elements' => ['const' => 'one', 'method' => 'one', 'property' => 'one']],
        'global_namespace_import' => true,
        'function_typehint_space' => true,
        'phpdoc_separation' => true,
    ])
    ->setFinder(
        PhpCsFixer\Finder::create()
            ->in(__DIR__.'/src')
            ->name('*.php')
    )
;

return $config;

```

[Rules](https://cs.symfony.com/doc/rules/index.html)

## Psalm

PHPStorm w wersji 2020.3 otrzymał wsparcie dla narzędzia Psalm. Musimy zainstalować pakiet - `composer require --dev vimeo/psalm`. Następnie mając otwarty plik `composer.json` w PHPStorm klikamy na ikonę klucza obok pakietu psalm. Podajemy ścieżkę do pliku wykonywalnego psalm i włączamy inspektor dla Psalm. PHPStorm może wygenerować domyślny plik konfiguracyjny `psalm.xml`.

```
<?xml version="1.0"?>
<psalm
    errorLevel="3"
    resolveFromConfigFile="true"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns="https://getpsalm.org/schema/config"
    xsi:schemaLocation="https://getpsalm.org/schema/config vendor/vimeo/psalm/config.xsd"
>
    <projectFiles>
        <directory name="." />
        <ignoreFiles>
            <directory name="vendor" />
        </ignoreFiles>
    </projectFiles>
</psalm>

```

[Psalm and PHPStan Support](https://www.jetbrains.com/phpstorm/whatsnew/#psalm-and-phpstan-support)

Adnotacje Psalm:

* `@psalm-readonly` i `@readonly` - Służy do adnotacji właściwości, do której można przypisać wartość tylko w konstruktorze.

* `@psalm-mutation-free` - Służy do adnotacji metody klasy, która nie zmienia stanu.

* `@psalm-immutable` - Służy do adnotowania klasy, w której każda właściwość jest traktowana jako `@psalm-readonly`, a każda metoda instancji jest traktowana jako `@psalm-mutation-free`.

* `@psalm-pure` - Takie same działanie jak `@psalm-mutation-free`, ale dla funkcji.

* `@param pure-callable(string): int $callback` - Adnotacja do określenia, że wywołanie zwrotne jest tzw. czystą funkcją.


``` php
<?php

class PsalmTest
{
    /**
     * @var string
     *
     * @psalm-readonly
     */
    public $s;

    public function __construct(string $s)
    {
        $this->s = $s;
    }

    /**
     * @psalm-mutation-free
     */
    public function getShortMutating() : string
    {
        $this->s .= "hello"; // this is a bug

        return substr($this->s, 0, 5);
    }

    /**
     * @psalm-return array<string>
     */
    public function getArray(): array
    {
        return ['aa', 123];
    }

    /**
     * @param pure-callable(string): int $callback
     */
    public function addCallable(callable $callback)
    {
    }
}

$b = new PsalmTest("hello");
$b->s = "foo"; // this is wrong

$b->addCallable(function (string $p) {
    return random_int(1, 2); // this is wrong
});

$b->addCallable(function (int $p) {
    return strlen((string) $p); // this is wrong, to callback we pass string not int
});

```

## PHP_CodeSniffer

Pakiet `slevomat/coding-standard` zawiera dodatkowe reguły dla `PHP_CodeSniffer`.

Pakiet `phpcompatibility/php-compatibility` zawiera reguły do sprawdzenia zgodności z różnymi wersjami PHP.

[slevomat/coding-standard](https://github.com/slevomat/coding-standard)

[phpcompatibility/php-compatibility](https://github.com/PHPCompatibility/PHPCompatibility)
