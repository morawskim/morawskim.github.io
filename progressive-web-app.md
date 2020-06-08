# Progressive web app

PWA to aplikacja internetowa, która stwarza wrażenie działania jako natywna aplikacja mobilna.
Jednym z wymogów działania PWA jest dostęp do strony tylko przez protokół HTTPS (nie dotyczy 127.0.0.1).
Jeśli korzystamy z wirtualnych hostów to możemy w przeglądarce chrome, wymusić aby traktował taką domenę jako bezpieczną. Musimy w przeglądarce przejść pod adres `chrome://flags/`. Następnie szukamy flagi `insecure`. Lista zostanie zawężona, a my szukamy flagi `Insecure origins treated as secure`. w polu tekstowym wpisujemy nazwę naszej domeny. Kolejne domeny rozdzielamy przecinkiem. Nazwa domeny musi zawierać protokół - `http`. Obok znajduje się przycisk pozwalający włączyć flagę. Włączamy flagę i klikamy w przycisk restartu przeglądarki.

Aplikacje PWA musimy wcześniej czy później zainstalować na telefonie. W przypadku systemu Andorid i przeglądarki Chrome możemy skonfigurować zdalne debugowanie i przekierowanie portów. Jeśli nasza aplikacja PWA jest serwowana przez protokół SSL to nie musimy przekierowywać portów. W przeglądarce mobilnej Chrome, także możemy włączyć traktowanie niektórych domen jako zaufanych. W niektórych przypadkach pomocna może być aplikacja `ngrok`, która tworzy tunel do lokalnego portu HTTP. Wywołując polecenie `ngrok http --host-header project.lvh.me  80` dostaniemy adres HTTP i HTTPS do naszej strony. `ngrok` automatycznie podmieni wartość nagłówka HTTP `Host` na `project.lvh.me`.

