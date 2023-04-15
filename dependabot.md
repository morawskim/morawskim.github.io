# Dependabot

Tworzymy plik `dependabot.yml` w katalogu `.github`.
Domyślnie PR będą tworzone na domyślnej gałęzi. Możemy zmienić to zachowanie ustawiając opcję `target-branch` na nazwę docelowej gałęzi:

``` yml
version: 2
updates:
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "weekly"
    # Raise pull requests for version updates
    # to pip against the `develop` branch
    target-branch: "develop"
```

Według dokumentacji obecny limit znaków dla opcji `commit-message.prefix` to 50.
> The prefix and the prefix-development options have a 50 character limit.

Jednak otrzymałem błąd::
> Dependabot encountered the following error when parsing your .github/dependabot.yml:
> The property '#/updates/0/commit-message/prefix' was not of a maximum string length of 15

## Przykładowy plik konfiguracyjny dependabot

[Configuration options for the dependabot.yml file](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file#package-ecosystem)


``` yml
version: 2
updates:
  - package-ecosystem: npm
    directory: "/node-app"
    schedule:
      interval: "weekly"
      day: "thursday"
    commit-message:
      prefix: "[dependabot]"

  - package-ecosystem: composer
    directory: "/php-app"
    target-branch: "develop"
    schedule:
      interval: weekly
      day: "thursday"
    commit-message:
      prefix: "[dependabot]"

  - package-ecosystem: "docker"
    directory: "/php-app"
    schedule:
      interval: weekly
      day: "thursday"
    commit-message:
      prefix: "[dependabot]"

  - package-ecosystem: gomod
    directory: "/go-app"
    schedule:
      interval: weekly
      day: "thursday"
    commit-message:
      prefix: "[dependabot]"

  - package-ecosystem: GitHub-actions
    directory: "/"
    schedule:
      interval: weekly
      day: "thursday"
    commit-message:
      prefix: "[dependabot]"
```
