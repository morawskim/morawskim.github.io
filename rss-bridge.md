# RSS-Bridge - własny bridge

Pobieramy kod źródłowy poleceniem `https://github.com/RSS-Bridge/rss-bridge.git`.
Następnie modyfikujemy plik `docker-compose.yml`

```
Index: docker-compose.yml
IDEA additional info:
Subsystem: com.intellij.openapi.diff.impl.patch.CharsetEP
<+>UTF-8
===================================================================
diff --git a/docker-compose.yml b/docker-compose.yml
--- a/docker-compose.yml	(revision 4513bdecc7d69c9a7c3b88a76006c0b4cfc7952d)
+++ b/docker-compose.yml	(date 1771074394568)
@@ -1,9 +1,14 @@
-version: '2'
 services:
   rss-bridge:
     image: rssbridge/rss-bridge:latest
     volumes:
       - ./config:/config
+      - ./:/app
     ports:
       - 3000:80
-    restart: unless-stopped
+    environment:
+      XDEBUG_MODE: develop,debug
+      XDEBUG_CONFIG: "client_host=${MY_IP:-172.17.0.1} discover_client_host=0 client_port=9003"
+      XDEBUG_TRIGGER: "default_no_matter"
+      PHP_IDE_CONFIG: "serverName=${DEV_SERVER_NAME:-rss-bridge}"
+
```

Wprowadzamy zmiany:

* usuwamy klucz `version`
* montujemy katalog projektu do /app w kontenerze
* dodajemy zmienne środowiskowe potrzebne do konfiguracji Xdebug 3

Uruchamiamy stos - `docker compose up -d`.
Po uruchomieniu kontenera wchodzimy na `localhost:3000`.
Powinniśmy zobaczyć interfejs RSS-Bridge.

Modyfikujemy kod istniejącego bridge albo tworzymy nowy.
Jeśli chcemy utworzyć własny obraz RSS-Bridge zawierający wprowadzone przez nas zmiany, modyfikujemy plik Dockerfile.

```
Index: Dockerfile
IDEA additional info:
Subsystem: com.intellij.openapi.diff.impl.patch.CharsetEP
<+>UTF-8
===================================================================
diff --git a/Dockerfile b/Dockerfile
--- a/Dockerfile	(revision ba6cab67c0b61a93a687accd54759285e7e79bf2)
+++ b/Dockerfile	(date 1771075380828)
@@ -1,8 +1,9 @@
 FROM debian:12-slim AS rssbridge

 LABEL description="RSS-Bridge is a PHP project capable of generating RSS and Atom feeds for websites that don't have one."
-LABEL repository="https://github.com/RSS-Bridge/rss-bridge"
+LABEL repository="https://github.com/morawskim/rss-bridge"
 LABEL website="https://github.com/RSS-Bridge/rss-bridge"
+LABEL org.opencontainers.image.source="https://github.com/morawskim/rss-bridge"

 ARG DEBIAN_FRONTEND=noninteractive
 RUN set -xe && \
```

Zmieniamy wartość etykiety repository, aby nasz obraz opublikował się w dobrym miejscu w serwisie GitHub.
Następnie budujemy obraz `docker build -t ghcr.io/morawskim/rss-bridge:mytag .`.
I wysyłamy obraz `docker push ghcr.io/morawskim/rss-bridge:mytag`
