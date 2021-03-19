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
