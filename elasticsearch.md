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

### Nested

`Nested objects` są wykorzystywane gdy mamy jedną główną encję (np. Ogłoszenie) z ograniczoną liczbą blisko powiązanych encji (np. dodatkowe atrybuty ogłoszenia).

```
GET /INDEX_NAME/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "nested": {
            "path": "attributes_choice",
            "query": {
              "bool": {
                "must": [
                  {"term": {"attributes_choice.name": "size"}},
                  {"terms": {"attributes_choice.value": ["s"]}}
                ]
              }
            }
          }
        }
      ]
    }
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

### Post filter

`post_filter` pozwala nam przefiltrować tylko wyniki wyszukiwania, ale nie agregacje.
Ten filtr używamy, aby obliczyć agregacje na podstawie szerszego zestawu wyników, a następnie zawęzić wyniki.
Dzięki temu możemy użytkownikowi wyświetlić np. ile jest produktów w innym kolorze niż wybranym.
Przykład jest w dokumentacji Elasticsearch - [Filter search result - Post filter](https://www.elastic.co/guide/en/elasticsearch/reference/current/filter-search-results.html#post-filter)

## Dobre praktyki

* Domyślnie zapytanie `match` korzysta z operatora `OR`. Dlatego fraza "capital of Hungary" jest interpretowana jako  "capital OR of OR Hungary". Zmieniając operator najpewniej będziemy też chcieli ustawić parametr `minimum_should_match`. [Match query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-match-query.html)

* Gdy stosujemy agregację np. `terms` do pola typu string, pole to nie powinno być analizowane (`not_analyzed`). W przeciwnym przypadku w wynikach dostaniemy dziwne tokeny.

* Kiedy ustawiamy wielkość sterty dla Elasticsearch nie powinna ona przekraczać poziomu 50% dostępnej pamięci RAM, ale także nie przekraczać 32GB. JVM może wtedy korzystać z kompresowanych wskaźników do pamięci co znacząco zmniejsza wykorzystanie pamięci. Obie wartości `Xmx` i `Xms` powinny mieć taką samą wartość, aby uniknąć kosztownego procesu zmiany rozmiaru sterty.

* Kiedy korzystamy z relacji rodzic - dziecko, i chcemy zmienić rodzica, to musimy wpierw skasować dokument rodzica. Wynika to z zasad działania. Dokument rodzica i wszystkie jego dzieci muszą znajdować się w jednym shard.

* Nie możemy zwiększyć ilości shard w indeksie, ponieważ ta liczba shardów jest ważnym elementem algorytmu do rozmieszczania indeksowanych dokumentów. Jedyną opcją jest prze indeksowanie wszystkich dokumentów do indeksu z zwiększoną liczbą shardów. Musimy jednak wystrzegać się nadmiernej alokacji. Domyślnie Elasticsearch alokuje 5 podstawowych shardów.

* Kasowanie dokumentów nie jest mocno efektywne w Elasticsearch, ponieważ takie dokumenty są oznaczone jako do skasowania. Dlatego gdy wykorzystujemy Elasticsearch do przechowywania logów zakładamy indeksy na rok, miesiąc albo nawet na dzień. W takim przypadku kasowanie starych danych jest łatwe - kasujemy indeks. Dodatkowo możemy korzystać z aliasów np. `current`, albo `last_3_months`, aby łatwiej wyszukiwać dane.

* Powinniśmy zwiększyć limit otwartych plików do dużej wartości np. `64 000` a także zwiększyć parametr `vm,max_map_count` na wartość np. `262144` w pliku `/etc/sysctl.conf`.

## Monitorowanie końcówki REST

* Aktualny stan klastra - `GET /_cluster/state`

* Szybki rzut oka na stan klastra - `GET /_cluster/health`

* Podstawowy stan klastra wraz z informacjami na temat każdego indeksu - `GET /_cluster/health?level=indices`

* Podobnie jak wyżej ale z szczegółami każdego shard wewnątrz każdego indeksu - `GET /_cluster/health?level=shards`

* Statystyki o każdym węźle w klastrze - `GET _nodes/stats`

* Statystyki klastra (bardziej zwięzłe niż node-stats) - `GET _cluster/stats`

* Statystyki indeksu INDEX_NAME - `GET INDEX_NAME/_stats`

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
