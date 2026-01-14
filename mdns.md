# mDNS

mDNS (Multicast Domain Name System) to protokół, który umożliwia urządzeniom w sieci lokalnej rozpoznawanie nazw domenowych bez potrzeby korzystania z serwera DNS.
Działa poprzez wysyłanie zapytań do wszystkich urządzeń w sieci lokalnej za pomocą multicastu, co pozwala na uzyskanie adresu IP urządzenia na podstawie jego nazwy (np. drukarka.local).

Chcąc łączyć się z zdalnym urządzeniem po jego hostname musimy mieć na nim włączoną usługę avahi.
Avahi to otwarta implementacja mDNS.
Wywołując polecenie `systemctl status avahi-daemon.service` przekonamy czy usługa jest zainstalowana i czy działa.
W systemie Ubuntu niezbędne jest zainstalowanie pakietu `avahi-daemon`.

Na komputerze z którego chcemy sie łączyć w pliku `/etc/nsswitch.conf` powiniśmy mieć wpis dotyczący mdns:

```
#....
hosts:          files mdns4_minimal [NOTFOUND=return] dns
```

Wywołując polecenie `ping hostnameZdalnegoUrzadzenia.local` powiniśmy być wstanie spingować maszynę.

Na urządzeniach Windows 10/11 i Android mDNS działał beż zadnej dodatkowej konfiguracji.

## Reverse lookup

Możemy uzyskać nazwę hosta z adresu IP za pomocą mDNS, wykonując wyszukiwanie odwrotne w domenie `.local`.
Do tego celu służy narzędzie `avahi-resolve` (Linux najczęściej w ramach pakietu `avahi-utils`).

Przykład: `avahi-resolve -a 192.168.50.180`
W moim przypadku otrzymałem wynik:

> 192.168.50.180  marcin-Lenovo-B50-80.local
