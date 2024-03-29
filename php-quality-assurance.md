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

Psalm umożliwia nam kontrolowanie ograniczenie wartości stringów tylko do tych występujących jako klucze w tablicy. Służy do tego Magical type `key-if`.

Przykład deklaracji:

```
/**
 * @template T of key-of<self::MAP>
 *
 * @param T $key
 *
 * @return string
 */
public function getValue(string $key): string
{
    return self::MAP[$key];
}
```

[DEMO](https://psalm.dev/r/db71e09250)

## PHP_CodeSniffer

Pakiet `slevomat/coding-standard` zawiera dodatkowe reguły dla `PHP_CodeSniffer`.

Pakiet `phpcompatibility/php-compatibility` zawiera reguły do sprawdzenia zgodności z różnymi wersjami PHP.

[slevomat/coding-standard](https://github.com/slevomat/coding-standard)

[phpcompatibility/php-compatibility](https://github.com/PHPCompatibility/PHPCompatibility)

### Ignorowanie reguł

Być może dla części pliku będziemy chcieli wyłączyć wybrane reguły PHPCS. [Stosując odpowiednie komentarze w kodzie możemy zignorować dowolny fragment lub linię kodu](https://github.com/squizlabs/PHP_CodeSniffer/wiki/Advanced-Usage#ignoring-parts-of-a-file). Obecnie nie możemy wyłączyć reguły dla metody ([phpcs:ignore in function doc](https://github.com/squizlabs/PHP_CodeSniffer/issues/2367)).

Za pomocą komentarza `// phpcs:ignore Rule1, Rule2` ignorujemy bieżącą i następną linię.
Wykorzystując `// phpcs:disable Rule1, Rule2` i `// phpcs:enable Rule1, Rule2` możemy zignorować określony fragment pliku.

Domyślnie `phpcs` nie wyświetla nazwy reguły, która została naruszona. Musimy dodać parametr `-s` do wywołania.

```
./vendor/bin/phpcs -s tests/ObjectMother/Offer/OfferNormalizerArrayObjectMother.php

FILE: tests/ObjectMother/Offer/OfferNormalizerArrayObjectMother.php
--------------------------------------------------------------------------------------------------------
FOUND 0 ERRORS AND 1 WARNING AFFECTING 1 LINE
--------------------------------------------------------------------------------------------------------
 39 | WARNING | Line exceeds 120 characters; contains 194 characters
    |         | (Generic.Files.LineLength.TooLong)
--------------------------------------------------------------------------------------------------------
```

## PHPStan

Analizator kodu PHPStan najlepiej wywoływać z obrazu dockera `jakzal/phpqa:alpine`, ponieważ do działania potrzebuje PHP 8, a także `symfony/dependency-injection`.

W kontenerze `phpqa` wywołujemy polecenie `composer global bin phpstan require symplify/phpstan-rules`, aby doinstalować dodatkowe reguły. Następnie w głównym katalogu tworzymy plik `phpstan.neon` i wklejamy przykladową konfigurację:

```
parameters:
    phpVersion: 70400 # PHP 7.4
    level: 8
    paths:
        - src
        - tests
    ignoreErrors:
        - '#Do not use chained method calls#'
        - '#Interface must be located in "Contract" namespace#'
        - '#Method [\w\\]+::buildForm\(\) has parameter \$builder with no value type specified in iterable type Symfony\\Component\\Form\\FormBuilderInterface#'
        - '#Method [\w\\]+::buildForm\(\) has parameter \$options with no value type specified in iterable type array#'
        -
            message: '#Method [\w\\]+::normalize\(\) has parameter \$context with no value type specified in iterable type array#'
            path: *Normalizer.php
        -
            message: '#Do not use @method tag in class docblock#'
            path: *Repository.php
        -
            message: '#Property [\w\\]+::\$[\w]+ is never written, only read.#'
            path: */Entity/*.php
includes:
    - /tools/.composer/vendor-bin/phpstan/vendor/phpstan/phpstan/conf/bleedingEdge.neon
    - /tools/.composer/vendor-bin/phpstan/vendor/symplify/phpstan-rules/config/services/services.neon
    - /tools/.composer/vendor-bin/phpstan/vendor/symplify/phpstan-rules/config/static-rules.neon
    - /tools/.composer/vendor-bin/phpstan/vendor/symplify/phpstan-rules/config/code-complexity-rules.neon
    - /tools/.composer/vendor-bin/phpstan/vendor/symplify/phpstan-rules/packages/cognitive-complexity/config/cognitive-complexity-services.neon

services:

    -
        class: Symplify\PHPStanRules\CognitiveComplexity\Rules\ClassLikeCognitiveComplexityRule
        tags: [phpstan.rules.rule]
        arguments:
            maxClassCognitiveComplexity: 10


```

### Porady

### Stub file

PHPStan wykorzystuje komentarze PHPDoc w trakcie analizy kodu. Zewnętrzne biblioteki mogą nie zawierać komentarzy PHPDoc. choć dzięki obsłudze natywnych typów w PHP, problemy najczęściej dotyczą braku wsparcia dla typów generycznych.

Aby temu zaradzić, możemy  utworzyć tak zwanych [stub file](https://phpstan.org/user-guide/stub-files). Najelpiej wzorować się na [przykładach z PHPStan](https://github.com/phpstan/phpstan-src/tree/4caad035e394adb2f25d18543fc30526e78db97e/stubs) albo [rozszerzenia dla Doctrine](https://github.com/phpstan/phpstan-doctrine/tree/cba50e9ad665687547e476ebd877cb4a3c8d798c/stubs).

### Funkcja dumpType

PHPStan dostarcza funkcję `\PHPStan\dumpType`, która wyświetla jaki typ widzi PHPStan. Wynik wyświetlany jest w raporcie analizowanego kodu.

> Line   PHPFile.php
> ------ --------------------
> 23     Dumped type: App\Foo\Bar

### Alias
Możemy definiować alias typu wykorzystując adnotację `@phpstan-type NaszaNazwaAliasu typ`. Taki alias możemy wykorzystać także poza klasą importując go za pomocą adnotacji `@phpstan-import-type NAZWA_ALIASU from FullyQualifiedClassName`.

### Type coverage analyse

Wykorzystując pakiet [tomasvotruba/type-coverage](https://github.com/TomasVotruba/type-coverage) możemy weryfikować pokrycie typami.
Argumenty funkcji/metod powinny być opisane jawnie typami, a nie "mixed". Podobnie tyczy się to właściwości klas, czy zwracanej wartości funkcji/metody.

Jeśli korzystamy z obrazu `jakzal/phpqa:alpine` to wystarczy, że wywołamy poniższe polecenie do zainstalowania tego rozszerzenia PHPStan  `composer global bin phpstan require --with-all-dependencies tomasvotruba/type-coverage`. Tworzymy plik o nazwie `phpstan-type-coverage.neon` i wklejamy poniższą konfigurację:

```
parameters:
    customRulesetUsed: true

    paths:
        - src

    type_coverage:
            return_type: 80
            param_type: 80
            property_type: 80
includes:
	- /tools/.composer/vendor-bin/phpstan/vendor/tomasvotruba/type-coverage/config/extension.neon

```

Jeśli analizowanego kodu nie przechowujemy w katalogu `src` to musimy dostosować wartość do naszego projektu.
Wywołujemy polecenie `phpstan analyse --configuration=phpstan-type-coverage.neon`, aby sprawdzić czy mamy wymagane pokrycie kodu typami.

[How to Measure Your Type Coverage](https://tomasvotruba.com/blog/how-to-measure-your-type-coverage/)

### PhpStorm

Do projekt w PhpStorm musimy dodać nowy zdalny interpreter PHP (np. wykorzystując docker-compose).
W pliku `docker-compose.yml` dodajemy definicję usługi `qa`:

```
version: '3.4'
services:
  # ...
  qa:
      image: jakzal/phpqa:alpine
      tty: true
      command:
        - sh
      volumes:
        - ./:/project
```

Następnie [konfigurujemy integrację PHPStan z PHPStorm](https://www.jetbrains.com/help/phpstorm/using-phpstan.html).
W pliku konfiguracyjnym `phpstan.neon` będziemy musieli dodać parametr `bootstrapFiles`, aby PHPStan widział wszystkie klasy ([Discovering Symbols](https://phpstan.org/user-guide/discovering-symbols)) -  Inaczej otrzymamy sporo blędów: `Reflection error: Symfony\Component\Serializer\Normalizer\NormalizerInterface not found.`

```
parameters:
    # ...
    bootstrapFiles:
        - phpstanAutoloader.php
```

Plik `phpstanAutoloader.php` jest bardzo prosty:

```
<?php
require_once __DIR__ . '/vendor/autoload.php';

```

## phpmetrics

`phpmetrics` znajduje się w obrazie dockera `jakzal/phpqa:alpine`, jednak obecnie ze względu na błąd [phpmetrics command with error #311](https://github.com/jakzal/phpqa/issues/311)  ([PhpParser\Lexer::getNextToken(): Return value must be of type int, null returned #459](https://github.com/phpmetrics/PhpMetrics/issues/459)) narzędzie nie działa w tym obrazie.
Musimy zainstalować ręcznie pakiet composera `phpmetrics/phpmetrics`.
Następnie możemy wygenerować raport `vendor/bin/phpmetrics --report-html=./phpmetrics --exclude=tests,vendor,var,bin /path/to/project`

## composer-normalizer

Za pomocą pakietu `ergebnis/composer-normalize` możemy sformatować i znormalizować plik `composer.json`.
Wystarczy wywołać polecenie `composer normalize`. W kluczu `extras` pliku `composer.json` możemy utworzyć konfigurację pakietu:

```
{
  ...
  "extra": {
    "composer-normalize": {
      "indent-size": 2,
      "indent-style": "space"
    }
  }
}
```
W zadaniu Gitlab-CI weryfikujemy czy plik `composer.json` jest poprawnie sformatowany:

```
composer-normalizer:
  stage: qa
  image: jakzal/phpqa:alpine
  script:
    - composer normalize --dry-run
  dependencies: []
```
