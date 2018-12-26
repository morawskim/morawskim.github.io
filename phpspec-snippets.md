# phpspec - snippets

## Mockery zwracanie wartości na podstawie argumentu

```
$translateMock->shouldReceive('translate')->andReturnUsing(function ($argument) {
    return $argument;
});
```

## Sprawdzenie czy element znajduje się w kolekcji

```
public function it_should_return_item_if_age_from_and_to_are_null()
{
    ....

    $data = [$allocationItem2, $allocationItem3, $allocationItem1];
    $iterator = new \ArrayIterator($data);
    $this->beConstructedWith($iterator, 25);

    $this->shouldHaveCount(2);
    $this->shouldContain($allocationItem2);
    $this->shouldContain($allocationItem3);
}
```

