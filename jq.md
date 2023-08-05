# jq

Wyświetlenie długości tablicy: `. | length`

Filtrowanie listy: `map(select(.license.key == "mit"))`

Filtrowanie listy i mapowanie do inntej struktury: `map(select(.open_issues_count != 0) | { repo: .full_name, noOfIssues: .open_issues_count }  )`

Przykład: `curl 'https://api.github.com/users/morawskim/repos?per_page=40' | jq '{ repositories: [map(.full_name)], open_issues: map(select(.open_issues_count != 0) | { repo: .full_name, noOfIssues: .open_issues_count }  ), mit: map(select(.license.key == "mit") | { repo: .full_name, noOfIssues: .license.key }), totalRepositories: . | length }'`

## Inne formaty XML, YAML

Do obsługi innych formatów plików możemy skorzystać z innych programów.

Jednym z nich jest [yq](https://github.com/mikefarah/yq). Został on stworzony w języku Go  co ułatwia instalację. Dodatkowo dostępny jest pakiet snap wykorzystywany m.in. przez dystrybucję Ubuntu.
W przypadku stosowania tej aplikacji, aby filtrować dane z pliku XML musimy ustawić parametr `-p` na wartość xml:
> -p, --input-format string           [yaml|y|xml|x] parse format for input. Note that json is a subset of yaml. (default "yaml")

Alternatywą jest aplikacja napisana w Python - [yq: Command-line YAML/XML/TOML processor - jq wrapper for YAML, XML, TOML documents](https://github.com/kislyuk/yq)
