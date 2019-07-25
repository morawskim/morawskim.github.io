# Gitlab CI/CD - rejestracja gitlab-runner

## Rejestracja runnera

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

## Wyrejestrowanie runnera

Do wyrejestrowania runnera służy polecenie `unregister`.
Możemy podać różne parametry np. nazwę runnera czy też token np. `gitlab-runner unregister --name 'MMO docker-runner'`

## Skalowanie (równoległe uruchamianie zadań)

Do głównej sekcji dodajemy klucz `concurrent` np. wartość 3. Ogranicza liczbę zadań globalnie, które mogą być uruchomione jednocześnie.

W sekcji `[[runners]]` dodajemy klucz `limit` z wartością np. `3`.
`limit` ogranicza liczbę zadań, które mogą być obsługiwane jednocześnie przez runner.
W naszym przypadku będą to maksymalnie 3 zadania.

[Runners autoscale configuration ](https://docs.gitlab.com/runner/configuration/autoscale.html)

[How gitlab runner concurrency works?](https://stackoverflow.com/questions/54534387/how-gitlab-runner-concurrency-works)