[View the app on a mobile device](https://codelabs.developers.google.com/codelabs/add-to-home-screen/#4)

[Get Started with Remote Debugging Android Devices](https://developers.google.com/web/tools/chrome-devtools/remote-debugging#remote-debugging-on-android-with-chrome-devtools)

[Access Local Servers - Port forwarding](https://developers.google.com/web/tools/chrome-devtools/remote-debugging/local-server?hl=en#use-port-forwarding-when-site-and-device-on-different-networks)


## Manifest

Manifesty aplikacji sieci Web są wdrażane na stronach HTML za pomocą elementu `<link>` w sekcji `<head>` dokumentu: `<link rel="manifest" href="/manifest.json">`

[Web App Manifest Generator](https://app-manifest.firebaseapp.com/)

[Walidator online dla Web App manifest](https://manifest-validator.appspot.com/)

[Web app manifests](https://developer.mozilla.org/en-US/docs/Web/Manifest)


## Instalacja PWA (Add to Home Screen)

Aby aplikację można było zainstalować na telefonie muszą być spełnione warunki:

* aplikacja musi mieć zarejestrowany Service Worker
* aplikacja powinna działać offline (Chrome DevTools wyświetla ostrzeżenie, jeśli aplikacja nie działa offline)
* ikona aplikacji powinna mieć rozdzielczość 512x512px
* nasza aplikacja powinna przejść audyt Lighthouse PWA/Installable
* [What does it take to be installable?](https://web.dev/en/install-criteria/)
* [Provide a custom install experience](https://web.dev/en/customize-install/)


## Web push

Push API umożliwia aplikacji internetowej otrzymanie wiadomości z serwera, niezależnie od tego czy aplikacja czy też przeglądarka jest uruchomiona. W celu implementacji web push musimy wykonać następujące kroki:

1. Ten krok jest opcjonalny. Akceptacja web push powoduje nadanie uprawnień do wyświetlenia powiadomień (Notification API). Możemy wykorzystać bibliotekę [Push](https://pushjs.org/). Dobrą praktyką jest wykorzystanie wzorca `Double Permission` podczas pytania o różnego pozwolenia - https://web-push-book.gauntface.com/permission-ux/

1. Mając zgodę na wyświetlanie powiadomień możemy utworzyć prośbę o subskrypcję push. Podobnie jak w przypadku Notification API warto korzystać z wzorca `Double Permission`. Za pomocą metody `PushManager.permissionState` sprawdzimy aktualny stan uprawnienia.

1. Jeśli użytkownik zgodził się na powiadomienia metoda `PushManager.subscribe()` zwróci Promise, z obiektem `PushSubscription`. Zawiera on szczegóły subskrypcji. Podczas wywoływania metody `subscribe` musimy podać klucz VAPID, który często nazywany jest także application server key. Jest to klucz publiczny, który generowaliśmy np. za pomocą polecenia `bin/console webpush:generate:keys`. Umożliwia on usłudze push potwierdzenie kto wysłał wiadomość. Po stronie serwera przechowujemy klucz prywatny, którym podpisujemy naszą wiadomość push. Usługodawca mając nasz klucz publiczny, będzie mógł potwierdzić dostęp. Dodatkowo parametr `userVisibleOnly` musi być ustawiony na wartość `true` - [https://web-push-book.gauntface.com/subscribing-a-user/#uservisibleonly-options](https://web-push-book.gauntface.com/subscribing-a-user/#uservisibleonly-options)

1. Obiekt `PushSubscription` przesyłamy na serwer (serializując go do formatu JSON), zapisując w bazie danych. W przypadku PHP/Symfony możemy skorzystać z biblioteki [bentools/webpush-bundle](https://github.com/bpolaszek/webpush-bundle).

1. W SW dodajemy handler dla zdarzeń `push` i `notificationclick`. Opcjonalnie także dla `notificationclose`. Powiadomienie musimy wyświetlić w odpowiednim momencie [inaczej przeglądarka wyświetli domyślny komunikat](https://web-push-book.gauntface.com/faq/#why-do-i-get-the-this-site-has-been-updated-in-the-background).

[Web Push Book (Online)](https://web-push-book.gauntface.com/)

[MDN Push API](https://developer.mozilla.org/en-US/docs/Web/API/Push_API)

[Building a PWA in Vanilla JavaScript - Part 2: Push API](https://alligator.io/js/push-api/)

[Developing Progressive Web Apps 08.0: Integrating web push](https://codelabs.developers.google.com/codelabs/pwa-integrating-push/#0)

## Service Workers

Service Workers (SW) umożliwiają aplikacji przechwytywanie i buforowanie zapytań i odpowiedzi HTTP. SW to punkt startowy do implementowania funkcjonalności, które sprawiają, że aplikacja zaczyna działać jak natywna. Niektóre API:

* [Notification API](https://developer.mozilla.org/en-US/docs/Web/API/Notifications_API)

* [Push API](https://developer.mozilla.org/en-US/docs/Web/API/Push_API)

* [Background Sync API](https://wicg.github.io/background-sync/spec/)

Nie mamy większego wpływu na cykl życia SW. Przeglądarka decyduje kiedy zresetować/uruchomić wątek SW i kiedy go zakończyć. Dlatego w funkcjach obsługi zdarzeń korzystamy z metody `event.waitUntil`, aby poinformować przeglądarkę że ciągle robimy ważne rzeczy. Przeglądarka będzie oczekiwać aż obiekt `Promise` który przekazujemy osiągnie status `settled`.  Nie możemy bazować na globalnym stanie wewnątrz SW. Jeśli chcemy coś utrwalić musimy korzystać z IndexedDB API.

Przeglądarki gwarantują, że jednocześnie działa tylko jedna wersja SW. Większość przeglądarek domyślnie ignoruje nagłówki cache, kiedy sprawdzają czy jest dostępna aktualizacja skryptu SW.
Automatycznie sprawdzana jest dostępność aktualizacji SW, ale możemy [wymusić to programowo](https://developers.google.com/web/fundamentals/primers/service-workers/lifecycle#manual_updates). Dodatkowo możemy nasłuchiwać na zdarzenie [updatefound](https://developer.mozilla.org/en-US/docs/Web/API/ServiceWorkerRegistration#Examples) i powiadomić użytkowników o dostępnej nowej wersji SW.
