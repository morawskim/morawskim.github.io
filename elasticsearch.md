# Elasticsearch

## Elasticsearch REST API

### Mapping

```
GET /INDEX_NAME/_mapping
```

### Testowanie analizatora (ang. analyzer)

Podczas indeksowania full text Elasticsearch wykonuje analizę ciągu tekstowego i zwraca tokeny.
Token to termin, który będzie przechowywany w indeksie.
Dostępne jest [kilka wbudowanych analizatorów](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-analyzers.html). Domyślnie wykorzystywany jest analizator `standard`.

```
GET /_analyze
{
  "analyzer" : "standard",
  "text" : "Those are apples"
}

GET /_analyze
{
  "analyzer" : "english",
  "text" : "Those are apples"
}
```

Analizator `english` zindeksuje tokeny `those` i `appl`. Standardowy analizator zaś `those`, `are` i `apples`.

[Analyze API](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-analyze.html)

## Explain API

[Ta końcówka API](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-explain.html) wyjaśnia dlaczego jeden konkretny dokument pasuje (lub co może ważniejsze, dlaczego nie pasuje) do zapytania. W odpowiedzi otrzymamy klucz `description` np. z informacją dlaczego dokument nie pasuje do zapytania - `no matching term`.

```
GET /INDEX_NAME/_explain/DOCUMENT_ID
{
  "query" : {
    "match" : { "title" : "elasticsearch" }
  }
}

# response
#{
#  "_index" : "offer_2021-07-11-120843",
#  "_type" : "_doc",
#  "_id" : "7",
#  "matched" : false,
#  "explanation" : {
#    "value" : 0.0,
#    "description" : "no matching term",
#    "details" : [ ]
#  }
#}
```

## Wyszukiwanie

### Combine filters

```
GET /offer/_search
{
    "query" : {
        "bool" : {
            "must" : {
                "match" : {"title": "lorem"}
            },
            "filter" : {
                "term" : {
                    "price" : 2000
                }
            }
        }
    }
}
```

