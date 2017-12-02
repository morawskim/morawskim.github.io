# composer - aktualizacja pakietu

Podczas wywoływania polecenia `composer install` otrzymałem błąd:

```
composer install
Loading composer repositories with package information
Installing dependencies (including require-dev) from lock file
Your requirements could not be resolved to an installable set of packages.

  Problem 1
    - Installation request for doctrine/instantiator 1.1.0 -> satisfiable by doctrine/instantiator[1.1.0].
    - doctrine/instantiator 1.1.0 requires php ^7.1 -> your PHP version (7.0.21) does not satisfy that requirement.
  Problem 2
    - doctrine/instantiator 1.1.0 requires php ^7.1 -> your PHP version (7.0.21) does not satisfy that requirement.
    - phpspec/prophecy 1.7.3 requires doctrine/instantiator ^1.0.2 -> satisfiable by doctrine/instantiator[1.1.0].
    - Installation request for phpspec/prophecy 1.7.3 -> satisfiable by phpspec/prophecy[1.7.3].
```

Jak się okazało pakiety zostały zaktualizowane na środowisku, gdzie był zainstalowany php 7.1.
Projekt wymagał PHP w wersji 7.0. Musiałem, wiec zaktualizować problematyczne pakiety.
```
composer update --with-dependencies phpspec/prophecy doctrine/instantiator
```

Po aktualizacji wersja pakietu doctrine/instantiator się zmieniła.
```
composer show doctrine/instantiator
name     : doctrine/instantiator
descrip. : A small, lightweight utility to instantiate objects in PHP without invoking their constructors
keywords : constructor, instantiate
versions : * 1.0.5
```
