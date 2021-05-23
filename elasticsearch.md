# Elasticsearch

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
