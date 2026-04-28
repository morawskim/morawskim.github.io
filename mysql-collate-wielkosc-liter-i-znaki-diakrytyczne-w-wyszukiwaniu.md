# MySQL COLLATE – wielkość liter i znaki diakrytyczne w wyszukiwaniu

W projekcie mieliśmy bazę danych z oddziałami firm.
Uproszczony schemat tabeli wyglądał następująco:

```
CREATE TABLE `branch` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `city` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  --- .....
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
```

Podczas wyszukiwania danych po polach takich jak miasto czy województwo otrzymywaliśmy w wynikach np. województwo "łódzkie" dla frazy "łódź".
Wynikało to z ustawień COLLATE (reguł porównywania tekstu).

W tym konkretnym przypadku chcieliśmy, aby:
* wielkość liter nie miała znaczenia,
* znaki diakrytyczne miały znaczenie `ł != l`

Zastosowanie utf8mb4_0900_as_ci spełniało te wymagania.

Przykładowe zapytanie SQL:

```
SELECT `branch`.city, branch.address, state.value
FROM `branch`
WHERE (`branch`.`status` = 'active')
  AND ((branch.city COLLATE utf8mb4_0900_as_ci  LIKE '%łódź%') OR
       (branch.address COLLATE utf8mb4_0900_as_ci LIKE '%łódź%') OR
       (state.value COLLATE utf8mb4_0900_as_ci LIKE '%łódź%'))
ORDER BY `branch`.`id` DESC
LIMIT 100
```

Oznaczenia w nazwach COLLATE w MySQL

`_ci` – case-insensitive (ignoruje wielkość liter)
`_cs` – case-sensitive (rozróżnia wielkość liter)
`_bin` – porównanie binarne (najbardziej restrykcyjne)
`_ai` – accent-insensitive (ignoruje znaki diakrytyczne, np. ą = a)
`_as` – accent-sensitive (rozróżnia znaki diakrytyczne, np. ł ≠ l)
