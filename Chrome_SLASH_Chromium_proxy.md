Chrome/Chromium proxy
=====================

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