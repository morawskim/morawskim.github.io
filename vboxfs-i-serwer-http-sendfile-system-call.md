# vboxfs i serwer HTTP (sendfile system call)

Pracowaliśmy na środowisku developerskim uruchomionym na maszynie wirtualnej (za pomocą vagranta). Nasz serwer http (nginx) zwracał starą zawartość pliku statycznego (js,css) jak był modyfikowany na maszynie gospodarza. Ustawienia daty i czasu były poprawne. Jak plik był edytowany na maszynie gościa, to serwer http zwracał nową zawartość pliku.
Pliki statyczne były współdzielone przez vboxfs. I to jego problem z wywołaniem systemowym `sendfile` doprowadza do tego błędu - https://forums.virtualbox.org/viewtopic.php?f=1&t=24905.

## nginx
W przypadku serwera http nginix w konfiguracji hosta dodajemy:

```
sendfile off;
```

## apache2
W przypadku serwera apache obsługę `sendfile` możemy wyłączyć w następujący sposób:

```
EnableSendfile off

#albo

<Directory "/path-to-vboxfs-files">
EnableSendfile Off
</Directory> 
```
Więcej informacji:
* http://httpd.apache.org/docs/2.4/mod/core.html#enablesendfile
* https://abitwiser.wordpress.com/2011/02/24/virtualbox-hates-sendfile/
* https://serverfault.com/questions/269420/disable-caching-when-serving-static-files-with-nginx-for-development


