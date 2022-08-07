# Meilisearch

## Validation error - not supported highlightPreTag

Wersja v0.26.1 Meilisearch nie obsługuje parametru `highlightPreTag`, a nowsza wersja ciągle jest w fazie RC.
Biblioteka npm `@meilisearch/instant-meilisearch` w wersji v0.7.1 zawiera już obsługę tego parametru, co powoduje problemy.
Obecnie można to rozwiązać poprzez zainstlowanie wersji `v0.7.0`, [któranie nie zawiera tego kodu](https://github.com/meilisearch/instant-meilisearch/blob/c38480c30d776989caae1bf3b1df4c72195dcf65/src/adapter/search-request-adapter/search-params-adapter.ts#L67). Opis wydania [v0.7.1](https://github.com/meilisearch/instant-meilisearch/releases/tag/v0.7.1)
