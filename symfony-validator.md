# Symfony/Validator

## Callback walidator i kontekst

Często musimy dokonać walidacji na podstawie innych parametrów.
Idealnie do tego nadaje się do constraint - `Callback`.
W wywoływanej metodzie walidacji możemy cały czas korzystać z wbudowanych (i nie tylko) walidatorów Symfony.
Musimy tylko ustawić context i ścieżkę jak w poniższym przykładzie.

```
# ...
if (isset($this->subject) && SubjectEnum::CUSTOM_PROPERTY === $this->subject) {
    $validator = $context->getValidator()->inContext($context);
    $validator->atPath('symbol')->validate($this->symbol, [new Assert\NotBlank()]);
}
```

Dzięki temu, jeśli w naszym DTO właściwość `subject` przyjmie wartość enum `CUSTOM_PROPERTY` to uruchamiany jest walidator sprawdzający, czy pole `symbol` nie jest puste.
Jeśli pole jest puste zostanie dodany błąd walidacji do pola `symbol`.

## Testy

Klasa `ArrayConstraintValidatorFactory` tworzy anonimową klasę, która implementuje interfejs `Symfony\Component\Validator\ConstraintValidatorFactoryInterface` i umożliwia nam przekazanie instancji walidatorów.
W frameworku Symfony walidatory są pobierane z service container (klasa `Symfony\Component\Validator\ContainerConstraintValidatorFactory`).

```
class ArrayConstraintValidatorFactory
{
    public static function create(array $extraValidators): ConstraintValidatorFactoryInterface
    {
        return new class($extraValidators) extends ConstraintValidatorFactory {
            public function __construct(array $validators)
            {
                parent::__construct();

                $this->validators = $validators;
            }
        };
    }
}

```

W testach musimy także utworzyć usługę do walidacji, która będzie wykorzystywać utworzoną fabrykę.

```
Validation::createValidatorBuilder()
    ->enableAnnotationMapping()
    ->setConstraintValidatorFactory(ArrayConstraintValidatorFactory::create($validatorsMap))
    ->getValidator();

```

Argument `$validatorsMap` to tablica. Klucz to nazwa klasy walidatora (Constraint ma metodę validatedBy, która zwraca nazwę klasy walidatora), a wartość to instancja walidatora np. `My\Namespace\FooValidator::class => $fooValidatorInstance`. Domyślna implementacja metody `validatedBy` wygląda następująco:

```
public function validatedBy()
{
    return static::class.'Validator';
}
```
