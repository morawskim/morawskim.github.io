# gitlab ci - snippets

## Śledzenie (debugowanie)
Domyślnie GitLab Runner ukrywa większość szczegółów tego, co robi podczas przetwarzania zadania.
Jeśli zadanie nie działa jak oczekujemy, możemy mieć problem z zbadaniem przyczyny błędu.
Jednak w takim przypadku możemy włączyć tryb śledzenia w pliku `.gitlab-ci.yml`.
Aby włączyć ten tryb ustawiamy zmienną `CI_DEBUG_TRACE` na wartość `true` w konfiguracji zadania.

```
job_name:
    variables:
        CI_DEBUG_TRACE: "true"
```

https://docs.gitlab.com/ee/ci/variables/#debug-tracing

## Tymczasowe wyłączenie zadania w potoku

Zamiast komentować i kasować cały fragment z konfiguracją zadania w potoku możemy dodać znak `.` przed nazwą zadania.
Np. `.phpunit`.Dzięki temu zadanie `phpunit` nie zostanie wywołane.

## Pominięcie potoku

Jeśli w treści wiadomości komita znajdzie się fraza `[ci skip]` or `[skip ci]` to potok nie zostanie uruchomiony.

https://docs.gitlab.com/ee/ci/yaml/#skipping-jobs

## Warunkowe uruchomienie zadania w potoku

### Na podstawie wartości zmiennej

```
job:
    except:
        variables:
            - $CI_COMMIT_MESSAGE =~ /skip-ci/
```
Jeśli w treści komita, podamy frazę `skip-ci`, zadanie nie zostanie wykonane.

### Uruchomienie zadania, jeśli plik został zmodyfikowany

Ta funkcjonalność jest dostępna tylko dla GitLab w wersji 11.4 i wyższej.
https://docs.gitlab.com/ee/ci/yaml/#onlychangesexceptchanges

```
job:
  script: docker build -t my-image:$CI_COMMIT_REF_SLUG .
  only:
    changes:
      - Dockerfile
      - "dockerfiles/**/*"
```

Dla wcześniejszych wersji GitLaba można użyć poniższej konfiguracji
```
job:
  script:
    - |
      if git diff --name-only --diff-filter=ADMR @~..@ |grep ^Dockerfile; then
            echo "triggering..."
      fi
```

### Na podstawie warunku

```
job:
  script:
    - |
      if [ "$CI_BUILD_REF_NAME" != "develop" ]; then
        echo "Skipping job for non-develop branch $CI_BUILD_REF_NAME"
        exit 0
      fi
```
