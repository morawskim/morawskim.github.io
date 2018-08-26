# Linux - globalne dodanie zaufanego certyfikatu SSL

## OpenSuSE Leap 15.0

W opensuse musimy skopiować nasz plik z certyfikatem (w formacie pem) do katalogu
`/etc/pki/trust/anchors/[NAZWA].pem`.

Następnie wywołujemy polecenie `/usr/sbin/update-ca-certificates`
Jeśli mamy uruchomioną jednostkę systemd `ca-certificates.path`, to nawet nie musimy wywoływać powyższego polecenia.

Ja wgrałem certyfikat SSL proxy. Dzięki temu widzę komunikację SSL między aplikacją/biblioteką a zdalnym serwerem.

```
curl --proxy 172.17.0.1:8088 https://google.com
```
