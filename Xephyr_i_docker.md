Xephyr i docker
===============

W systemie opensuse program Xephyr znajduje się w pakiecie xorg-x11-server-extra.

``` bash
sudo zypper in xorg-x11-server-extra
```

Uruchomienie Xephyr

``` bash
Xephyr -ac -screen 1280x1024 -br :1
```

Gdzie:


1 identyfikator wyświetlacza (liczone od 0)

-ac wyłącza kontrole dostępu -screen 1280x1024 ustawia rozmiar okna -br ustawia czarne tło

Odpalenie kwrtie w Xephyr

``` bash
DISPLAY=:1 kwrite
```

Uruchomienie kdeneon w docker

``` bash
Xephyr -ac -br -screen 1280x1024 :1
docker run -e DISPLAY=:1 -v /tmp/.X11-unix:/tmp/.X11-unix kdeneon/plasma:dev-stable
```

<http://csicar.github.io/docker/window-manger/2016/05/24/docker-wm.html> <http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/> <https://www.vandenoever.info/blog/2017/07/23/developing-kde-with-docker.html> <https://github.com/KDE/docker-neon>