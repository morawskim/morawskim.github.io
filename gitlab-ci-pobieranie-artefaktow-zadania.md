# gitlab ci - pobieranie artefaktów zadania

## Wykorzystując token użytkownika

Na początku musimy utworzyć token użytkownika. Logujemy się do gitlaba. Wybieramy nasz profil.
Następnie `Settings` -> `Access Tokens`. Generujemy token wybierając jako zakres opcję `api`.
Wygenerowany token kopiujemy i zapisujemy w bezpiecznym miejscu.

Do pobierania artefaktów posłużymy się programem curl.
Ścieżka do pobierania artefaktów jest następująca:
`/api/v4/projects/ID_PROJEKTU/jobs/artifacts/BRANCH/download?job=JOB_NAME`

Np. aby pobrać artefakt z zadania "composer" z gałęzi "master" projektu o identyfikatorze "40" musimy wywołać polecenie:

`curl  -o OUTPUT.zip --header "PRIVATE-TOKEN: PERSONAL_ACCESS_TOKEN" "https://gitlab.domena.pl/api/v4/projects/40/jobs/artifacts/master/download?job=composer"`
