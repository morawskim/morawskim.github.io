# Flutter i Anroid

W systemie Ubuntu instalujemy pakiet snap `flutter`.

Następnie uruchamiamy polecenie `flutter doctor` aby sprawdzić informacje o zainstalowanych narzędziach.

Wyłączamy raportowanie telemetryczne poleceniem `flutter config --no-analytics`

[A Beginner's guide: Setting up your first flutter Application ](https://dev.to/techifydev/a-beginners-guide-setting-up-your-first-flutter-application-2jm5)

[https://pub.dev/](The official package repository for Dart and Flutter apps)


Akceptujemy licencje Androida: `flutter doctor --android-licenses`

W Android Studio instalujemy wtyczki: Dart i Flutter.

Jeśli Flutter został zainstalowany przez snap, ścieżka do Dart SDK to: `~/snap/flutter/common/flutter/bin/cache/dart-sdk`

Ścieżkę do Flutter SDK można wyświetlić poleceniem: `flutter sdk-path`. Przykładowy wynik: "/home/marcin/snap/flutter/common/flutter"

Instalujemy zależności projektu: `flutter pub get`

Budujemy APK `flutter build apk --debug`

Wyświetlamy listę dostępnych emulatorów: `emulator -list-avds`

```
pixel_6_pro
pixel_6_pro_arm
pixel_6_pro_arm2
```

Uruchamiamy emulator: `emulator -avd pixel_6_pro`

Instalujemy aplikację Flutter: `adb install path_to_apk`

Przekierowanie portu (np. dla połączenia z backendem): `adb reverse tcp:8096 tcp:8096`.
Adres IP 10.0.2.2 w emulatorze odnosi się do adresu hosta.

Zatrzymujemy emulator: `adb emu kill`

Aby włączyć obsługę fizycznej klawiatury, w pliku konfiguracyjnym: `~/.android/avd/[NAZWA_EMULATORA].avd/config.ini` zmieniamy linię `hw.keyboard=yes`.
