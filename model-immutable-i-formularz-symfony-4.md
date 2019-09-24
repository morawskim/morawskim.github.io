# Model immutable i formularz symfony 4

Obiekt niezmienny to taki, który nie może zmienić swojego stanu. Każda zmiana stanu powoduje utworzenie nowego obiektu. `Value objects` są obiektami niezmiennymi.

W projekcie postanowiłem utworzyć model `DateRange` jako immutable. Przechowuje on datę początkową i końcową.
Nie zawiera on setterów. Dodatkowo przekazane obiekty dat muszą być niemodyfikowalne (immutable), aby nie można było ich zmienić po pobraniu referencji przez akcesory.

Komponent formularzy Symfony4 domyslnie nie obsługuje modeli immutable.
Rozwiązaniem tego problemu jest stworzenie własnego `Data mappers` lub implementacja `DataTransformerInterface`.

`Data mappers` są odpowiedzialne za odczytanie i zapisanie danych formularza i formularzy rodzica.

> The main built-in data mapper uses the PropertyAccess component and will fit most cases. However, you can create your own implementation that could, for example, pass submitted data to immutable objects via their constructor.
https://symfony.com/doc/current/form/data_mappers.html

`DataTransformerInterface` odpowiadają zaś za zmianę formy reprezentacji np. z ciągu znaków "2018-05-20" na obiekt `DateTime`.

W tym przypadku, poniewaz korzystam z obiektów `DateTimeImmutable` wybrałem drugie rozwiązanie.

Utworzyłem `DateRangeTransformer`
W przykładzie nie mamy walidacji poprawności wprowadzonych danych.
Nasz transformer wymaga podania poprawnych danych, inaczej dostaniemy błąd.

``` php
class DateRangeTransformer implements DataTransformerInterface
{
    public function transform($value)
    {
        if (null === $value) {
            return null;
        }

        if ($value instanceof DateRange) {
            return $value;
        }

        throw new UnexpectedTypeException($value, DateRange::class);
    }

    public function reverseTransform($value)
    {
        if (is_string($value)) {
            return $this->parseInputString($value);
        }

        if (null === $value) {
            return null;
        }

        throw new UnexpectedTypeException($value, 'string');
    }

    private function parseInputString(string $input): DateRange
    {
        $dates = explode(' - ', $input, 2);
        if (count($dates) !== 2) {
            throw new UnexpectedTypeException($input, 'string');
        }
        $dates = array_map('trim', $dates);

        $from = \DateTimeImmutable::createFromFormat('Y-m-d', $dates[0]);
        $to = \DateTimeImmutable::createFromFormat('Y-m-d', $dates[1]);

        return new DateRange($from, $to);
    }
}
```

Dla formularza trzeba ustawić opcję `empty_data` na wartość `null`, inaczej symfony będzie starało się utworzyć nasz model, gdy nie mamy danych i dostaniemy błąd - `Too few arguments to function App\Model\DateRange::__construct(), 0 passed in /app/vendor/symfony/form/Extension/Core/Type/FormType.php on line 136 and exactly 2 expected`

W kontrolerze zaimplementowałem standardowy kod obsługi formularza:
```
$filter = new ArticleFilter();
$form = $this->createForm(ArticleFilterType::class, $filter, ['method' => 'GET']);
$form->handleRequest($request);
```

https://symfony.com/doc/current/form/data_mappers.html

https://webmozart.io/blog/2015/09/09/value-objects-in-symfony-forms/

https://symfony.com/doc/current/form/embedded.html

https://symfony.com/doc/current/form/data_transformers.html