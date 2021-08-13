#JSON Schema

JSON Schema pozwala na opisanie struktury dokumentu JSON, a następnie zweryfikowanie czy dokument spełnia założone kryteria. Dokładna specyfikacja jest dostępna na stronie [json-schema.org](https://json-schema.org/).

Wykorzystałem JSON Schema do zbudowania funkcjonalność "custom fileds". Każda kategoria może posiadać JSON Schemat. Na jego podstawie użytkownik wybierając daną kategorię dostanie do uzupełnienia dodatkowe pole. Podobnie to działa przy wyszukiwarce. Wybranie kategorii spowoduje wyświetlenie dodatkowych filtrów. W tym jednak przypadku oryginalny JSON Schemat jest modyfikowany, aby spełniać niektóre dodatkowe wymagania. Np. pola wyboru przy dodawaniu ogłoszenia w wyszukiwarce zezwala na listę wartości. A więc użytkownik może wyszukiwać np. ubrania w rozmiarze `s` lub `m`, ale przy dodawaniu ogłoszenia może wybrać tylko jedną z tych wartości.

W PHP pakiet [cyve/json-schema-form-bundle](https://github.com/cyve/json-schema-form-bundle), posłużył do dynamicznego tworzenia formularza Symfony i sprawdzenia poprawności danych w oparciu o JSON Schemat.
Do generowania danych testowych w testach cypress wykorzystałem pakiet JS [json-schema-faker](https://github.com/json-schema-faker/json-schema-faker). Integruje się on z `faker.js`.
Parametr `fillProperties` zapobiega generowaniu dodatkowych atrybutów - [Option to avoid generating additional properties #656](https://github.com/json-schema-faker/json-schema-faker/issues/656)

Przykładowa integracja faker.js z json-schema-faker.
```
import * as fakerPL from 'faker/locale/pl'
import * as fakerUS from 'faker/locale/en_US'
import * as jsf from 'json-schema-faker';

export function generatePLAttributesJsonSchema(schema) {
    jsf.option('fillProperties', false);
    jsf.extend('faker', () => fakerPL);

    return jsf.generate(schema);
}
```

Do wyświetlenie formularza w oparciu o JSON Schema możemy skorzystać z biblioteki [react-jsonschema-form](https://github.com/rjsf-team/react-jsonschema-form).

Biblioteka [react-json-schema-form-builder](https://github.com/ginkgobioworks/react-json-schema-form-builder) umożliwia użytkownikowi wizualnie skofnigurować formularz zakodowany w formacie JSON Schemat.

Przykładowy JSON Schemat
```
{
  "type": "object",
  "required": [],
  "properties": {
    "circumference": {
      "title": "Obwód klatki",
      "type": "number",
      "faker": {
        "finance.amount": [40, 120, 2]
      }
    },
    "height": {
      "title": "Wzrost",
      "type": "integer",
      "faker": {
        "datatype.number": [{"min":100, "max":210}]
      }
    },
    "brand": {
      "title": "Nazwa marki",
      "type": "string",
      "faker": "vehicle.manufacturer"
    },
    "size": {
      "title": "Rozmiar",
      "type": "string",
      "enum": [
        "xs",
        "s",
        "m",
        "l",
        "xl",
        "xxl",
        "xxxl"
      ],
      "faker": {
        "random.arrayElement": [["xs", "s", "m", "l", "xl", "xxl", "xxxl"]]
      }
    }
  }
}
```
