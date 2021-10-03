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

## Docker

Testy wydajnościowe możemy wywoływać z kontenera dockera wykorzystując obraz [justb4/jmeter](https://hub.docker.com/r/justb4/jmeter).
Wpierw pobieramy obraz poleceniem `docker pull justb4/jmeter:latest`. Następnie możemy przekazać te same parametry co do skryptu `jmeter`.
Przykładowe wywołanie: `docker run --rm -i -v ${PWD}:${PWD} -w ${PWD} justb4/jmeter -quat.properties -n -t performance.jmx -l performance.csv -e -o ./jmeter-html-report`

## Instalacja pluginów

Aby móc zarządzać pluginami z konsoli musimy pobrać dodatkowe biblioteki JAR. Dlatego warto skorzystać z poniższego pliku Makefile, który pobierze JMeter i zainstaluje plugin `bzm-parallel`.
Po utworzeniu pliku wywołujemy polecenie `make setup-jmeter`.

```
JMETER_VERSION := '5.4.1'
JMETER_CMD_VERSION := '2.2.1'
JMETER_PLUGIN_MANAGER_VERSION := '1.6'

setup-jmeter:
	@wget -Ojmeter.tgz https://dlcdn.apache.org/jmeter/binaries/apache-jmeter-$(JMETER_VERSION).tgz
	@tar -xvf jmeter.tgz
	@cd apache-jmeter-$(JMETER_VERSION)/lib && wget https://repo1.maven.org/maven2/kg/apc/cmdrunner/$(JMETER_CMD_VERSION)/cmdrunner-$(JMETER_CMD_VERSION).jar
	@cd apache-jmeter-$(JMETER_VERSION)/lib/ext && wget https://repo1.maven.org/maven2/kg/apc/jmeter-plugins-manager/$(JMETER_PLUGIN_MANAGER_VERSION)/jmeter-plugins-manager-$(JMETER_PLUGIN_MANAGER_VERSION).jar
	@cd apache-jmeter-$(JMETER_VERSION) && java  -jar lib/cmdrunner-$(JMETER_CMD_VERSION).jar --tool org.jmeterplugins.repository.PluginManagerCMD install bzm-parallel
	@rm jmeter.tgz
```

## Konfiguracja

### Zmiana języka interfejsu graficznego

Apache JMeter domyślnie używa ustawień regionalnych komputera.
Jednak lepiej jest tworzyć testy wykorzystując język angielski, ponieważ wszystkie nazwy opcji będą takie same jak w dokumentacji. Po drugie nie wszystkie opcje zostały przetłumaczone na język polski.
W pliku `jmeter.properties` (znajduje się on w katalogu `bin`) musimy odkomentować linię `language=en`.
Ta linia powinna znajdować się na początku pliku.
Zgodnie z [dokumentacją](https://jmeter.apache.org/usermanual/properties_reference.html#language) ten parametr może być ustawiony tylko w pliku `jmeter.properties`.

## Porady

Generując plik CSV z testów i otwierając go w programie Excel możemy sformatować wartość komórki `timestamp`. W nowej komórce wstawiamy formułę `=(((A2/1000/60)/60)/24)+DATA(1970;1;1)`. Przykład zakłada, że komórka `A2` zawiera timestamp. Następnie musimy wybrać format komórki. Wybieramy grupę Data lub Godzina i preferowany format.

Jeśli potrzebujemy dodać opóźnienie po wysłaniu próbki (np. żądania HTTP) to możemy wykorzystać element `Test Action Sampler`. Wartość opóźnienia możemy ustawić na sztywno albo skorzystać z funkcji random np. aby czekać pomiędzy 1 a 2 sekundami - `${__Random(1000, 2000)`.
