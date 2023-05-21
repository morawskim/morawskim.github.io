# Android termux

Na telefon pobieramy plik APK Termux ze strony [GitHub](https://github.com/termux/termux-app/releases).
W moim przypadku [termux-app_v0.118.0+github-debug_armeabi-v7a.apk](https://github.com/termux/termux-app/releases/download/v0.118.0/termux-app_v0.118.0+github-debug_armeabi-v7a.apk)
Następnie jeśli nie mamy włączonej opcji instalacji aplikacji APK z zewnętrznych źródeł, to musimy to zrobić.  W moim przypadku po pobraniu pliku przez Firefox Focus mogłem przejść do ustawień i zezwolić tej aplikacji na instalowanie plików APK.

Następnie uruchamiamy aplikacje Termux. 
W oknie konsoli wpisujemy `pkg update` a następnie `pkg install php`.
Jeśli nie wywołamy polecenia `pkg update` to podczas startu PHP otrzymamy błąd, że biblioteka `libopenssl` nie została znaleziona.

Tworzymy także nasz plik z kodem PHP np. wywołując polecenie `echo -e "<?php\n phpinfo();" > index.php`.
Możemy także zainstalować pakiet vim, aby edytować plik.

Następnie wywołujemy polecenie `ifconfig`, aby sprawdzić adres IP naszego interfejsu WiFi.
W moim przypadku adres IP to `192.168.50.200`.

Odpalamy wbudowany serwer HTTP w PHP poleceniem podając adres IP telefonu i port 4200 `php -S192.168.50.200:4200`.
Na innym urządzeniu możemy uruchomić przeglądarkę i wejść na stronę `192.168.50.200:4200`.

![Termux i PHP](./images/termux-php.png)

[This blog is hosted on my Android phone](https://androidblog.a.pinggy.io/)
