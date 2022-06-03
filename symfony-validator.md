# Symfony/Validator

## Callback walidator i dynamiczne constraints

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
