# doctrine2 - snippets

## On delete cascade

Domyślnie klucz obcy generowany przez doctrine nie umożliwia nam skasowanie encji z tabeli, jeśli inna tabela ma powiązanie do tego rekordu.
Jeśli nie potrzebujemy zdarzeń doctrine `preDelete`/`postDelete` to wtedy możemy wtedy skonfigurować tzw. `cascade delete`. Na poziomie bazy danych zostanie zmodyfikowany klucz obcy tak, aby przy kasowaniu encji, zależne rekordy w  innych tabelach były automatycznie kasowane.

```
@ORM\JoinColumn(name="poi_id", referencedColumnName="id", onDelete="CASCADE")
```

## WHERE IN

W zapytaniach SQL często korzystamy z operatora `IN`, który pozwala nam określić wiele wartości w klauzuli `WHERE`.
Aby mieć zabezpieczone wartości musimy ustawić odpowiedni typ parametru.

``` php
$query->andWhere($query->expr()->in('pgpc.poi_category_id', ':categories'));
$query->setParameter(
    'categories',
    $filter->getCategories(),
    \Doctrine\DBAL\Connection::PARAM_INT_ARRAY
);
```

Jeśli zamiast liczb, korzystamy z ciągów znaków nasz typ parametru musi być ustawiony na wartość stałej `\Doctrine\DBAL\Connection::PARAM_STR_ARRAY`.
