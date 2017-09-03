Mysql - SHOW PROCESSLIST
========================

Monitorując bazę danych często korzystam z polecenia SHOW PROCESSLIST. Wyświetla on informacje czym zajmują się poszczególne wątki MySQL. Jednak jeśli zauważymy długo wykonywane zapytanie, to najczęściej jego treść będzie przycięta. Aby nie przycinać danych trzeba użyć polecenia SHOW FULL PROCESSLIST.

``` sql
SHOW PROCESSLIST;
| 12491616 | XXXXXXXXXX | 172.17.0.1:54062 | XXXXXXXXXX   | Query   |  161 | Sending data                 | SELECT COUNT(DISTINCT `t`.`id`) FROM `cs_cases` `t`  LEFT OUTER JOIN `vw_clients` `client` ON (`t`.` |    0.000 |
```

``` sql
SHOW FULL PROCESSLIST;
| 12491616 | XXXXXXXXXX | 172.17.0.1:54062 | XXXXXXXXXX   | Query   |  258 | Sending data   | SELECT COUNT(DISTINCT `t`.`id`) FROM `cs_cases` `t`  LEFT OUTER JOIN `vw_clients` `client` ON (`t`.`client_id`=`client`.`id`)  WHERE (((t.folder_id!=6 OR t.folder_id IS NULL) AND (t.notes LIKE '%test%' OR t.id IN (SELECT case_id FROM cs_messages2 WHERE cs_messages2.content LIKE '%test%'))) AND (t.status!=3))
```