[Example of query and filter context](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-filter-context.html#query-filter-context-ex)

### Wyjaśnienie _score

Chcąc dowiedzieć się dokładnie jak Elaasticsearch obliczył `_score` dla dokumentu możemy dodać klucz `explain` z wartością `true` do końcówki `_saerch`.

```
GET /INDEX_NAME/_search
{
  "explain": true,
  "query" : {
    "match" : { "title": "foo" }
  }
}
```

### Opcje

### preference

Kiedy sortuje wyniki według pola czasowego i dwa dokumenty mają taką samą wartość to mogą zostać zwrócone w różnej kolejności. Gdy żądanie jest doręczane przez podstawową partycję, a w innej kolejności, gdy jest doręczone przez jedną z replik. Problem ten występuje pod nazwą `bouncing results`. Rozwiązanie polega na pobieraniu danych zawsze z tej samej partycji. Do tego wykorzystujemy parametr `preference`, który ustawiamy na dowolny ciąg znaków np. identyfikator sesji użytkownika.

[Preference](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-shard-routing.html#shard-and-node-preference)

## Agregacje

### Przykład

Agregacja pozwala nam otrzymać podgląd danych. Zamiast patrzeć indywidualne na dokumenty, analizujemy kompletny zestaw danych np. liczbę ogłoszeń w danej kategorii. Dzięki ustawieniu parametru `size` na 0 w wynikach dostaniemy tylko `aggregations` bez dokumentów (`hits`). W przypadku braku zapytania (klucza `query`) Elasticsearch dokona agregacji danych na podstawie wszystkich dokumentów w indeksie.

```
GET /INDEX_NAME/_search
{
  "size": 0,
  "aggs": {
    "my-agg-name": {
      "terms": {
        "field": "category.id"
      }
    }
  },
  "query": {
    "bool": {
      "filter": [
        {
          "term": {
            "sales_channel": "pl"
          }
        }
      ]
    }
  }
}
```

## FOSElasticaBundle

Obecnie w celu obsługi wersji 7 Elasticsearch musimy zainstalować wersję 6.0 pakietu, która ciągle jest w fazie rozwoju.
`composer require friendsofsymfony/elastica-bundle:^6.0@dev`

Przykładowa konfiguracja indeksu `index_name`.
Dobrą praktyką jest korzystanie z aliasów (`use_alias`), a także wyłączenie lub ograniczenie dynamicznego tworzenia mappingu (`dynamic`).

```
indexes:
        index_name:
            use_alias: true
            dynamic: false
            persistence:
                # the driver can be orm, mongodb or phpcr
                driver: orm
                model: App\Entity\SomeEntity
                finder: ~
                listener: { enabled: false }
                provider:
                    batch_size: 100
                    query_builder_method: createSearchQueryBuilder
                elastica_to_model_transformer:
                    ignore_missing: true
            properties:
                title:
                    property_path: false
                description:
                    property_path: false
                category:
                    property_path: false
                    type: "object"
                    properties:
                        id:
                            type: integer
                        path:
                            type: integer
                type:
                    property_path: false
                    type: keyword
                images:
                    property_path: false
                    type: "nested"
                    properties:
                        id:
                            type: integer
                            index: false
                        name:
                            index: false
                        small:
                            index: false
                        full:
                            index: false
                created_at:
                    property_path: false
                    type: date
                    format: basic_date_time_no_millis
```

### SSL

Do podłączenia się do usługi ElasticSearch w chmurze Amazona wykorzystywany jest protokół HTTPS. Podczas konfiguracji klienta, musimy ustawić parametr `transport` na wartość `Https`. W przeciwnym przypadku będziemy otrzymywać błędy - 'The plain HTTP request was sent to HTTPS port'. Dodatkowo będą one widoczne tylko gdy zmienna środowiskowa `APP_ENV` jest ustawiona na `dev`. Przykładowa wartość `ELASTICSEARCH_URL` to `https://some-name.eu-central-1.es.amazonaws.com:443/`

```
fos_elastica:
    clients:
        default:
          url: %env(ELASTICSEARCH_URL)%
          transport: Https
```

### Indeksowanie

`ElasticaBundle` podczas przekształcania encji w dokument Elasticsearch publikuje zdarzenie `\FOS\ElasticaBundle\Event\PreTransformEvent`.
Nasłuchiwanie na te zdarzenie umożliwia nam dodanie do dokumentu pól. W mappingu musimy ustawić wartość atrybutu `property_path` na `false`.
Metoda `transformObjectToDocument` klasy `ModelToElasticaAutoTransformer` zignoruje pole i nie będzie próbować wydobyć wartości dla tego pola.

Domyślnie `ElasticBundle` rejestruje listener (w przypadku korzystania z Doctrine - `\FOS\ElasticaBundle\Doctrine\Listener`),
który automatycznie aktualizuje dane w Elasticsearch na podstawie zmian w encjach Doctrine.
Aby go wyłączyć musimy to zrobić dla każdego indeksu.

```
indexes:
        index_name:
            persistence:
                listener: { enabled: false }
```

Wyłączając wbudowany listener musimy samemu aktualizować dane w Elasticsearch.
Wywołujemy polecenie `./bin/console debug:container --tag fos_elastica.persister`, aby poznać zarejestrowane usługi, które implementują interfejs `\FOS\ElasticaBundle\Persister\ObjectPersisterInterface`.
Znając identyfikator usługi możemy ją wstrzyknąć do usługi, i za pomocą metod takich jak `insertMany`, `replaceMany` i `deleteManyByIdentifiers` interfejsu `ObjectPersisterInterface` aktualizować dane w Elastcsearch.

Korzystając z polecenia ` ./bin/console fos:elastica:populate` możemy zindeksować wszystkie dane.
W przypadku kiedy chcemy indeksować np. tylko opublikowane artykułu musimy utworzyć nową metodę w klasie repozytorium (w przypadku Doctrine) np. `createSearchQueryBuilder`, która zwraca `\Doctrine\ORM\QueryBuilder`.
Następnie musimy skonfigurować w pliku `config/packages/fos_elastica.yaml` nasz indeks `index_name`, aby provider (`\FOS\ElasticaBundle\Doctrine\ORMPagerProvider`) korzystał z nowej metody.

```
indexes:
        index_name:
            persistence:
                provider:
                    query_builder_method: createSearchQueryBuilder
```

## Troubleshoot

### disk usage exceeded flood-stage watermark, index has read-only-allow-delete block

Podczas wykonywania polecenie indeksowania danych (`./bin/console  fos:elastica:populate`) otrzymałem błąd:

```
In AliasProcessor.php line 120:

  Failed to updated index alias: index [offer_2021-06-11-144312] blocked by: [TOO_MANY_REQUESTS/12/disk usage exceeded flood-stage watermark, index has read-only-allow-delete block];. Newly built index offer_2021-06-12-115230 was deleted
```

Z powodu niewielkiej ilości wolnego miejsca indeks został zablokowany.
Do odblokowania indeksu musimy wysłać żądanie HTTP:
```
curl -XPUT -H "Content-Type: application/json" http://elasticsearch:9200/_all/_settings -d '{"index.blocks.read_only_allow_delete": null}'
```
