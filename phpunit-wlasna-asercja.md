# PHPUnit - własna asercja

PHPUnit możemy rozszerzyć o własne asercje i constraints. Frameworki PHP takie jak Laravel, czy Symfony korzystają z tej możliwości i dostarczają choćby dodatkowe asercje dla testów integracyjnych. Mając własny value object możemy zbudować dla niego asercje.

Tworzymy uproszczony VO `Box`. Zawiera on metodę sprawdzającą czy dwa obiekty `Box`, reprezentują tą samą wartość (przez metodę `isEqual`).

``` php
<?php

namespace App\ValueObject;

class Box
{
    /** @var int */
    private $season;
    /** @var int */
    private $box;

    public function __construct(int $season, int $box = null)
    {
        $this->season = $season;
        $this->box = 0 === $box ? null : $box;
    }

    /**
     * @return int
     */
    public function getSeason(): int
    {
        return $this->season;
    }

    public function getBox(): ?int
    {
        return $this->box;
    }

    public function isEqual(Box $box): bool
    {
        return $box->getSeason() === $this->getSeason() && $box->getBox() === $this->getBox();
    }

    public function isNull(): bool
    {
        return $this->isEqual(new Box(1, null));
    }

    public function __toString()
    {
        return $this->getSeason() . '-' . $this->getBox();
    }
    #.....
}

```

Tworzymy constraint `BoxConstraint`. Klasa ta musi dziedziczyć po `PHPUnit\Framework\Constraint\Constraint`. Definiujemy metody `matches` i `toString`. Aby mieć inny komunikat w przypadku błędu nadpisujemy metodę `failureDescription`.


```
class BoxConstraint extends Constraint
{
    /**
     * @var Box
     */
    private $expectBox;

    public function __construct(Box $expectBox)
    {
        parent::__construct();
        $this->expectBox = $expectBox;
    }

    /**
     * @param Box $other
     * @return bool
     */
    protected function matches($other): bool
    {
        return $this->expectBox->isEqual($other);
    }

    public function toString(): string
    {
        return sprintf('has value "%s"', $this->expectBox);
    }

    /**
     * @param Box $other
     *
     * {@inheritdoc}
     */
    protected function failureDescription($other): string
    {
        return 'the Box ' . $this->toString();
    }
}
```

Następnie tworzymy trait `BoxAssertTrait`. I definujemy metodę `assertBoxIsEqual`

```
public static function assertBoxIsEqual(Box $expectedBox, Box $actualBox): void
    {
        Assert::assertThat(
            $actualBox,
            new BoxConstraint($expectedBox)
        );
    }
```

Dołączając trait `BoxAssertTrait` do TestCase jesteśmy w stanie zweryfikować czy aktualna wartość obiektu `Box` odpowiada oczekiwanej wartości.

[Constraints symfony/http-foundation](https://github.com/symfony/http-foundation/tree/5139321b2b54dd2859540c9dbadf6fddf63ad1a5/Test/Constraint)

[Asercje w laravel/dusk](https://github.com/laravel/dusk/blob/725f9c05c14f42c9e6e518e3140c1534d97d7536/src/Concerns/MakesUrlAssertions.php)

[Asercje symfony/framework-bundle](https://github.com/symfony/framework-bundle/blob/2be18ce7e3c4ecd880a2fd219fcc48990a5340a4/Test/BrowserKitAssertionsTrait.php)

[Write custom assertions](https://phpunit.readthedocs.io/en/9.3/extending-phpunit.html#extending-phpunit-custom-assertions)

## Test

### Constraint

Mając własną klasę Constraint możemy napisać do niej test jednostkowy. Procedura nie różni się niczym od pisaniem testów dla innych klas. Tworzymy nowy przypadek testowy (TestCase). Definiujemy metodę testującą `testConstraint`. Metoda ta powinna tworzyć instancję Constraint i na tym obiekcje wywoływać metodę `evaluate`. Trzeci parametr (`returnResult`) określa czy chcemy zwrócić wynik, czy rzucić wyjątkiem w przypadku niepowodzenia.

Przykładowa metoda testująca z pakietu `/symfony/http-foundation`:

```
# ...
use PHPUnit\Framework\ExpectationFailedException;
use PHPUnit\Framework\TestCase;
use PHPUnit\Framework\TestFailure;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\Test\Constraint\ResponseIsSuccessful;

# ....

public function testConstraint(): void
{
    $constraint = new ResponseIsSuccessful();

    $this->assertTrue($constraint->evaluate(new Response(), '', true));
    $this->assertFalse($constraint->evaluate(new Response('', 404), '', true));

    try {
        $constraint->evaluate(new Response('', 404));
    } catch (ExpectationFailedException $e) {
        $this->assertStringContainsString("Failed asserting that the Response is successful.\nHTTP/1.0 404 Not Found", TestFailure::exceptionToString($e));

        return;
    }

    $this->fail();
}
```

[Constraints tests for symfony/http-foundation](https://github.com/symfony/http-foundation/tree/5139321b2b54dd2859540c9dbadf6fddf63ad1a5/Tests/Test/Constraint)

[PHPUnit Constraints tests](https://github.com/sebastianbergmann/phpunit/tree/3e541657ad6c1104935f6a6d3924b7226083aceb/tests/unit/Framework/Constraint)

### Asercja

Testowanie asercji wymaga utworzenie anonimowej klasy przypadku testowego, do którego dołączamy nasz trait z asercjami.

```
private function getTester(): TestCase
{
    $tester = new class() extends TestCase {
        use BoxAssertTrait;
    };

    return $tester;
}
```

W metodzie testującej oczekujemy zrzucenia wyjątku w przypadku niepowodzenia i wywołujemy naszą utworzoną asercję.

```
$this->expectException(AssertionFailedError::class);
$this->expectExceptionMessage('Box has value "1-2"');
$this->getTester()->assertBoxIsEqual($boxExpected, $boxActual);
```

[symfony/framework-bundle - WebTestCaseTest](https://github.com/symfony/framework-bundle/blob/2be18ce7e3c4ecd880a2fd219fcc48990a5340a4/Tests/Test/WebTestCaseTest.php)
