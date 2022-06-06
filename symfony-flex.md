# Symfony/Flex - własne repozytorium z przepisami

`symfony/flex` wykorzystuje przepisy (ang. Recipe) do konfiguracji bundli Symfony.
Obecnie w łatwy sposób możemy dodać własne repozytorium z przepisami.
Dzięki temu, możemy przechowywać konfigurację standardu kodowania w oddzielnym pakiecie i podłączyć go do projektu PHP za pomocą `symfony/flex`.

Jak skonfigurować flex z zewnętrznym repozytorium opisane jest w dokumentacji - [How To Configure and Use Flex Private Recipe Repositories](https://symfony.com/doc/5.4/setup/flex_private_recipes.html).

Do korzystania z repozytorium z przepisami flexa potrzebny jest token autoryzacyjny. W zależności czy nasze repo jest publiczne , czy też prywatne nasz token musi mieć odpowiedni zestaw uprawnień. Token możemy zapisać poprzez wywołanie polecenia `composer config --global --auth github-oauth.github.com [token]`.
W przypadku jednak projektów firmowych, które korzystają z github/gitlab/bitbucket taki token często jest osadzany bezpośrednio w pliku `composer.json`. Opisane jest to w dokumentacji composer - [Authentication for privately hosted packages and repositories](https://getcomposer.org/doc/articles/authentication-for-private-packages.md)

W takim przypadku w pliku `composer.json` powinniśmy dodać klucz `config` z taką zawartością:

```
"config": {
    "github-oauth": {
        "github.com": "XXXXXXXXXXXXXXXXXXXXXX"

    }
},
```

Chcąc tworzyć własne przepisy możemy wzorować się na gotowych dostępnych w repozytorium [symfony/recipes](https://github.com/symfony/recipes/tree/flex/main).
Mając już repozytorium z przepisami wystarczy tylko dodać konfigurację końcówek flex zgodnie z dokumentacją [Configure Your Project's composer.json File](https://symfony.com/doc/5.4/setup/flex_private_recipes.html#configure-your-project-s-composer-json-file).

```
{
    "extra": {
        "symfony": {
            "endpoint": [
                "https://api.github.com/repos/your-github-account-name/your-recipes-repository/contents/index.json",
                "flex://defaults"
            ]
        }
    }
}
```

Podłączając moje repozytorium z przepisami możemy wywołać polecenie `composer require --dev mmo/coding-standards`. Polecenie to zainstaluje także pakiet `friendsofphp/php-cs-fixer` i utworzy domyślny plik konfiguracji, który dziedziczy zasady kodowania z pakietu `mmo/coding-standards`.

Jeśli z jakiegoś powodu chcielibyśmy debugować plugin flex to musimy pamiętać, że `composer` ma wbudowaną funkcję do wyłączania rozszerzenia xdebug. Musimy ustawić zmienną środowiskową `COMPOSER_ALLOW_XDEBUG=1` inaczej nie będziemy w stanie debugować kodu pluginu flex np. `COMPOSER_ALLOW_XDEBUG=1 composer recipes`.

## Pobieranie przepisów z innego brancza niż domyślny

Domyślnie flex pobiera przepisy z domyślnego brancha repozytorium.
Tworząc oddzielny branch możemy przetestować nowe przepisy nie powodując problemów w innych projektach.
W repozytorium z przepisami edytujemy plik `index.json`. Musimy zmodyfikować klucze `branch`, `origin_template` i `recipe_template`.
Dla dwóch pierwszych kluczy zmieniamy po prostu wartość na nową nazwę brancza. W przypadku repozytorium hostowanym w GitHub dodajemy parametr GET `ref=nazwa-brancza` do klucza `recipe_template`.

```
{
    "recipes": {
        ....
    },
    "branch": "test",
    "is_contrib": true,
    "_links": {
        "repository": "github.com/morawskim/symfony-recipes",
        "origin_template": "{package}:{version}@github.com/morawskim/symfony-recipes:test",
        "recipe_template": "https://api.github.com/repos/morawskim/symfony-recipes/contents/{package_dotted}.{version}.json?ref=test"
    }
}
```

Następnie w projekcie, w którym chcemy przetestować nasz nowy przepis modyfikujemy plik `composer.json`.
Do endpointu flex dodając parametr `ref=nazwa-brancza` (w przypadku repozytorium hostowanym w GitHub).

```
{
    ....
     "extra": {
        "symfony": {
            "endpoint": [
                "https://api.github.com/repos/morawskim/symfony-recipes/contents/index.json?ref=test",
                "flex://defaults"
            ]
        }
    },
    ....
    }
}

```
