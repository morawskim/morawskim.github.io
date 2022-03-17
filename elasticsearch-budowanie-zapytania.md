# Elasticsearch - budowanie zapytania

W projektach wykorzystujących Elasticsearch często musimy budować skompilowane zapytania.
Zadanie budowania tej tablicy deleguje do wielu klas, które implementują interfejs `QueryBuilderInterface`.
Interfejs ten deklaruje publiczną metodę `modifyQuery`, która przyjmuje DTO z wartościami filtrów, a także referencję do tablicy przechowującą zapytanie Elasticsearch.


```
interface QueryBuilderInterface
{
    public function modifyQuery(SearchRequestDto $searchRequestDto, array &$query): void;
}

```

Dodatkowo definiuje klasę `AbstractQueryBuilder`, która implementuje interfejs `QueryBuilderInterface` i dodaje kilka pomocniczych metod.

```
abstract class AbstractQueryBuilder implements QueryBuilderInterface
{
    protected function appendFilterQuery(array &$baseQuery, array $filterQuery): void
    {
        if (!isset($baseQuery['query'])) {
            $baseQuery['query'] = [];
        }

        if (!isset($baseQuery['query']['bool'])) {
            $baseQuery['query']['bool'] = [];
        }

        if (!isset($baseQuery['query']['bool']['filter'])) {
            $baseQuery['query']['bool']['filter'] = [];
        }

        $baseQuery['query']['bool']['filter'][] = $filterQuery;
    }

    protected function appendMustQuery(array &$baseQuery, array $query): void
    {
        if (!isset($baseQuery['query'])) {
            $baseQuery['query'] = [];
        }

        if (!isset($baseQuery['query']['bool'])) {
            $baseQuery['query']['bool'] = [];
        }

        if (!isset($baseQuery['query']['bool']['must'])) {
            $baseQuery['query']['bool']['must'] = [];
        }

        $baseQuery['query']['bool']['must'][] = $query;
    }
}
```

Poniżej przedstawiona jest uproszczona implementacja klasy, która filtruje ogłoszenia po tytule. W projekcie istniały dodatkowe klasy, które implementowały pozostałą logikę np. filtrowanie po atrybutach niestandardowych ogłoszenia, geolokalizacja, sortowanie itd.

```
class BaseOffer extends AbstractQueryBuilder
{
    public function modifyQuery(SearchRequestDto $searchRequestDto, array &$query): void
    {
        $phrase = $searchRequestDto->getPhrase();

        if ($phrase) {
            $this->appendMustQuery($query, $this->createTitleQuery($phrase));
        }
    }

    private function createTitleQuery($phrase): array
    {
        return [
            'match' => [
                'title' => $phrase,
            ],
        ];
    }
}

```

Prócz tego mamy usługę `QueryBuilder` do której wstrzykujemy obiekty implementujące interfejs `QueryBuilderInterface`. Za pomocą metody `buildQuery` budujemy wynikowe zapytanie Elasticsearch dla danych zawartych w DTO `SearchRequestDto` przekazując do każdej implementacji `QueryBuilderInterface ` DTO i aktualne zapytanie do modyfikacji.

```
class QueryBuilder
{
    /** @var iterable<QueryBuilderInterface>  */
    private iterable $queryBuilders;

    public function __construct(iterable $queryBuilders)
    {
        $this->queryBuilders = $queryBuilders;
    }

    public function buildQuery(SearchRequestDto $searchRequestDto): array
    {
        $query = [];

        foreach ($this->queryBuilders as $queryBuilder) {
            $queryBuilder->modifyQuery($searchRequestDto, $query);
        }

        return $query;
    }
}

```
