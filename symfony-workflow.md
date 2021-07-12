# Symfony Workflow

Pakiet `symfony/workflow` umożliwia nam zbudowanie przepływu pracy (ang. workflow) albo maszynę stanu (ang. state machine).
Różnica między nimi jest raczej symboliczna. Maszyna stanu nie może być w więcej niż jednym miejscu (stanie) w tym samym momencie, a także może mieć ścieżki cykliczne. Zaś przepływ pracy może być w więcej niż jednym miejscu (stanie) w tym samym momencie, a także zazwyczaj nie ma ścieżek cyklicznych.

[W dokumentacji Symfony](https://symfony.com/doc/current/workflow/workflow-and-state-machine.html) mamy przykład użycia. W pliku konfiguracyjnym `config/packages/workflow.yaml` w kluczu `places` definiujemy dostępne stany, w którym może znajdować się nasz obiekt. Zaś w kluczu `transitions` definiujemy dostępne transakcję między stanami.

Wywołując polecenie ` ./bin/console debug:container workflow` możemy poznać nazwę zarejestrowanej usługi, którą możemy wstrzyknąć np. `Symfony\Component\Workflow\WorkflowInterface $orderStateMachine`.

Wywołując metodę `getEnabledTransitions` jesteśmy w stanie pobrać dozwolone przejścia dla obecnego stanu podmiotu. Ta metoda może się przydać do zaimplementowania walidatora dozwolonych przejść stanu w przypadku aplikacji REST.

Dodatkową za pomocą rozszerzenia `WorkflowExtension` za pomocą funkcji Twig `workflow_can`, możemy ukrywać/pokazywać pewne przyciski do wyzwalania przejść, jeśli dany docelowy stan jest dozwolony.
