# Android AVD, SSL i proxy

W systemie Ubuntu instalujemy pakiety - `sudo apt get install google-android-platform-tools-installer google-android-emulator-installer google-android-cmdline-tools-11.0-installer`

Sprawdzamy dostepne wersje SDK Androida - `sdkmanager --list`

Instalujemy SDK - `sudo sdkmanager "system-images;android-33;google_apis;x86_64"`
Instalujemy platformę - `sudo sdkmanager "platforms;android-33"`
Jeśli  nie wykonamy tego kroku otrzymamy błąd przy uruchamianiu AVD:
> WARNING | platforms subdirectory is missing under /usr/lib/android-sdk/, please install it

Wyświetlamy dostępne profile urządzeń - `avdmanager list device`

Tworzymy wirtualne urządzenie - `avdmanager --verbose create avd --force --name "pixel_6_pro" --package "system-images;android-33;google_apis;arm64-v8a" --tag "google_apis" --abi "arm64-v8a" --device "pixel_6_pro"`

Wyświetlamy dostępne wirtualne urządzenia - `emulator -list-avds`.
Na liscie powinniśmy otrzymać utwrzone urządzenie "pixel_6_pro".

Uruchamiamy urządznie - `emulator -avd "pixel_6_pro" -writable-system -http-proxy adresIpProxy:port`

W moim przypadku w logach otrzymywałem:
> Could not connect to proxy at :8081: No such file or directory

Serwer proxy działał - mogłem z niego korzystać poprzez polecenie curl.
Sprawdziłem jaką wersję emulatora miałem zainstalowaną `sdkmanager --list` (szukamy emulator)
Korzystałem z wersji "34.1.19", wywołując polecenie `sudo sdkmanager "emulator"` zaaktualizowałem do wersji "35.2.10".
Z nowszą wersją problem z połączeniem z proxy zniknął.

Jeśli certyfikat proxy jest w formacie DER to go konwertujemy do formatu PEM:
```
(Source: https://book.hacktricks.xyz/mobile-pentesting/android-app-pentesting/install-burp-certificate)
openssl x509 -inform DER -in burp_cacert.der -out burp_cacert.pem
CERTHASHNAME="`openssl x509 -inform PEM -subject_hash_old -in burp_cacert.pem | head -1`.0"
mv burp_cacert.pem $CERTHASHNAME
```

Instalujemy certyfikat w wirtualnym urządzeniu.

```
adb root
adb remount
adb push $CERTHASHNAME /sdcard/
adb shell mv /sdcard/$CERTHASHNAME /system/etc/security/cacerts
adb shell chmod 644 /system/etc/security/cacerts/$CERTHASHNAME
adb reboot
```

W przypadku otrzymania błędu:
> mv: /system/etc/security/cacerts/9a5ba575.0: Read-only file system

Odpalamy konsolę `adb shell`.
Przełączamy się na konto root - `su` i wydajemy polecenie `mount -o remount,rw /system`.
Wychodzimy z powłoki ADB.
Ponawiamy polecenie `adb shell mv /sdcard/$CERTHASHNAME /system/etc/security/cacerts`. Tym razem plik powinnien zostać przeniesiony.

Uruchamiamy przeglądarkę internetową i przechodzimy na jakiś adres.
W moim przypadku Chrome wyświetliło błąd z certyfikatem SSL - ERR_CERTIFICATE_TRANSPARENCY_REQUIRED ([How to Fix ERR_CERTIFICATE_TRANSPARENCY_REQUIRED Error in Google Chrome?](https://aboutssl.org/how-to-fix-err-certificate-transparency-required-chrome/)).

Jednak mogłem zignorowac ten błąd.
Strona się załadowała, a w logu serwera proxy widziałem żądanie i odpowiedź HTTP.
