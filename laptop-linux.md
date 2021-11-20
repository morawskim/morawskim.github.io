# Laptop i Linux

## Instalatory dystrybucji i karta nvidia

Próbując zainstalować różne dystrybucje na laptopie miałem problem z instalatorami. Po wybraniu opcji instalacji wracałem do menu wyboru (po procesie ładowania). Jednak przy dystrybucji Kubuntu wybierając opcję `Safe graphics` wszystko przebiegło bez problemu. W laptopie miałem kartę nvidia. Postanowiłem przy innej dystrybucji dodać parametr rozruchowy jądra `nomodeset`. Instalator się odpalił. Finalnie wyłączyłem sterownika nvidi poprzez parametr rozruchowy `nouveau.modeset=0` i tak zainstalowałem system. Po instalacji system wczytał się normalnie.
