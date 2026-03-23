# v4l2loopback

W systemie Ubuntu instalujemy pakiet `v4l2loopback-dkms`.

Następnie tworzymy wirtualne urządzenie wideo poleceniem: `sudo modprobe v4l2loopback devices=1 video_nr=10 card_label="Virtual Camera" exclusive_caps=1`

Za pomocą polecenia `v4l2-ctl --list-devices` wyświetlamy listę dostępnych urządzeń wideo. Na liście powinniśmy zobaczyć nowo utworzone urządzenie:

```
Virtual Camera (platform:v4l2loopback-000):
        /dev/video10

Integrated Camera: Integrated C (usb-0000:00:14.0-4):
        /dev/video0
        /dev/video1
        /dev/media0
```

Aby wyświetlić szczegóły kamery, używamy polecenia: `v4l2-ctl --device=/dev/video0 --all`

Za pomocą polecenia `ffmpeg -i /dev/video0 -f v4l2 -vcodec rawvideo -pix_fmt rgb24 /dev/video10` możemy skopiować strumień z kamery (/dev/video0) do naszej wirtualnej kamery.

Strumień wideo z kamery możemy wyświetlić za pomocą polecenia: `ffplay /dev/video10`

Moduł jądra Linuksa możemy usunąć z pamięci poleceniem: `sudo rmmod v4l2loopback`

[Arch Linux v4l2loopback](https://wiki.archlinux.org/title/V4l2loopback)

### ffmpeg

Za pomocą polecenia: `ffmpeg -re -stream_loop -1 -i /sciezka/do/pliku.mp4 -vf format=yuv420p -f v4l2 /dev/video10` możemy przesłać obraz z pliku wideo do naszego wirtualnego urządzenia wideo.
