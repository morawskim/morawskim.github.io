# Audit - sprawdzenie kto odczytuje plik

Pakiet `audit` umożliwia dodanie zasad monitorowania dostępu do pliku.
Może to być przydatne jeśli wiemy, który plik konfiguracyjny trzeba zmienić, ale nie wiemy jaki program je wczytuje.

W dystrybucji openSUSE mamy dwa pliki, do których możemy dodawać zasaday.
Z moich testów wychodzi, że tylko zasady dodane do pliku `/etc/audit/audit.rules` są wczytywane.
Plik `/etc/audit/rules.d/audit.rules` jest ignorowany.

Listę aktualnych reguł możemy wyświetlić poprzez komendę:
``` bash
$ sudo auditctl -l
-w /home/vagrant/.bashrc -p r -k vagrant_bashrc
-w /etc/sysconfig/network/ -p rwxa -k mmo_network
```

Do pliku `/etc/audit/audit.rules` (po linii "# Feel free to add below this line. See auditctl man page")  dodajemy:
```
-w /home/vagrant/.bashrc -p r -k vagrant_bashrc
-w /etc/sysconfig/network/ -p rwxa -k mmo_network
```

Składnia reguły audytu plików to zazwyczaj:
`-w path-to-file -p permissions -k keyname`

Gdzie `permissions` to:
```
r - read of the file
w - write to the file
x - execute the file
a - change in the file's attribute
```

Uruchamiamy ponownie system.
Po zalogowaniu wydajemy polecenie, ktore wyświetli nam wpisy w logu mające przypisany klucz `mmo_network`:
```
sudo ausearch -k mmo_network > audit
```

Do polecenia `sudo ausearch -k mmo_network` możemy dodać parametr `-i`. Zamieni on np. identyfikator użytkownika na nazwę konta.
Zgodnie z dokumentacją:
> -i : Interpret numeric entities into text. For example, uid is converted to account name.


Plik ten będzie zawierał sporo lini. Aby sprawdzić jakie programy odczytują ten plik wydajemy takie polecenie:
``` bash
$ grep -E -o 'exe="[^"]+"' ./audit | sort | uniq
exe="/bin/bash"
exe="/usr/bin/mv"
exe="/usr/sbin/wicked"
```

Zmieniając ustawienia reguł, możemy np. monitorować kto modyfikuje plik.


Więcej informacji:
* https://www.cyberciti.biz/tips/linux-audit-files-to-see-who-made-changes-to-a-file.html
* https://www.digitalocean.com/community/tutorials/how-to-write-custom-system-audit-rules-on-centos-7
* Man audit.rules(7)
* Man auditctl (8)
