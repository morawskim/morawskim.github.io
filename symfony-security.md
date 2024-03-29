# symfony/security

## UserProviderInterface

Klasy implementujące interfejs
`\Symfony\Component\Security\Core\User\UserProviderInterface` umożliwiają
pobranie użytkownika z jakiegoś źródła. Symfony dostarcza kilka implementacji.
Najczęściej korzystamy z implementacji `EntityUserProvider`, który pobiera
użytkownika z bazy danych. W domyślnej konfiguracji (wygenerowanej przez
polecenie `make:user`) użytkownik pobierany jest po określonym polu. Kasując
ten parametr z konfiguracji i implementując interfejs
`\Symfony\Bridge\Doctrine\Security\User\UserLoaderInterface` na klasie
repozytorium możemy utworzyć własne zapytanie do pobrania użytkownika
wykorzystujące wiele pól. Nasz provider może także implementować interfejs
`\Symfony\Component\Security\Core\User\PasswordUpgraderInterface`, aby
uaktualnić hasło użytkownika nowym algorytmem haszującym

Wywołując polecenie `php bin/console debug:container user.provider` możemy
wyświetlić listę dostępnych providerów. Usługi zgodne z wzorcem
`security.user.provider.concrete.<provider>` możemy wstrzykiwać do innych
usług.

[Using a Custom Query to Load the User](https://symfony.com/doc/current/security/user_provider.html#using-a-custom-query-to-load-the-user)
[EntityUserProvider](https://github.com/symfony/doctrine-bridge/blob/b8c1485e3a12dda96aa2f40c6f12a109710adcc3/Security/User/EntityUserProvider.php#L52)

## EquatableInterface

Interfejs `\Symfony\Component\Security\Core\User\EquatableInterface` umożliwia implementację własnego algorytmu porównania użytkownika. W zależności od konfiguracji firewalla Symfony może serializować obiekt użytkownika (`UserInterface`) do sesji na końcu żądania HTTP. Klasa `\Symfony\Component\Security\Http\Firewall\ContextListener` na początku obsługi kolejnego żądania deserializuje użytkownika i Symfony próbuje odświeżyć dane użytkownika. Zajmuje się tym metoda [refreshUser](https://github.com/symfony/symfony/blob/1b937403255c9f841d6597b2bcefc0e93fe51545/src/Symfony/Component/Security/Http/Firewall/ContextListener.php#L195)

Metoda [\Symfony\Component\Security\Core\Authentication\Token\AbstractToken::hasUserChanged](https://github.com/symfony/symfony/blob/1b937403255c9f841d6597b2bcefc0e93fe51545/src/Symfony/Component/Security/Core/Authentication/Token/AbstractToken.php#L256) deleguje porównanie dwóch obiektów użytkownika lub wykorzystywana jest domyślna implementacja. Jeśli dane są różne, użytkownik zostanie wylogowany. Zwiększa to bezpieczeństwo aplikacji.

## UserCheckerInterface

Podczas uwierzytelniania użytkownika możemy potrzebować sprawdzić dodatkowe warunki, aby określić czy użytkownik może się zalogować (np. czy konto ciągle jest aktywne). Wyjątek `AccountStatusException` jest bazową klasą dla wyjątków związanych ze stanem konta użytkownika. Nasza usługa musi implementować interfejs `\Symfony\Component\Security\Core\User\UserCheckerInterface`. W konfiguracji firewall ustawiamy wartość parametru `user_checker` na naszą usługę.

[How to Create and Enable Custom User Checkers](https://symfony.com/doc/current/security/user_checkers.html)

## Internal

Klasa `\Symfony\Component\Security\Core\Security` daje nam łatwy dostęp do często potrzebnych zadań zwianych z bezpieczeństwem.

Interfejs `\Symfony\Component\Security\Core\Authorization\AuthorizationCheckerInterface` umożliwia nam weryfikowanie czy zalogowany użytkownik posiada uprawnienia do wykonania akcji.

Interfejs `\Symfony\Component\Security\Core\Authorization\AccessDecisionManagerInterface` decyduje o tym, czy dostęp jest możliwy, czy nie. Symfony dostarcza kilka strategii (affirmative, consensus i unanimous).

Implementując interfejs `\Symfony\Component\Security\Http\Authorization\AccessDeniedHandlerInterface` możemy zaimplementować dowolną logikę, która powinna zostać wykonana w przypadku odmowy dostępu dla bieżącego użytkownika. Symfony nie dostarcza domyślnej implementacji. Interfejs ten używany jest w `\Symfony\Component\Security\Http\Firewall\ExceptionListener`.

Dziedzicząc po klasie `\Symfony\Component\Security\Guard\AbstractGuardAuthenticator` możemy utworzyć własny Guard (np. autentykacja w oparciu o token w nagłówku HTTP).
