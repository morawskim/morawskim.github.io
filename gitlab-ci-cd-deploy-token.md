# GitLab CI/CD - deploy token

Deploy token umożliwia nam pobranie repozytorium (przez `git clone`) lub pobranie obrazu z rejestru.
[https://gitlab.com/help/user/project/deploy_tokens/index.md](https://gitlab.com/help/user/project/deploy_tokens/index.md)

## Tworzenie nowego tokenu

1. Logujemy się do gitlaba.
2. Przechodzimy do projektu, w którym chcemy utworzyć token.
3. Z menu wybieramy `Settings > Repository`.
4. Klikamy w `Expand` w sekcji `Deploy Tokens`.
5. Uzupełniamy formularz.
6. Wybieramy uprawnienia tokena (zakres).
7. Klikamy w `Create deploy token`.

Wygenerowany token musimy zapisać w bezpiecznym miejscu.
Nie będziemy mogli ponownie pobrać jego wartości.

## Użycie

W celu sklonowania prywatnego projektu z wykorzystaniem tokenu posługujemy się poleceniem `git clone http://<username>:<deploy_token>@gitlab.example.com/group/project.git`

Aby zalogować się do rejestru obrazów kontenera korzystamy z polecenia `docker login registry.example.com -u <username> -p <deploy_token>` lub `echo "<deploy_token>" | docker login -u "<username>" --password-stdin`

W wersji GitLab 10.8, pojawił się specjalny przypadek. Jeśli utworzymy token o nazwie `gitlab-deploy-token`, wtedy GitLab automatycznie w zadaniach CI/CD  ustawi zmienne środowiskowe `CI_DEPLOY_USER` i `CI_DEPLOY_PASSWORD`. Zakres/Uprawnienie `read_registry` jest przyznawany niejawnie.
