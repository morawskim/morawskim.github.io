# Progressive web app

PWA to aplikacja internetowa, która stwarza wrażenie działania jako natywna aplikacja mobilna.
Jednym z wymogów działania PWA jest dostęp do strony tylko przez protokół HTTPS (nie dotyczy 127.0.0.1).
Jeśli korzystamy z wirtualnych hostów to możemy w przeglądarce chrome, wymusić aby traktował taką domenę jako bezpieczną. Musimy w przeglądarce przejść pod adres `chrome://flags/`. Następnie szukamy flagi `insecure`. Lista zostanie zawężona, a my szukamy flagi `Insecure origins treated as secure`. w polu tekstowym wpisujemy nazwę naszej domeny. Kolejne domeny rozdzielamy przecinkiem. Nazwa domeny musi zawierać protokół - `http`. Obok znajduje się przycisk pozwalający włączyć flagę. Włączamy flagę i klikamy w przycisk restartu przeglądarki.

Aplikacje PWA musimy wcześniej czy później zainstalować na telefonie. W przypadku systemu Andorid i przeglądarki Chrome możemy skonfigurować zdalne debugowanie i przekierowanie portów. Jeśli nasza aplikacja PWA jest serwowana przez protokół SSL to nie musimy przekierowywać portów. W przeglądarce mobilnej Chrome, także możemy włączyć traktowanie niektórych domen jako zaufanych. W niektórych przypadkach pomocna może być aplikacja `ngrok`, ktora tworzy tunel do lokalnego portu HTTP. Wywołując polecenie `ngrok http --host-header project.lvh.me  80` dostaniemy adres HTTP i HTTPS do naszej strony. `ngrok` automatycznie podmieni wartość nagłówka HTTP `Host` na `project.lvh.me`.

[View the app on a mobile device](https://codelabs.developers.google.com/codelabs/add-to-home-screen/#4)

[Get Started with Remote Debugging Android Devices](https://developers.google.com/web/tools/chrome-devtools/remote-debugging#remote-debugging-on-android-with-chrome-devtools)

[Access Local Servers - Port forwarding](https://developers.google.com/web/tools/chrome-devtools/remote-debugging/local-server?hl=en#use-port-forwarding-when-site-and-device-on-different-networks)


## Manifest

Manifesty aplikacji sieci Web są wdrażane na stronach HTML za pomocą elementu `<link>` w sekcji `<head>` dokumentu: `<link rel="manifest" href="/manifest.json">`

Aby aplikację można było zainstalować na telefonie muszą być spełnione warunki:

* aplikacja musi mieć zarejestrowany SW
* aplikacja powinna działać offline (Chrome DevTools wyświetla ostrzeżenie, jeśli aplikacja nie działa offline)
* ikona aplikacji powinna mieć rozdzielczość 512x512px
* nasza aplikacja powinna przejść audyt Lighthouse PWA/Installable

[Web App Manifest Generator](https://app-manifest.firebaseapp.com/)

[Walidator online dla Web App manifest](https://manifest-validator.appspot.com/)

[Web app manifests](https://developer.mozilla.org/en-US/docs/Web/Manifest)
