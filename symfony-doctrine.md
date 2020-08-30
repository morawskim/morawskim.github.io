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
Nasz typ mapuje do istniejącego typu (json), więc musimy nadpisać metodę `s`. Doctrine nie może odróżnić typu i w migracjach ciągle modyfikuje tą kolumnę. Zwracanie z tej metody wartości `true` spowoduje, użycie przez Doctrine komentarza SQL do wskazania właściwego typu.

Metoda `convertToDatabaseValue` odpowiada za przekształcenie wartości PHP do reprezentacji rozumianej przez sterownik BD. Zaś `convertToPHPValue` przekształca wartość z bazy danych na obiekt PHP. Jeśli korzystamy w projekcie z MySQL w wersji 8 możemy [ustawić wartość domyślną dla pola JSON](https://dbfiddle.uk/?rdbms=mysql_8.0&fiddle=57a9cb839d838075eced99d68f0a832a)

Finalnie musimy w konfiguracji frameworka Symfony [zarejestrować nasz nowy typ](https://symfony.com/doc/current/doctrine/dbal.html). W pliku `config/packages/doctrine.yaml` w kluczu `dbal` dodajemy:
```
types:
    box:  App\Doctrine\Type\BoxType
```

Jeśłi wywołamy narzędzie `./bin/console make:entity` i podczas wyboru typu pola wpiszemy `?`, aby zobaczyć wszystkie dostępne typy, to na liście ujrzymy nasz nowy typ.

[doctrine-enum-type](https://github.com/acelaya/doctrine-enum-type)

[Custom Mapping Types](https://www.doctrine-project.org/projects/doctrine-dbal/en/latest/reference/types.html#custom-mapping-types)

[Advanced field value conversion using custom mapping types](https://www.doctrine-project.org/projects/doctrine-orm/en/2.7/cookbook/advanced-field-value-conversion-using-custom-mapping-types.html#advanced-field-value-conversion-using-custom-mapping-types)

[Custom type test](https://github.com/odolbeau/phone-number-bundle/blob/7f9530b521f4baaf55232f47a13b737b9343e895/tests/Doctrine/DBAL/Types/PhoneNumberTypeTest.php)

[Custom type test](https://github.com/acelaya/doctrine-enum-type/blob/4db8de01d8044446c6e5ec4958e082a2be65000c/test/Type/PhpEnumTypeTest.php)

## Testy bazy danych

Do testów bazy danych warto zainstalować pakiet `dama/doctrine-test-bundle`. Ten pakiet nasłuchuje na zdarzenia PHPUnit i rozpoczyna transakcję przed każdym testem i wycofuje transakcję po teście. Daje to znacznie lepszą wydajność, ponieważ nie musimy przed każdym testem czyścić i importować dane do bazy danych. W przypadku korzystania z phpunit w wersji co najmniej 7.5 do pliku `phpunit.xml.dist` dodajemy:
```
<extensions>
    <extension class="DAMA\DoctrineTestBundle\PHPUnit\PHPUnitExtension"/>
</extensions>
```

Tworzymy nowy test, który dziedziczy po klasie `Symfony\Bundle\FrameworkBundle\Test\KernelTestCase`. Następnie w metodzie testującej możemy pobrać z kontenera usługę `doctrine`, wpierw jednak musimy dokonać rozruchu kernela.

```
$kernel = self::bootKernel();
$container = $kernel->getContainer();

/** @var Registry $doctrine */
$doctrine = $container->get('doctrine');
/** @var Connection $connection */
$connection = $doctrine->getConnection();

$service = new InventoryProjectorAction($connection);
//....
```
Warto nasz test oznaczyć adnotacją `@group <NAZWA>`. Dzięki temu będziemy mogli wykluczyć testy bazy danych podczas domyślnego wywołania phpunit. Aby wywołać tylko testy w ramach grupy np. `database` musimy wywołać phpunit z parametrem `--group database`. W pliku konfiguracyjnym `phpunit.xml.dist` dodajemy konfigurację dla grup:

```
<groups>
    <exclude>
        <group>database</group>
    </exclude>
</groups>
```

Aby wyświetlić dostępne grupy wywołujemy polecenie `./bin/phpunit --list-groups`

[How to Test Code that Interacts with the Database](https://symfony.com/doc/4.4/testing/database.html)
[phpunit  configuration group](https://phpunit.readthedocs.io/en/9.3/configuration.html#the-groups-element)
[phpunit annotation group](https://phpunit.readthedocs.io/en/9.3/annotations.html#appendixes-annotations-group)

## liip/test-fixtures-bundle

Pakiet `dama/doctrine-test-bundle` umożliwia nam przeprowadzenie testów z wykorzystaniem bazy danych. Jednak jeśli potrzebujemy dokonać zmian w bazie i zatwierdzić transakcję potrzebujemy dodatkowo `liip/test-fixtures-bundle`. Pakiet ten zawiera trait `Liip\TestFixturesBundle\Test\FixturesTrait` za pomocą którego możemy załadować fixtures po wykonaniu testu. Instalujemy pakiet wywołując polecenie `composer require --dev liip/test-fixtures-bundle`. Następnie tworzymy plik `config/packages/test/liip_test_fixtures.yaml` o zawartości [Conflicts with DAMADoctrineTestBundle](https://github.com/liip/LiipTestFixturesBundle/blob/master/doc/caveats.md#damadoctrinetestbundle):

```
liip_test_fixtures:
  keep_database_and_schema: true
```

W pliku z testem dołączamy wymieniony wcześniej trait `use FixturesTrait;`. W metodzie `tearDown` możemy wczytać wybrane klasy fixtures:

```
$this->loadFixtures([
    AppFixtures::class,
]);
```

[Using Doctrine DataFixtures and testing dynamic responses with PHPUnit in Symfony applications](http://www.inanzzz.com/index.php/post/vx0y/using-doctrine-data-fixtures-and-testing-dynamic-responses-with-phpunit-in-symfony-applications)

```
// from http://www.inanzzz.com/index.php/post/vx0y/using-doctrine-data-fixtures-and-testing-dynamic-responses-with-phpunit-in-symfony-applications

private static function reloadDataFixtures(): void
{
    $kernel = static::createKernel();
    $kernel->boot();
    $entityManager = $kernel->getContainer()->get('doctrine')->getManager();

    $loader = new Loader();
    foreach (self::getFixtures() as $fixture) {
        $loader->addFixture($fixture);
    }

    $purger = new ORMPurger();
    $purger->setPurgeMode(ORMPurger::PURGE_MODE_DELETE);
    $executor = new ORMExecutor($entityManager, $purger);
    $executor->execute($loader->getFixtures());
}
```

## Load fixtures

W frameworku Symfony dostępne jest polecenie `doctrine:fixtures:load`, które wczytuje data fixtures do bazy danych. Za pomocą parametru `--group` możemy wybrać którą grupę zaimportować. Polecenie domyślnie kasuje dane z tabel. Jednak jeśli w bazie danych istnieją tabele, których nie chcemy czyścić możemy je pominąć. W pliku `config/packages/doctrine.yaml` ustawiamy opcję `schema_filter`.

```
doctrine:
    dbal:
        schema_filter: ~^(?!TABELA$)~
```

Ustawiając tą opcję konfiguracji DBAL, framework zarejestruje usługę `doctrine.dbal.default_regex_schema_filter` i przypisze jej tag `doctrine.dbal.schema_filter`. Usługa ta będzie odnosić się do klasy `\Doctrine\Bundle\DoctrineBundle\Dbal\RegexSchemaAssetFilter`. Możemy utworzyć własną usługę i przypisać jej ten tag, jeśli domyślna funkcjonalność nam nie wystarcza.

Analizując kod polecenia `doctrine:fixtures:load` natrafimy na fragment:

```
$purger = new ORMPurger($em);
$purger->setPurgeMode($input->getOption('purge-with-truncate') ? ORMPurger::PURGE_MODE_TRUNCATE : ORMPurger::PURGE_MODE_DELETE);
$executor = new ORMExecutor($em, $purger);
$executor->setLogger(static function ($message) use ($ui) : void {
    $ui->text(sprintf('  <comment>></comment> <info>%s</info>', $message));
});
$executor->execute($fixtures, $input->getOption('append'));
```

Podczas inicjowania klasy `\Doctrine\Common\DataFixtures\Purger\ORMPurger` możemy przekazać argument `$excluded` z tablicą nazw tabel/widoków, które mają być wykluczone z wyczyszczenia.

[DoctrineMigrationsBundle - Manual Tables](https://symfony.com/doc/current/bundles/DoctrineMigrationsBundle/index.html#manual-tables)
