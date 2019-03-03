# maven - snippets

## Luźne sprawdzanie certyfikatów

Ustawienie flagi `-Dmaven.wagon.http.ssl.insecure=true` umożliwia luźne sprawdzanie certyfikatów SSL generowanych przez użytkowników.

`mvn -Dmaven.wagon.http.ssl.insecure=true install`
