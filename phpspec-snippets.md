# phpspec - snippets

## Mockery zwracanie wartości na podstawie argumentu

```
$translateMock->shouldReceive('translate')->andReturnUsing(function ($argument) {
    return $argument;
});
```

