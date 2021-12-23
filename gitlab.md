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

## GitLab CI/CD - deploy token

Deploy token umożliwia nam pobranie repozytorium (przez `git clone`) lub pobranie obrazu z rejestru.
[https://gitlab.com/help/user/project/deploy_tokens/index.md](https://gitlab.com/help/user/project/deploy_tokens/index.md)

### Tworzenie nowego tokenu

1. Logujemy się do gitlaba.
2. Przechodzimy do projektu, w którym chcemy utworzyć token.
3. Z menu wybieramy `Settings > Repository`.
4. Klikamy w `Expand` w sekcji `Deploy Tokens`.
5. Uzupełniamy formularz.
6. Wybieramy uprawnienia tokena (zakres).
7. Klikamy w `Create deploy token`.

Wygenerowany token musimy zapisać w bezpiecznym miejscu.
Nie będziemy mogli ponownie pobrać jego wartości.

### Użycie

W celu sklonowania prywatnego projektu z wykorzystaniem tokenu posługujemy się poleceniem `git clone http://<username>:<deploy_token>@gitlab.example.com/group/project.git`

Aby zalogować się do rejestru obrazów kontenera korzystamy z polecenia `docker login registry.example.com -u <username> -p <deploy_token>` lub `echo "<deploy_token>" | docker login -u "<username>" --password-stdin`

W wersji GitLab 10.8, pojawił się specjalny przypadek. Jeśli utworzymy token o nazwie `gitlab-deploy-token`, wtedy GitLab automatycznie w zadaniach CI/CD  ustawi zmienne środowiskowe `CI_DEPLOY_USER` i `CI_DEPLOY_PASSWORD`. Zakres/Uprawnienie `read_registry` jest przyznawany niejawnie.

## Gitlab CI/CD - rejestracja gitlab-runner

### Rejestracja runnera

Poniższe polecenie rejestruje runnera w gitlabie `https://gitlab.com` wykorzystując `docker` do uruchamiania zadań. Domyślnie (jeśli w definicji zadania nie podano) wykorzystywany będzie obraz `edbizarro/gitlab-ci-pipeline-php:7.2`. Runnerowi nadajemy opis `docker-runner`. Ten worker, nie zawiera przypisanych żadnych tagów i może uruchamiać zadania bez przypisanych tagów. Ten worker, możemy podłączyć do różnych projektów, dzięki parametrowi `--locked="false"`.

```
gitlab-runner register \
  --non-interactive \
  --url "https://gitlab.com/" \
  --registration-token "PROJECT_REGISTRATION_TOKEN" \
  --executor "docker" \
  --docker-image edbizarro/gitlab-ci-pipeline-php:7.2 \
  --description "docker-runner" \
  --run-untagged="true" \
  --locked="false" \
  --access-level="not_protected"
```

[https://docs.gitlab.com/runner/register/index.html](https://docs.gitlab.com/runner/register/index.html)

[https://docs.gitlab.com/runner/configuration/advanced-configuration.html](https://docs.gitlab.com/runner/configuration/advanced-configuration.html)

### Wyrejestrowanie runnera

Do wyrejestrowania runnera służy polecenie `unregister`.
Możemy podać różne parametry np. nazwę runnera czy też token np. `gitlab-runner unregister --name 'MMO docker-runner'`

### Skalowanie (równoległe uruchamianie zadań)

Do głównej sekcji dodajemy klucz `concurrent` np. wartość 3. Ogranicza liczbę zadań globalnie, które mogą być uruchomione jednocześnie.

W sekcji `[[runners]]` dodajemy klucz `limit` z wartością np. `3`.
`limit` ogranicza liczbę zadań, które mogą być obsługiwane jednocześnie przez runner.
W naszym przypadku będą to maksymalnie 3 zadania.

[Runners autoscale configuration ](https://docs.gitlab.com/runner/configuration/autoscale.html)

[How gitlab runner concurrency works?](https://stackoverflow.com/questions/54534387/how-gitlab-runner-concurrency-works)

## gitlab-ci i kaniko - budowanie obrazów dockera

`kaniko` umożliwia nam budowanie obrazów dockera w kontenerze.
Dzięki temu nie musimy odpalać oddzielnego `gitlab-runner`, który uruchamiałby obraz `docker-in-docker` w trybie uprzywilejowanym (privileged). Jak to przedstawia dokumentacja [https://gitlab.com/help/ci/docker/using_docker_build.md#use-docker-in-docker-executor](https://gitlab.com/help/ci/docker/using_docker_build.md#use-docker-in-docker-executor).

Korzystając z `kaniko` w GitLab CI/CD musimy pamiętać o:

* powinniśmy korzystać z obrazu `gcr.io/kaniko-project/executor:debug`. Ten obraz posiada powłokę, a GitLab Ci/CD wymaga powłoki.
* `entrypoint` musi zostać nadpisany.
* Plik `config.json` musi zawierać dane autoryzacyjne do rejestru kontenerów

Przykładowy job dla gitlab-ci

```
build:
  stage: build
  image:
    name: gcr.io/kaniko-project/executor:debug
    entrypoint: [""]
  script:
    - echo "{\"auths\":{\"$CI_REGISTRY\":{\"username\":\"$CI_REGISTRY_USER\",\"password\":\"$CI_REGISTRY_PASSWORD\"}}}" > /kaniko/.docker/config.json
    - /kaniko/executor --context $CI_PROJECT_DIR --dockerfile $CI_PROJECT_DIR/Dockerfile --destination $CI_REGISTRY_IMAGE:$CI_COMMIT_TAG
  only:
    - tags
```

[https://gitlab.com/help/ci/docker/using_kaniko.md](https://gitlab.com/help/ci/docker/using_kaniko.md)

[https://github.com/GoogleContainerTools/kaniko](https://github.com/GoogleContainerTools/kaniko)

## gitlab ci - pobieranie artefaktów zadania

### Wykorzystując token użytkownika

Na początku musimy utworzyć token użytkownika. Logujemy się do gitlaba. Wybieramy nasz profil.
Następnie `Settings` -> `Access Tokens`. Generujemy token wybierając jako zakres opcję `api`.
Wygenerowany token kopiujemy i zapisujemy w bezpiecznym miejscu.

Do pobierania artefaktów posłużymy się programem curl.
Ścieżka do pobierania artefaktów jest następująca:
`/api/v4/projects/ID_PROJEKTU/jobs/artifacts/BRANCH/download?job=JOB_NAME`

Np. aby pobrać artefakt z zadania "composer" z gałęzi "master" projektu o identyfikatorze "40" musimy wywołać polecenie:

`curl  -o OUTPUT.zip --header "PRIVATE-TOKEN: PERSONAL_ACCESS_TOKEN" "https://gitlab.domena.pl/api/v4/projects/40/jobs/artifacts/master/download?job=composer"`

