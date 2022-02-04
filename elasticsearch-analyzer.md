# Elasticsearch analizatory

Elasticsearch posiada kilka analizatorów do [analizy tekstu w specyficznym języku](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-lang-analyzer.html). W przypadku języka polskiego musimy [zainstalować plugin](https://www.elastic.co/guide/en/elasticsearch/plugins/current/analysis-stempel.html). Wywołujemy polecenie `bin/elasticsearch-plugin install analysis-stempel` i resetujemy Elasticsearch. W przypadku korzystania z obrazu dockera, wystarczy zatrzymać i ponownie uruchomić kontener. Jednak znacznie lepiej jest utworzyć plik Dockerfile, w którym zainstalujemy ten plugin w fazie budowania obrazu:

```
FROM docker.elastic.co/elasticsearch/elasticsearch:7.11.1

RUN bin/elasticsearch-plugin install analysis-stempel

```

W przypadku chmury AWS i korzystania z usługi Elasticsearch ten plugin (i kilka innych) już są zainstalowane - [Plugins by engine version](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/supported-plugins.html).

Aby potwierdzić czy nasz plugin jest zainstalowany wywołujemy polecenie `curl "http://elasticsearch:9200/_cat/plugins"`. Podstawiając pod `elasticsearch:9200` adres Elasticsarch.

```
#.....
689a4955f22b772edd2d7cd1d62b50d6 analysis-stempel                     7.11.1
# ....
```

Korzystając z Kibany możemy wysłać poniższe zapytania do elasticsearch potwierdzające dostępność i działanie analizatorów:

<table>
<tr>
<th>
Request
</th>
<th>
Response
</th>
</tr>

<tr>
<td>
<pre>
GET /_analyze
{
  "analyzer" : "english",
  "text" : "Walking with dogs"
}
</pre>
</td>
<td>
<pre>
{
  "tokens" : [
    {
      "token" : "walk",
      "start_offset" : 0,
      "end_offset" : 7,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "dog",
      "start_offset" : 13,
      "end_offset" : 17,
      "type" : "<ALPHANUM>",
      "position" : 2
    }
  ]
}
</pre>
</td>
</tr>


<tr>
<td>
<pre>
GET /_analyze
{
  "analyzer" : "polish",
  "text" : "Bardzo tanie telefony "
}
</pre>
</td>
<td>
<pre>
{
  "tokens" : [
    {
      "token" : "tan",
      "start_offset" : 7,
      "end_offset" : 12,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "telefon",
      "start_offset" : 13,
      "end_offset" : 21,
      "type" : "<ALPHANUM>",
      "position" : 2
    }
  ]
}
</pre>
</td>
</tr>

</table>

W przypadku braku analizatora dostaniemy błąd podobny do poniższego:

```
{
  "error" : {
    "root_cause" : [
      {
        "type" : "illegal_argument_exception",
        "reason" : "failed to find global analyzer [fff]"
      }
    ],
    "type" : "illegal_argument_exception",
    "reason" : "failed to find global analyzer [fff]"
  },
  "status" : 400
}
```

W konfiguracji ElasticaBundle dla Symfony musimy w indeksie zdefiniować pole i indeksować je w różny sposób. Do tego służą [multi-fields/fields](https://www.elastic.co/guide/en/elasticsearch/reference/current/multi-fields.html). Podczas wyszukiwania najlepiej jest wyszukiwać po obu polach (title i title.pl) i połączyć wyniki - do tego służy zapytanie `multi_match` (przykład w linku wyżej).

```
# Read the documentation: https://github.com/FriendsOfSymfony/FOSElasticaBundle/blob/master/doc/setup.md
fos_elastica:
    # ...
    indexes:
        offer:
            # ...
            properties:
                title:
                    property_path: false
                    fields:
                        us:
                            type: text
                            analyzer: english
                        pl:
                            type: text
                            analyzer: polish
                # ...
```
