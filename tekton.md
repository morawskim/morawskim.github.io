# Tekton

## Troubleshoot

### Brak zadań w Tekton Dashboard

Tekton w wersji 0.42.0 zainstalowałem korzystając z helm (była to najnowsza dostępna wersja).
Kokipit zainstalowałem zgodnie z [instrukcją](https://github.com/tektoncd/dashboard/blob/main/docs/install.md#installing-tekton-dashboard-on-kubernetes) w wersji v0.53.0.

Próbując wyświetlić listę zadań, otrzymywałem brak zadań.
Uruchamiając w przeglądarce narzędzia deweloperskie zauważyłem, że lista zadań pobierana jest z endpointu `/apis/tekton.dev/v1/namespaces/tekton-pipelines/tasks/`.
Response wskazywał raczej na błąd 404 "kontrolera ingress" niż tektona.

Przechodząc na adres `/apis/tekton.dev` nie widziałem wersji v1. Były dostępna wersja `v1beta1`.
Przeglądając [kod](https://github.com/tektoncd/dashboard/blob/3f56be402e01c45b3803f5d2e32f576df2f3d98d/src/api/utils.js#L104)
natrafiłem na fragment który decydował, czy dashboard powinien korzystać z wersji v1 czy v1beta1.

W narzędziach developerskich ustawiłem klucz w localStorage:
`localStorage.setItem('tkn-pipelines-v1-resources', false)`

Po tej zmianie lista zadań tektona wyświetliła się poprawnie.

[Add toggle to settings UI to opt-in to Pipelines v1 resources](https://github.com/tektoncd/dashboard/pull/2649)

### failed to create task run

Utworzyłem zasób Task w przestrzeni nazw `tekton-pipelines`.
Przy wywoływaniu tego zadania otrzymałem błąd:

> failed to create task run pod "hello-run-1734341599166": pods "hello-run-1734341599166-pod" is forbidden: violates PodSecurity
"restricted:latest": allowPrivilegeEscalation != false (containers "prepare", "place-scripts", "step-echo" must set
securityContext.allowPrivilegeEscalation=false), unrestricted capabilities (containers "prepare", "place-scripts", "step-echo" must set
securityContext.capabilities.drop=["ALL"]), runAsNonRoot != true (pod or containers "prepare", "place-scripts", "step-echo" must set
securityContext.runAsNonRoot=true), seccompProfile (pod or containers "prepare", "place-scripts", "step-echo" must set
securityContext.seccompProfile.type to "RuntimeDefault" or "Localhost"). Maybe missing or invalid Task tekton-pipelines/hello

Rozwiązanie tego problemu, to utworzenie zadania w innej przestrzeni nazw np. `tekton`.

[securityContext of init containers contradicts new PodSecurity requirements]https://github.com/tektoncd/pipeline/issues/5896#issuecomment-1381177519
