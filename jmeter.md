# JMeter

## JsonExtractor

Obecnie standardem w REST API jest zwracanie danych w formacie JSON. JMeter posiada wbudowany Post processor `Json Extractor`. Obsługuje on Json Path i za pomocą odpowiedniego selektora możemy wyciągnąć niezbędne informacje z dokumentu JSON. Specyfikacja Json Path bazuje na XML Path - [https://goessner.net/articles/JsonPath/](https://goessner.net/articles/JsonPath/). Warto przetestować nasz selektor wcześniej wykorzystując [JSONPath Online Evaluator](https://jsonpath.com/). Możemy także skorzystać z narzędzia online do [formatowania dokumentu JSON](https://jsonformatter.org/).

Następujący selektor pobierze id restauracji, której `name` równa się BurgeRoom - `$.data[?(@.name=="BurgeRoom")].id`

## JMeter properties i różne środowiska

Używając JMeter properties możemy wykorzystać skrypt sprawdzający wydajność z jednego środowiska w innym środowisku. Jedynie co będziemy musieli zrobić to nadpisać podczas wywołania JMeter właściwości.

Do testu dodajemy `User Defined Variables` i ustawiamy dwie zmienne:

* `appHostname` z wartością `${__P(appHostname, ssorder.lvh.me)}`. W przypadku nie podania właściwości appHostname, domyślna wartość `ssorder.lvh.me` zostanie użyta.
* `appProtocol` z wartością `${__P(appProtocol, http)}`. W przypadku braku właściwości domyślna wartość `http` zostanie użyta.

Modyfikujemy `HTTP Request Defaults` tak aby wykorzystywał nasze zmienne. Do pola `Protocol` podajemy `${appProtocol}`, zaś do pola "Server Name or IP" `${appHostname}`.

Podczas uruchamiania `jmeter` dodajemy parametry `-JappHostname=ssorder-develop.example.com -JappProtocol=https`.
Przykładowe pełne wywołanie CLI z raportem HTML i wynikami zapisanymi do pliku CSV - `./jmeter -JappHostname=ssorder-develop.snlb.pl -JappProtocol=https -n -t /path/to/jmeter/test.jmx -l /pat/to/results/performance.csv -e -o /path/to/save/html`

W przypadku posiada dużej liczby parametrów do nadpisania możemy utworzyć plik properties np. `uat.properties`. Następnie do parametrów wywołania JMeter dodajemy parametr `-q` z ścieżką do pliku.
Ważne aby korzystać z parametru `-q` a nie `-p`. Inaczej możemy otrzymywać błędy podczas generowania raportu "Error generating the report: org.apache.jmeter.report.dashboard.GenerationException: Cannot assign "${jmeter.reportgenerator.apdex_satisfied_threshold}" to property "set_satisfied_threshold" (mapped as "setSatisfiedThreshold"), skip it".
[Dokumentacja](https://jmeter.apache.org/usermanual/get-started.html#options) opisuje różnice między nimi.

>-p, --propfile <argument>
>    the jmeter property file to use
>
>-q, --addprop <argument>
>    additional JMeter property file(s)
