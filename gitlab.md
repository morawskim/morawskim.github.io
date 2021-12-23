# GitLab

## GitLab repozytorium composer

GitLab może pełnić rolę repozytorium prywatnych pakietów dla composera. Projekt musi mieć włączoną funkcję Packages i CI/CD (sekcja `Visibility, project features, permissions` w `Settings → General`). Więcej informacji o wymaganiach wstępnych jest w dokumentacji - [Composer packages in the Package Registry](https://docs.gitlab.com/ee/user/packages/composer_repository/) i artykule -  [Private Composer Repositories with GitLab](https://php.watch/articles/composer-gitlab-repositories). Należy tylko pamiętać że obecnie możemy opublikować własne pakiety composera tylko w przestrzeni grupy - [Publish composer packages to a project without a group](https://gitlab.com/gitlab-org/gitlab/-/issues/235467). Innym słowem nie możemy opublikować ich w ramach przestrzeni użytkownika.

Do automatyzacji publikowania pakietu korzystamy z poniższej definicji zadania CI/CD. Nie musimy tworzyć Personel Access Token.

```
stages:
  - deploy
# ...

publish:
  image: curlimages/curl:latest
  stage: deploy
  only:
    - tags
  script:
    - 'curl -sS --show-error --header "Job-Token: $CI_JOB_TOKEN" --data tag=${CI_COMMIT_TAG} "${CI_API_V4_URL}/projects/$CI_PROJECT_ID/packages/composer"'
```

W celu pobrania pakietu dodajemy do pliku `composer.json` klucz `repositories`.
```
{
    "repositories": [
        {
            "type": "composer",
            "url": "https://gitlab.domain.com/api/v4/group/<GROUP_ID>/-/packages/composer/packages.json"
        }
    ]
}
```

W przypadku prywatnego repozytorium potrzebujemy personal access token lub deploy token ([Use Deploy tokens to grant access to the Composer registry](https://gitlab.com/gitlab-org/gitlab/-/issues/240897)). Choć w moim przypadku Deploy token nie chciał działać. Mając token wywołujemy polecenie `composer config http-basic.gitlab.domain.com userNotImportant <ACCESS_TOKEN>`.
W przypadku prywatnej instancji GitLab musimy podać adres do naszej instancji jak w przykładzie powyżej - `gitlab.domain.com`.
Zostanie utworzony plik `auth.json`, który jest prywatny i należy dodać go do ignorowanych w `.gitignore`.
