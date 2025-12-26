# SRE

* Praktycznie wszystko, co robią inżynierowie SRE, opiera się na naszej zdolności do wykonywania sześciu czynności: mierzenia, analizowania, podejmowania decyzji, działania, refleksji i powtarzania.

* Kolejny krok: idź wyżej. Ty i Twój przełożony musicie spotkać się z osobą na stanowisku wyższym od Twojego przełożonego, np. z dyrektorem. Wyjaśnij, dlaczego chcesz to zrobić teraz. Wymień korzyści, ryzyko i prawdopodobieństwo zmiany. Przygotuj się do omówienia skutków. Bądź gotowy na kompromis. Omów, dlaczego inne zespoły będą protestować. Wymień ryzyko, jeśli nie wprowadzimy tej zmiany.

* W przypadku wystąpienia incydentu musimy najpierw szybko podjąć kilka meta-decyzji:
    * Jaki jest wpływ na działalność firmy?
    * Czy zajmujemy się tym incydentem teraz, czy można go odłożyć na później?
    * Czy mamy czas na debugowanie, czy też powinniśmy zastosować awaryjną procedurę przełączenia awaryjnego?
Przed rozpoczęciem debugowania wiele odpowiedzi pozostaje nieznanych. Podczas krótkiej fazy wstępnej powiniśmy odpowiedzieć sobie na te pytania, zanim zagłębimy się długi proces debugowania.

* SRE polega na skupieniu się na kliencie — prawdziwym zrozumieniu doświadczeń i trudności związanych z korzystaniem z produktu w taki sam sposób, jak robią to klienci. Może to (i powinno) być podejście obecne u wszystkich pracowników firmy.

* Kiedy traktujemy incydenty jako okazję do uwidocznienia naszej pracy, radykalnie zmienia to wygląd naszych raportów po incydencie. Nacisk w tych raportach przesuwa się z działań zapobiegawczych na opis narracyjny.

* Poproś dwie osoby z zespołu o narysowanie schematu ogólnego systemu, którym dysponuje zespół, a następnie porównaj oba schematy. Podobieństwa i różnice między schematami prawdopodobnie ujawnią coś na temat modeli mentalnych, z których korzystają poszczególni członkowie zespołu podczas interakcji z systemem. Schematy są narzędziem komunikacji, ale przede wszystkim służą do rejestrowania i dzielenia się modelami mentalnymi. Ich największa siła nie polega na tym, co przedstawiają, ale na tym, jak wyrażają.

* Playbooks (znane również jako runbooki) w SRE to zbiory dokumentacji mające na celu pomóc osobie dyżurującej w rozwiązywaniu problemów. Istnieje wiele rodzajów podręczników, ale większość z tych, z którymi się spotkałem, charakteryzuje się tymi samymi antywzorcami.

* Pomysł testowania w środowisku produkcyjnym spotyka się zazwyczaj z dwoma rodzajami reakcji. Czasami spotyka się entuzjastyczne okrzyki radości, a innym razem zszokowane, pełne dezaprobaty spojrzenia. Jak wyjaśnić tę rozbieżność? Jest to jeden z najciekawszych paradoksów inżynierii. Często postrzegamy produkcję jako domek z kart – kruchy ekosystem, do którego należy podchodzić ostrożnie, w jedwabnych rękawiczkach lub kombinezonie ochronnym. Jednocześnie marzymy o obserwowalności.

* Z własnego doświadczenia wiem, że 1–2 tygodnie w tym samym miejscu wystarczyły, aby osoby przebywające w rozłące przez okres do 3 miesięcy nadal utrzymywały ten sam poziom zaufania i współpracy. Po 3 miesiącach relacje te zaczynały słabnąć i wymagały więcej czasu spędzonego razem, aby je odświeżyć.

* "Matematyka na serwetce" to proces wykonywania przybliżonych obliczeń, które zapewniają odpowiedź o określonym stopniu dokładności, gdy nie jesteś w stanie (lub nie musisz) zebrać dokładnych danych, opierając się zamiast tego na uproszczonych założeniach. To jest użyteczne do potwierdzenia opłacalności opcji lub zaweżenia zakresu możliwości, bez spędzenia godzin lub dni na bardziej skomplikowane kalkulacje.

* Nigdy nie pozwól klientom dostarczać Ci kodu; nalegaj na sprawdzoną konfigurację! Nigdy nie udzielaj umowy SLA na usługę zawierającą kod innych zespołów! Nigdy nie oferuj umowy SLA na usługę zawierającą niewiarygodne zależności! Nie możesz zrzec się odpowiedzialności za dogłębne zrozumienie tego, jak klienci korzystają z Twojej usługi. Broń swojej usługi i reputacji swojego zespołu w zakresie dobrej obsługi klienta!

* Były prezydent Stanów Zjednoczonych Dwight D. Eisenhower organizował swoją pracę według ważności i pilności. Ważne i pilne zadania wykonywał natychmiast, a te mniej ważne delegował lub ignorował. Najtrudniejszym kwadrantem macierzy Eisenhowera było przecięcie ważnych i niepilnych zadań — spraw, które miały znaczenie, ale które najłatwiej było odłożyć na później. Jakie było podejście Eisenhowera do tego rodzaju zadań? Planowanie.


## Książki

Emil Stolarsky i Jaime Woo, _97 Things Every SRE Should Know_, O'Reilly Media
