# Symfony Doctrine

## Własny mapping type

Modelując domenę biznesową często będziemy korzystać z tzw. Value Object. Typowym przykładem jest `Money`. Doctrine pozwala nam utworzyć własny typ, które zapiszemy w BD i przekonwertujemy do obiektu PHP podczas pobierania danych. Musimy utworzyć podklasę `Doctrine\DBAL\Types\Type` i zaimplementować kilka metod.
Szablon takiej klasy jest dostępny w dokumentacji projektu [Doctrine ORM](https://www.doctrine-project.org/projects/doctrine-orm/en/2.7/cookbook/custom-mapping-types.html). Ja wykorzystałem możliwość przechowywania danych JSON w bazie danych. Mój VO serializuje do postaci JSON. Metoda `getSQLDeclaration` wygląda tak:
```
public function getSQLDeclaration(array $fieldDeclaration, AbstractPlatform $platform)
{
    return $platform->getJsonTypeDeclarationSQL($fieldDeclaration);
}
```

Metoda `convertToDatabaseValue` odpowiada za przekształcenie wartości PHP do reprezentacji rozumianej przez sterownik BD. Zaś `convertToPHPValue` przekształca wartość z bazy danych na obiekt PHP. Jeśli korzystamy w projekcie z MySQL w wersji 8 możemy [ustawić wartość domyślną dla pola JSON](https://dbfiddle.uk/?rdbms=mysql_8.0&fiddle=57a9cb839d838075eced99d68f0a832a)

Finalnie musimy w konfiguracji frameworka Symfony [zarejestrować nasz nowy typ](https://symfony.com/doc/current/doctrine/dbal.html). W pliku `config/packages/doctrine.yaml` w kluczu `dbal` dodajemy:
```
types:
    box:  App\Doctrine\Type\BoxType
```

[doctrine-enum-type](https://github.com/acelaya/doctrine-enum-type)

[Custom Mapping Types](https://www.doctrine-project.org/projects/doctrine-dbal/en/latest/reference/types.html#custom-mapping-types)

[Advanced field value conversion using custom mapping types](https://www.doctrine-project.org/projects/doctrine-orm/en/2.7/cookbook/advanced-field-value-conversion-using-custom-mapping-types.html#advanced-field-value-conversion-using-custom-mapping-types)

