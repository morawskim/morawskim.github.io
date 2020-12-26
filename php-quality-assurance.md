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
