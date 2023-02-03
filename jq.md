# jq

Wyświetlenie długości tablicy: `. | length`

Filtrowanie listy: `map(select(.license.key == "mit"))`

Filtrowanie listy i mapowanie do inntej struktury: `map(select(.open_issues_count != 0) | { repo: .full_name, noOfIssues: .open_issues_count }  )`

Przykład: `curl 'https://api.github.com/users/morawskim/repos?per_page=40' | jq '{ repositories: [map(.full_name)], open_issues: map(select(.open_issues_count != 0) | { repo: .full_name, noOfIssues: .open_issues_count }  ), mit: map(select(.license.key == "mit") | { repo: .full_name, noOfIssues: .license.key }), totalRepositories: . | length }'`
