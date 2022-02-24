# Doctrine

## Konfiguracja

Konfiguracja ORM jest prosta w przypadku korzystania z pomocniczej klasy do konfiguracji doctrine `Doctrine\ORM\Tools\Setup`. Musimy wywołać statyczną metodę `createAnnotationMetadataConfiguration`, której sygnatura wygląda tak `public static function createAnnotationMetadataConfiguration(array $paths, $isDevMode = false, $proxyDir = null, Cache $cache = null, $useSimpleAnnotationReader = true)`. Następnie wywołujemy statyczną metodę `create` klasy `Doctrine\ORM\EntityManager`. Jako pierwszy parametr przekazujemy konfigurację do połączenia się z bazą danych albo instancję `Doctrine\DBAL\Connection`. Jako drugi parametr przekazujemy konfigurację, którą utworzyliśmy wywołując metodę `createAnnotationMetadataConfiguration`.

Zostanie zwrócona instancja `\Doctrine\ORM\Configuration`.
Możemy wywołać metodę `setSQLLogger`, aby ustawić logger, który będzie logował wszystkie wywoływane zapytania SQL. Logger musi implementować interfejs `\Doctrine\DBAL\Logging\SQLLogger`.
Dodatkowo możemy ustawić strategię nazywania pól w bazie danych poprzez wywołanie metody `setNamingStrategy`. Strategia musi implementować interfejs `\Doctrine\ORM\Mapping\NamingStrategy`.

## Metadane

Interfejs `\Doctrine\Persistence\Mapping\ClassMetadataFactory` definiuje metodę `getMetadataFor`, za pomocą której pobieramy metadane dla konkretnej encji.
Implementację `ClassMetadataFactory` uzyskujemy z implementacji EntityManager (interfejs `\Doctrine\Persistence\ObjectManager`) wywołując metodę `getMetadataFactory`.

Aby poprawić wydajność (i nie parsować ciągle konfiguracji) metadane są buforowane.
W przypadku framework Symfony [metadane są buforowane tylko w środowisku produkcyjnym](https://github.com/symfony/recipes/blob/9a7f5bcebbda2f5244c4be4133a6bd181080cbea/doctrine/doctrine-bundle/2.0/config/packages/prod/doctrine.yaml#L4).

Metoda `\Doctrine\Persistence\Mapping\AbstractClassMetadataFactory::getMetadataFor` sprawdza, czy ustawiono adapter do buforowania metadanych. Implementacja interfejsu `\Doctrine\Persistence\Mapping\ClassMetadata` implementuje magiczną metodę `__sleep`, która zwraca tablicę pól, które należy serializować.

[Zgodnie z komentarzem](https://github.com/doctrine/DoctrineBundle/issues/1186#issuecomment-658150569) nie powiniśmy korzystać z adaptera `PhpArrayAdapter`.
