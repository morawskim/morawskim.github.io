# Doctrine batch update

Miałem zadanie ustawienia domyślnej wartości dla kolumny w tabeli. Rekordów było dużo, więc nie mogłem pobrać wszystkich danych naraz. Jak się okazało skorzystanie z iteratora, też nie rozwiązuje do końca problemu. Doctrine ciągle przechowuje referencję do pobranych obiektów co uniemożliwia działanie GC. Musimy odłączyć nasz obiekt z `EntityManager`.


``` php
$q = $this->em->createQueryBuilder();
$q->select('c')
    ->from(Company::class, 'c')
    ->andWhere('c.slug IS NULL')
    ->orWhere("c.slug = ''");
$iterator = $q->getQuery()->iterate();

foreach ($iterator as $row) {
    try {
        /** @var Company $company */
        $company = $row[0];
        $company->generateSlug();
        $this->em->persist($company);
        $this->em->flush();
        $this->em->detach($row[0]);
    } catch (\Exception $e) {
        $io->error(sprintf(
            'Error during company slug update. For company #%d "%s". Error: %s',
            $company->getId(),
            $company->getName(),
            $e->getMessage()
        ));
    }
}
```

https://stackoverflow.com/a/26698814

