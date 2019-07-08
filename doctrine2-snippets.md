# doctrine2 - snippets

## On delete cascade

Domyślnie klucz obcy generowany przez doctrine nie umożliwia nam skasowanie encji z tabeli, jeśli inna tabela ma powiązanie do tego rekordu.
Jeśli nie potrzebujemy zdarzeń doctrine `preDelete`/`postDelete` to wtedy możemy wtedy skonfigurować tzw. `cascade delete`. Na poziomie bazy danych zostanie zmodyfikowany klucz obcy tak, aby przy kasowaniu encji, zależne rekordy w  innych tabelach były automatycznie kasowane.

```
@ORM\JoinColumn(name="poi_id", referencedColumnName="id", onDelete="CASCADE")
```
