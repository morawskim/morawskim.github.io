# doctrine ignorowanie różnic schematu tabeli z encją

W jednym z projektów istniała tabela, która nie była zarządzana przez doctrine. W pewnym momencie postanowiliśmy jednak utworzyć jej encję. Powodowało to problemy z poleceniem `doctrine:schema:update`. Pomimo automatycznego wygenerowania encji z schematu tabeli, doctrine chciał zmienić schemat tej tabeli.

Postanowiłem znaleźć sposób, aby doctrine ignorował tą tabelę podczas próby aktualizowania schematu bazy danych. Rozwiązaniem jest podłączenie się pod zdarzenie `postGenerateSchema`.

Poniżej cała implementacja klasy. W właściwości `ignoredTables` przechowuję tablicę nazw tabel bazy danych, które chcemy ignorować.

``` php
<?php

namespace App\EventListener;

use Doctrine\ORM\Tools\Event\GenerateSchemaEventArgs;

/**
 * @link http://kamiladryjanek.com/ignore-entity-or-table-when-running-doctrine2-schema-update-command/
 */
class IgnoreTablesListener
{
    private $ignoredTables = [
        'reports.networks',
        'reports.aps',
    ];

    /**
     * Remove ignored tables from Schema
     *
     * @param GenerateSchemaEventArgs $args
     */
    public function postGenerateSchema(GenerateSchemaEventArgs $args)
    {
        $schema = $args->getSchema();
        $ignoredTables = $this->ignoredTables;
        foreach ($schema->getTableNames() as $tableName) {
            if (in_array($tableName, $ignoredTables)) {
                // remove table from schema
                $schema->dropTable($tableName);
            }
        }
    }
}

```
