# ffmpeg

## Konwersja wideo do MP4

W jednym z projektów musieliśmy przekonwertować wideo do inego formatu, ponieważ wynikowy plik wideo z nagrywaki DVR nie był obsługiwany przez przeglądarki.
Wideo było w kontenerze MPEG, amy potrzebowaliśmy MP4.

Pobieramy obraz fedory - `docker pull fedora:39`
Następnie instalujemy ffmpeg - `dnf install -y ffmpeg-free`
Włączamy dodatkowe repozytorium, które obsługuje kod h264:

```
dnf -y install 'dnf-command(config-manager)' && \
   dnf -y config-manager --set-enabled fedora-cisco-openh264 && \
   dnf -y install gstreamer1-plugin-openh264 mozilla-openh264
```

Finalnie możemy wywołać polecenie do konwersji video `ffmpeg -i /tmp/video-to-convert -c:v copy -c:a pcm_s16le /tmp/converted-video.mp4`
