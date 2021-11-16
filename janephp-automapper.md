# janephp/automapper

## DiscriminatorMap

Gitlab obsługuje webhooki. Możemy w konfiguracji projektu nasłuchiwać na zdarzenie dodania notatki. Jednak nie umożliwia nam wybrania konkretnego typu notatki (np. tylko Merge Request). Na podstawie informacji w payload (`objectAttributes.noteableType`) musimy utworzyć specyficzną strukturę danych.
AutoMapper obsługuje taką funkcję wykorzystując adnotację symfony/serialize - `DiscriminatorMap`. Jednak w tym przypadku musiałem zdublować wartość zagnieżdżonego pola w fabryce mapującej dane (inaczej nie działało). - `$data['noteTypeEvent'] = $data['objectAttributes']['noteableType'] ?? '';`

Konfiguracja:
``` php
// ...
use Symfony\Component\Serializer\Annotation\DiscriminatorMap;

// ...

/**
 *  @DiscriminatorMap(typeProperty="noteTypeEvent", mapping={
 *    "MergeRequest"="App\Gitlab\Payload\NoteMergeRequestEvent",
 *    "Commit"="App\Gitlab\Payload\NoteCommitEvent",
 *    "Issue"="App\Gitlab\Payload\NoteIssueEvent",
 *    "Snippet"="App\Gitlab\Payload\NoteSnippetEvent",
 * })
 */
abstract class NoteEvent
// ...
```

## AutoMapper ObjectMother

[AutoMapperBaseTest](https://github.com/janephp/janephp/blob/1ab481af9d8ab7f8416c93fc3df749435d915ce3/src/Component/AutoMapper/Tests/AutoMapperBaseTest.php)

``` php
# ...
use Doctrine\Common\Annotations\AnnotationReader;
use Jane\Component\AutoMapper\AutoMapper;
use Jane\Component\AutoMapper\AutoMapperInterface;
use Jane\Component\AutoMapper\Generator\Generator;
use Jane\Component\AutoMapper\Loader\FileLoader;
use PhpParser\ParserFactory;
use Symfony\Component\Serializer\Mapping\ClassDiscriminatorFromClassMetadata;
use Symfony\Component\Serializer\Mapping\Factory\ClassMetadataFactory;
use Symfony\Component\Serializer\Mapping\Loader\AnnotationLoader;

# ...

public static function default(): AutoMapperInterface
{
    $classMetadataFactory = new ClassMetadataFactory(new AnnotationLoader(new AnnotationReader()));
    $loader = new FileLoader(
        new Generator(
            (new ParserFactory())->create(ParserFactory::PREFER_PHP7),
            new ClassDiscriminatorFromClassMetadata($classMetadataFactory)
        ), __DIR__ . '/../__cache__'
    );

    return AutoMapper::create(true, $loader);
}
```
