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
