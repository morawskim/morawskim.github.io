# Firefox

## Wyłączenie WebGL

Wyłączenie WebGL może zwiększyć prywatność podczas przeglądania internetu.

Otwieramy nową kartę w przeglądarce i przechodzimy na adres `about:config`. 
Następnie wyszukujemy parametr `webgl.disabled` i ustawiamy go na wartość `true`.

## Fingerprinting / Poprawa prywatności

Otwieramy nową kartę w przeglądarce i przechodzimy na adres `about:config`.

Następnie szukamy ustawienia `privacy.resistFingerprinting` i przełączamy je na wartość `true`.

Inny rozwiązanie to wykorzystanie rozszerzenia [CanvasBlocker](https://addons.mozilla.org/pl/firefox/addon/canvasblocker/).

Nasze zmiany poprawiające prywatność możemy przetestować na stronie [Am I Unique?](https://amiunique.org/fingerprint).

### Izoluj ciasteczka

Otwieramy nową kartę w przeglądarce i przechodzimy na adres `about:config`.

Następnie szukamy ustawienia `privacy.firstparty.isolate` i przełączamy na wartość `true`.

Zapobiega to śledzeniu za pomocą ciasteczek między różnymi stronami, ale może spowodować problemy z logowaniem SSO na niektórych witrynach.

### Dodatkowe czynności

Otwórz nową kartę w przeglądarce i przejdź pod adres `about:preferences`.

W zakładce `Privacy & Security` przewiń w dół do sekcji "HTTPS-Only Mode" i wybierz opcję "Enable HTTPS-Only Mode in all windows"

W tej samej zakładce "Privacy & Security" możesz wyłączyć przesyłanie danych telemetrycznych do Mozilla. Przewiń do sekcji "Firefox Data Collection and Use" i odznacz wszystkie pola wyboru.

Nadal w zakładce "Privacy & Security", w górnej części strony, ustaw tryb "Enhanced Tracking Protection" na wartość "Strict". To zapewnia silniejszą ochronę przed modułami śledzącymi. Jeśli jakaś strona przestanie działać prawidłowo, możesz łatwo wyłączyć tę funkcję dla danej witryny, klikając ikonę tarczy na pasku adresu.

Możemy także zainstalować dodatkowe rozszerzenia:

* uBlock Origin - blokuje reklamy i skrypty śledzące, przyspieszając ładowanie stron i zwiększając prywatność

* ClearURLs - automatycznie usuwa elementy śledzące z adresów URL

* Privacy Badger (od Electronic Frontier Foundation) -  - automatycznie uczy się blokować niewidoczne moduły śledzące. Zamiast polegać na listach blokowania, wykrywa śledzące elementy na podstawie ich zachowania.

## Wyłączenie menedżera haseł

Klikamy na "Hamburger menu" i wybieramy opcję "Settings".
Następnie z menu po lewej wybieramy "Privacy and Security".
Przewijamy stronę do sekcji "Passwords" i odznaczamy checkbox "Ask to save passwords".

![Wyłącz menedżera haseł](./images/firefox-save-password.png)
