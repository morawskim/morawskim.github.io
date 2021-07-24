# JMeter

## JsonExtractor

Obecnie standardem w REST API jest zwracanie danych w formacie JSON. JMeter posiada wbudowany Post processor `Json Extractor`. Obsługuje on Json Path i za pomocą odpowiedniego selektora możemy wyciągnąć niezbędne informacje z dokumentu JSON. Specyfikacja Json Path bazuje na XML Path - [https://goessner.net/articles/JsonPath/](https://goessner.net/articles/JsonPath/). Warto przetestować nasz selektor wcześniej wykorzystując [JSONPath Online Evaluator](https://jsonpath.com/). Możemy także skorzystać z narzędzia online do [formatowania dokumentu JSON](https://jsonformatter.org/).

Następujący selektor pobierze id restauracji, której `name` równa się BurgeRoom - `$.data[?(@.name=="BurgeRoom")].id`
