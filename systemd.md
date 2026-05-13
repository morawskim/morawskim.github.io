# systemd

* Za każdym razem, gdy modyfikujemy lub dodajemy plik usługi, musimy wykonać `systemctl daemon-reload`.

* Wszelkie zmiany, które są wprowadzane w sekcji `[Install]` pliku usługi, wpływają na to, co dzieje się, gdy włączasz lub wyłączasz tę usługę.

* Jednostki target to coś więcej niż tylko poziomy uruchamiania (runlevels). Istnieje wiele różnych targetów, z których każdy ma swoje konkretne zastosowanie (`systemctl list-units -t target`).

W systemd target jest jednostką (ang. unit), która grupuje inne jednostki systemd w określonym celu.

Jednostki, które target może grupować, obejmują między innymi usługi (services), ścieżki (paths), punkty montowania (mount points), gniazda (sockets), a nawet inne targety.

## Dyrektywy

`EnvironmentFile=-/etc/default/foo` - powoduje, że systemd odczytuje listę zmiennych środowiskowych z podanego pliku.
Znak minus (-) znajdujący się przed ścieżką do pliku mówi, że jeśli ten plik nie istnieje, nie należy traktować tego jako błędu — usługa ma zostać uruchomiona mimo wszystko.

`RuntimeDirectory=foo` oraz `RuntimeDirectoryMode=0750` - te dwie dyrektywy tworzą katalog wewnątrz katalogu `/run`, a następnie ustawiają dla niego odpowiednie uprawnienia.

`Alias` - występuje w sekcji `[Install]`. Niektóre usługi mają różne nazwy w zależności od dystrybucji Linuksa.
Na przykład usługa SSH na systemach typu Red Hat nazywa się `sshd`, natomiast na Debianie/Ubuntu po prostu `ssh`.
Dodając linię `Alias=foo.service`, możemy zarządzać usługą używając dowolnej z tych nazw.

`Wants` - określa jednostki zależne dla tej usługi.
Jeśli te zależne jednostki nie działają w momencie uruchamiania usługi, systemd spróbuje je uruchomić.
Jeżeli jednak nie uda się ich uruchomić, ta usługa i tak zostanie uruchomiona.

`RefuseManualStop=yes` - wyłącza możliwość ręcznego uruchamiania, zatrzymywania i restartowania usługi. Przykładem jest `auditd.service` na systemach typu RHEL.
