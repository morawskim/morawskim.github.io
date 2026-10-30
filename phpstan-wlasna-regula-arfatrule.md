# PHPStan - własna reguła ArFatRule

W projekcie korzystaliśmy z modeli ActiveRecord, które zawierały sporo logiki biznesowej, między innymi w metodach takich jak beforeValidate czy afterSave.
Zdecydowaliśmy się więc utworzyć nowe modele, które nie zawierałyby tej logiki.
Logika biznesowa miała zostać przeniesiona do rozwiązania bardziej zgodnego z podejściem DDD.

Wykorzystalibyśmy w tym celu agregaty i Value Objects, a zapis do bazy danych odbywałby się finalnie za pomocą modeli ActiveRecord.
Jak to jednak często bywa, zmieniły się priorytety i w systemie zaczęły funkcjonować równolegle zarówno "stare", jak i nowe modele.

Część programistów korzystała z nowych modeli, podczas gdy inni nadal używali starych, które nie zostały skasowane.

Powodowało to chaos, a w pewnych sytuacjach również błędy w działaniu systemu.
Przykładowo, niektóre mechanizmy nie uruchamiały się, mimo że powinny — ponieważ relacje odwoływały się do nowych modeli AR.

Trzeba było więc posprzątać ten "śmietnik".
Zdecydowałem się wykorzystać PHPStan, który mógł pomóc w stopniowym uporządkowaniu tego problemu.

Zbudowałem własną regułę PHPStan, która zgłaszała błąd, jeśli w kodzie znaleziono odwołanie do wybranej klasy ActiveRecord.
Wywoływanie metod oraz korzystanie z właściwości takiego modelu również było raportowane jako błąd.
Dzięki temu mogliśmy stopniowo usuwać odwołania do starych modeli i mieć pewność, że nowe fragmenty kodu nie będą ponownie z nich korzystać.


Instalujemy pakiet PHPStan -  `composer require --dev phpstan/phpstan`

Następnie tworzymy plik phpstan.neon: `phpstan.neon`

```
parameters:
    level: 3
    paths:
        - ../../api
    bootstrapFiles:
        - phpstan-bootstrap.php
    excludePaths:
        - ../../api/tests/*

services:
    -
        class: \common\services\ArFatRule
        tags:
            - phpstan.restrictedClassNameUsageExtension
```

Tworzymy regułę:

```
class ArFatRule implements RestrictedClassNameUsageExtension
{
    private static $forbiddenClassess = [
        AppAsset::class,
    ];

    public function isRestrictedClassNameUsage(ClassReflection $classReflection, Scope $scope, ClassNameUsageLocation $location): ?\PHPStan\Rules\RestrictedUsage\RestrictedUsage
    {
        if (!in_array($classReflection->getName(), self::$forbiddenClassess)) {
            return null;
        }

        return RestrictedUsage::create(
            $location->createMessage(sprintf(
                    'internal ActiveRecord %s %s',
                    strtolower($classReflection->getClassTypeDescription()), $classReflection->getDisplayName())
            ),
            $location->createIdentifier(sprintf('internal%s', $classReflection->getClassTypeDescription())),
        );
    }
}
```

Na koniec dodajemy uruchamianie PHPStan do Makefile:

```
phpstan:
	@vendor/bin/phpstan clear-result-cache
	@vendor/bin/phpstan analyse -c infra/phpstan/phpstan.neon --autoload-file infra/phpstan/autoload.php
```
