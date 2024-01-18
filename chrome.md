# Google chrome

## Porady

Możemy bezpośrednio w pasku adresu przeszukiwać otwarte katy, zakładki i historię przeglądarki. Wystarczy, że w pasku adresu wpiszemy odpowiednio @karty, @zakładki albo @historia i potwierdzimy przyciskiem [Tab]. Na pasku adresu powinien pojawić się napis "Szukaj na stronie Karty/Zakładki/Historia", a my będziemy w stanie podać szukaną frazę.

Za pomocą skrótu [Ctrl] + [Shift] + [A] możemy otworzyć menu z otwartymi kartami i wyszukać otwartą kartę, albo ostatnio zamknięto.

## Flagi
| Opcja  |Opis   |
|---|---|
|`--ignore-certificate-errors`|Ignorowanie błędów z certyfikatami SSL|
|`--ignore-ssl-errors`|Ignorowanie blędów SSL/TLS|
|`--proxy-server="localhost:8080"`|Ustawia serwer proxy, który ma zostac użyty|
|`--user-data-dir=/SCIEZKA`|Katalog z profilem użytkownika|

Więcej przydatnych flag:
https://github.com/deepsweet/chromium-headless-remote

## Chrome/Chromium proxy

Pomimo wbudowania narzędzi deweloperskich w przeglądarki, czasem może być przydatna funkcja skonfigurowania serwera proxy. Jest to żmudna czynność, ponieważ po skończonej pracy musimy przywrócić ustawienia. Warto więc utworzyć plik desktop i dodać wymagane parametry proxy do pliku wykonywalnego przeglądarki.

Zacznijmy od skopiowania pliku desktop dostarczonego z przeglądarką.

``` bash
rpm -ql chromium | grep desktop
/usr/share/applications/chromium-browser.desktop

cp /usr/share/applications/chromium-browser.desktop $HOME/.local/share/applications/chromium-browser-zap-proxy.desktop
```

Musimy edytować klucz "Exec". Dodajemy argument --proxy-server="localhost:8080". W przypadku, gdy serwer proxy nasłuchuje na innym porcie/adresie dostosowujemy parametr. Po zmianie nasz plik powinien wyglądać podobnie do poniższego (dodatkowo zmieniłem klucz Name i GenericName)

```
[Desktop Entry]
Version=1.0
Name=Chromium Web Browser via ZAP proxy
Comment=Browse the World Wide Web
GenericName=Web Browser via ZAP proxy
Exec=chromium --proxy-server="localhost:8080" %u
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=chromium-browser
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
StartupWMClass=Chromium

X-Desktop-File-Install-Version=0.22
```

## Pomoc zdalna

Za pomocą chrome możemy udostępnić pulpit innemu użytkownikowi - [Pomoc zdalna](https://remotedesktop.google.com/support?pli=1). Obaj użytkownicy muszą być zalogowani na swoje konto Google.

## Pluginy

### Boomerang - SOAP & REST Client
[Seamlessly integrate and test SOAP & REST services.](https://chrome.google.com/webstore/detail/boomerang-soap-rest-clien/eipdnjedkpcnlmmdfdkgfpljanehloah?hl=pl)

### ColorZilla
[Advanced Eyedropper, Color Picker, Gradient Generator and other colorful goodies](https://chrome.google.com/webstore/detail/colorzilla/bhlhnicpbhignbdhedgjhgdocnmhomnp?hl=pl)

### CSS Dig
[Collect and analyze CSS.](https://chrome.google.com/webstore/detail/css-dig/lpnhmlhomomelfkcjnkcacofhmggjmco?hl=pl)

### ModHeader - Modify HTTP headers
[Modify HTTP request headers, response headers, and redirect URLs](https://chrome.google.com/webstore/detail/modheader-modify-http-hea/idgpnmonknjnojddfkpgkljpfnnfcklj?hl=pl)

### Plasma Integration
[Provides better integration with the KDE Plasma 5 desktop.](https://chrome.google.com/webstore/detail/plasma-integration/cimiefiiaegbelhefglklhhakcgmhkai?hl=pl)

### React Developer Tools
[Adds React debugging tools to the Chrome Developer Tools.](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi?hl=pl)

### Redux DevTools
[Redux DevTools for debugging application's state changes.](https://chrome.google.com/webstore/detail/redux-devtools/lmhkpmbekcpmknklioeibfkpmmfibljd?hl=pl)

### URL Throttler
[An extension that lets you delay the response from specific URLs](https://chrome.google.com/webstore/detail/url-throttler/kpkeghonflnkockcnaegmphgdldfnden?hl=pl)

### Web Developer
[Adds a toolbar button with various web developer tools.](https://chrome.google.com/webstore/detail/web-developer/bfbameneiokkgbdmiekhjnmfkcnldhhm?hl=pl)

### Window Resizer
[Resize the browser window to emulate various screen resolutions.](https://chrome.google.com/webstore/detail/window-resizer/kkelicaakdanhinjdeammmilcgefonfh?hl=pl)

### Proxy SwitchyOmega
[Manage and switch between multiple proxies quickly & easily.](https://chromewebstore.google.com/detail/proxy-switchyomega/padekgcemlokbadohgkifijomclgjgif?hl=vi&pli=1)

### OWASP Penetration Testing Kit
[The Penetration Testing Kit (PTK) browser extension is your all-in-one solution for streamlining your daily tasks in the realm of application security. ](https://chromewebstore.google.com/detail/ojkchikaholjmcnefhjlbohackpeeknd)

### Instant Data Scraper
[Instant Data Scraper extracts data from web pages and exports it as Excel or CSV files](https://chromewebstore.google.com/detail/instant-data-scraper/ofaokhiedipichpaobibbnahnkdoiiah?hl=en)

### Tamper Dev
[Intercept and edit HTTP/HTTPS requests and responses as they happen without the need of a proxy.](https://chromewebstore.google.com/detail/tamper-dev/mdemppnhjflbejfbnlddahjbpdbeejnn)
