# php-cs-fixer

`php-cs-fixer` to narzędzie do automatycznego formatowania oraz poprawiania stylu kodu PHP.

Polecenie `composer require --dev friendsofphp/php-cs-fixer` instaluje php-cs-fixer w projekcie. Domyślnie php-cs-fixer ignoruje katalog `vendor/`.

## Użycie

Sprawdzenie zgodności ze standardem (bez wprowadzania zmian): `vendor/bin/php-cs-fixer check`

Automatyczne wprowadzenie poprawek: `vendor/bin/php-cs-fixer fix`.

Podgląd zmian bez ich zapisywania: `vendor/bin/php-cs-fixer fix --dry-run --diff`

## Projekt legacy

W istniejących projektach (legacy), gdzie wprowadzenie standardu oznaczałoby sformatowanie tysięcy plików, są dwa podejścia:

* jednorazowe sformatowanie całego projektu.
* wymaganie zgodności tylko dla plików zmodyfikowanych, dodanych lub przeniesionych w danym PR.

Aby pobrać listę zmodyfikowanych plików PHP względem origin/main, można użyć polecenia: `git diff --name-only --diff-filter=AMR origin/main...HEAD | grep -E '.php$'`

Wynik polecenia można zapisać w zmiennej środowiskowej. Plik konfiguracyjny php-cs-fixer może następnie odczytać wartość tej zmiennej i na jej podstawie ograniczyć analizę wyłącznie do wskazanych plików (zmodyfikowanych w ramach danego PR).

`export FILES_TO_CHECK=$(git diff --name-only --diff-filter=AMR origin/main...HEAD | grep -E '.php$')`

Przykładowy plik konfiguracyjny `.php-cs-fixer.dist.php`:

```
<?php

$finder = (new PhpCsFixer\Finder())
    ->in(__DIR__)
    ->exclude([
        # ...
        'resources/',
    ])
;

$filesToCheck = $_SERVER['FILES_TO_CHECK'] ?? '';
if (!empty($filesToCheck)) {
    $finder->path(array_map(static fn(string $file) => trim($file), explode("\n", $filesToCheck)));
}

return (new PhpCsFixer\Config())
    ->setRules([
        '@PER-CS3.0' => true,
        //'@PHP84Migration' => true,
    ])
    ->setFinder($finder)
;

```

### Bitbucket Pipelines

W przypadku CI opartego o Bitbucket Pipelines, w pipeline uruchomionym dla PR można skorzystać ze zmiennej środowiskowej: `BITBUCKET_PR_DESTINATION_BRANCH`. Pozwala ona dynamicznie określić gałąź docelową PR i porównać zmiany względem niej.

```
definitions:
  steps:
    - step: &phpCsFixer
        name: Run php-cs-fixer
        image: thecodingmachine/php:8.4-v5-cli
        script:
          - git config --global --add safe.directory $PWD
          - echo BITBUCKET_PR_DESTINATION_BRANCH - $BITBUCKET_PR_DESTINATION_BRANCH
          - export FILES_TO_CHECK=$(git diff --name-only --diff-filter=AMR origin/$BITBUCKET_PR_DESTINATION_BRANCH...HEAD | grep -E '.php$')
          - echo "$FILES_TO_CHECK"
          - vendor/bin/php-cs-fixer check
```

### Makefile

```
TARGET_BRANCH ?= origin/main

.PHONY: fix-code-style
fix-code-style:
	export FILES_TO_CHECK="$$(git diff --name-only --diff-filter=AMR $(TARGET_BRANCH)...HEAD | grep -E '\.php$$')" && \
		vendor/bin/php-cs-fixer fix

```

## PHPStorm

[Dokumentacja PHPStorm](https://www.jetbrains.com/help/phpstorm/using-php-cs-fixer.html)
