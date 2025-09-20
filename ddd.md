# DDD

Dziedzina biznesowa definiuje główny obszar działalności firmy.
Jest to usługa, którą firma świadczy swoim klientom.

Eksperci dziedzinowi nie są analitykami zbierającymi wymagania ani inżynierami projektującymi system.
Są reprezentantami biznesu. To ludzie, którzy zidentyfikowali problem biznesowy i od których pochodzi cała wiedza biznesowa.
Analitycy systemowi i inżynierowie przekształcają własną wizję modeli dziedziny biznesowej w wymagania dotyczące oprogramowania, a następnie w kod źródłowy.
Oprogramowanie jest budowane po to, by rozwiązywało problemy ekspertów dziedzinowych.

## Projektowanie stategiczne vs taktyczne

### Projektowanie strategiczne

Celem projektu strategicznego jest zrozumienie problemu biznesowego (czyli Dziedziny) i podzielenie go na mniejsze, rozwiązywalne i powiązane ze sobą zadania.
Współpracujemy z ekspertami dziedzinowymi komunikując się językiem dziedziny.
Niezrozumienie Dziedziny Biznesowej skutkuje nieoptymalną implementacją oprogramowania biznesowego.
Według badań około 70% projektów oprogramowania nie jest dostarczanych na czas, w ramach budżetu lub zgodnie z wymaganiami klienta.
Strategiczny aspekt DDD dotyczy odpowiedzi na pytania "co?" i "dlaczego?" - tzn. jakie oprogramowanie budujemy i dlaczego je budujemy.

### Projektowanie taktyczne

Przekształca wnioski wyciągnięte podczas fazy projektowania strategicznego w architekturę oprogramowania.
Do tego celu korzystamy z Entity, DTO, ValueObject, Aggregate, zdarzeń domenowych itd.
Część taktyczna dotyczy odpowiedzi na pytanie "jak?" - tzn. w jaki sposób implementujemy każdy komponent.

## Poddziedziny

Poddziedziny charakteryzują się różnymi wartościami strategicznymi i biznesowymi.
W DDD można wyróżnić trzy typy poddziedzin: Podstawowe, Ogólne i Pomocnicze.

### Poddziedzina Podstawowa

Poddziedzina podstawowa jest źródłem przewagi konkurencyjnej.
To, co firma robi inaczej w porównaniu z jej konkurentami i co ją wyróżnia na tle konkurencji.
Poddziedziny te niekoniecznie są techniczne.

Poddziedziny Podstawowe są złożone, ponieważ prosta poddziedzina podstawowa może zapewniać jedynie krótkotrwałą przewagę konkurencyjną.

Poddziedziny podstawowe są również nazywane Dziedzinami Podstaowymi.
Nazwa Poddziedzina podstawowa jednak lepiej odróżnia je od Dziedziny Biznesowej.

Poddziedziny ciągle ewoluują i poddziedzina podstawowa może przekształcić się w poddziedzinę ogólną.

### Poddziedzina Ogólna

Poddziedziny ogólne to działania, które wszystkie firmy wykonują w ten sam sposób.
Są na ogół złożone i trudne do zaimplementowania.
Poddziedziny ogólne nie zapewniają jednak firmie żadnej przewagi konkurencyjnej.
Nie ma potrzeby innowacji ani optymalizacji.

Przykładem może być mechanizm uwierzytelniania i autoryzacji użytkownika.
Zamiast pisać własny mechanizm, możemy skorzystać z najlepszych praktyk i gotowych rozwiązań np. OpenID Connect.

### Poddziedziny Pomocnicze

Poddziedziny pomocnicze wspierają działalność firmy. Jednak w przeciwieństwie do poddziedzin podstawowych nie zapewniają przewagi konukrencyjnej.

Logika tej poddziedziny jest prosta. Są to podstawowe operacje ETL i interfejsy CRUD.

W celu rozróżnienia poddziedziny pomocniczej od ogólnej możemy odpowiedzieć na pytanie: "czy byłoby łatwiej i taniej stworzyć własną implementację zamiast integrować zewnętrzną". Jeśli tak, to jest to poddziedzina pomocnicza.
