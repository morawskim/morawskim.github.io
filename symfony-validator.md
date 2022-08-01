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

## Dostęp do aktualnie walidowanego obiektu


W bibliotece `zip-code-validator` znajduje się przykład jak dynamicznie można pobrać dane z obiektu, który jest aktualnie walidowany - `$this->context->getObject()`.

[ZipCodeValidator](https://github.com/barbieswimcrew/zip-code-validator/blob/758b829f08ad3775c6193879a865181c9ca65b9e/src/ZipCodeValidator/Constraints/ZipCodeValidator.php#L233)

```
if (!($iso = strtoupper($constraint->iso))) {
    // if iso code is not specified, try to fetch it via getter from the object, which is currently validated
    $object = $this->context->getObject();
    $getter = $constraint->getter;

    if (!is_callable(array($object, $getter))) {
        $message = 'Method "%s" used as iso code getter does not exist in class %s';
        throw new ConstraintDefinitionException(sprintf($message, $getter, get_class($object)));
    }

    $iso = $object->$getter();
}
```
