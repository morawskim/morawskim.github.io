# Optymalizacja zapytań

## MongoDB countDocuments

Do zapytań MongoDB możemy dodać operator [$comment](https://www.mongodb.com/docs/v4.2/reference/operator/query/comment/#op._S_comment), dzięki temu w logach określimy, które zapytania są wolne.
 W przypadku pipeline w etapie `$match` dodajemy operator `$comment`.

Następnie w logach możemy filtrować wpisy po frazie `$comment` jak poniżej:
> 2022-11-24T07:31:41.930+0000 I COMMAND  [conn30] command linker.orders command: aggregate { aggregate: "orders", pipeline: [ { $match: { $comment: "very long query", .... } ], allowDiskUse: false, cursor: {}, $db: "dbname", 
> lsid: { id: UUID("0207513e-763f-4f97-a3a0-3b1a5e740b90") } } planSummary: COLLSCAN keysExamined:0 docsExamined:35640 cursorExhausted:1 numYields:278 nreturned:1 reslen:110 locks:{ Global: { 
> acquireCount: { r: 560 } }, Database: { acquireCount: { r: 280 } }, Collection: { acquireCount: { r: 280 } } } protocol:op_msg 325ms

W przypadku dużych kolekcji (miliony dokumentów) czas wywołania polecenie `countDocuments` z kilkoma filtrami, które w większości posiadają indeks może trwać ponad 90s. W logach MongoDB można zobaczyć, że takie polecenie [wywołuje agregacje](https://www.mongodb.com/docs/manual/reference/method/db.collection.countDocuments/#mechanics).
Możemy znacząco przyśpieszyć takie zapytanie dodając dodatkowe opcje: limit i maxTimeMS - `db.orders.countDocuments({"foo": "bar"}, {"limit": 10000, "maxTimeMS": 2000})`
W takim przypadku MongoDB będzie liczyć dokumentu do osiągnięcia limitu 10000, albo operacja zakończy się błędem (timeout) po 2sekundach.

> db.orders.countDocuments({"foo": "bar"}, {"limit": 10000, "maxTimeMS": 2000})
2022-11-25T14:50:51.769+0000 I COMMAND  [conn231] command dbname.orders appName: "DataGrip" command: aggregate { aggregate: "orders", pipeline: [ { $match: { foo: "bar" } }, { $limit: 10000 }, { $group: { _id: 1, n: { $sum: 1 } } } ], maxTimeMS: 2000, cursor: {}, $db: "dbname", lsid: { id: UUID("e45733f9-9e8f-4252-92d8-ad963f7fa57f") } } planSummary: COLLSCAN exception: Error in $cursor stage :: caused by :: errmsg: "operation exceeded time limit" code:ExceededTimeLimit numYields:2779 reslen:155 locks:{ Global: { acquireCount: { r: 5564 } }, Database: { acquireCount: { r: 2782 } }, Collection: { acquireCount: { r: 2782 } } } protocol:op_msg 2017ms

## Skrpt do filtrowania logów MongoDB < 4

Przykładowy skrypt PHP, który przetwarza **nieustrukturyzowane** logi MongoDB i wyświetla tylko te wpisy, które dotyczą wolnych zapytań MongoDB.

``` php
<?php

function skipLine(string $line): bool {
    return str_contains($line, 'end connection')
        || str_contains($line, 'Successfully authenticated')
        || str_contains($line, 'received client metadata')
        || str_contains($line, 'connection accepted from')
        || str_contains($line, 'over max size (10kB), printing beginning')
        || str_contains($line, 'appName: "mongodb_exporter"')
    ;
}

while (!feof(STDIN)) {
    $line = fgets(STDIN);

    if (skipLine($line)) {
        continue;
    }

    $columns = explode(' ', $line);
    $row = [];

    if (($columns[2] ?? '') !== 'COMMAND') {
        continue;
    }

    $commandText = $columns[5] ?? '';
    $collectionWithDbName = $columns[6] ?? '';
    $commandText2 = $columns[7] ?? '';
    $operation = $columns[8] ?? '';

    if ($commandText !== 'command' || $commandText2 !== 'command:') {
        fprintf(STDERR, 'Line looks strange "%s"', $line);
        continue;
    }


    [$dbName, $collectionName] = explode('.',  $collectionWithDbName, 2);
    $query = implode(' ', array_slice($columns, 9, -1));
    $duration = substr($columns[count($columns) -1], 0, -3);
    $comment = '-';

    if (str_contains($query, '$comment')) {
        $matches = [];
        $result = preg_match('/\$comment[\s:]*[\'"]([A-Z_\-0-9]+)[\'"]/', $query, $matches);
        if (false === $result) {
            fprintf(STDERR, 'Preg match return error "%s"', preg_last_error_msg());
            $comment = $matches[1] ?? 'REGEX_FAIL';
            continue;
        }
        $comment = $matches[1] ?? 'COMMENT_EXISTS_BUT_NOT_MATCH';
    }

    printf('%s %s %s %s %s %s', $dbName, $collectionName, $operation, $duration, $comment, $query);
    echo PHP_EOL;
}

```

## Slotted counter patter

W bazach danych często musimy zwiększyć wartość kolumny INT w przypadku wystąpienia zdarzenia takiego jak wyświetlenie strony.
W celu pozbycia się wąskich gardeł, które pojawiają się podczas blokowania rekordu stosuje się ten wzorzec. 
Ma on na celu rozłożenie inkrementacji licznika na wiele rekordów i tym samy pozbycie się "hot key".

[The Slotted Counter Pattern](https://planetscale.com/blog/the-slotted-counter-pattern)
