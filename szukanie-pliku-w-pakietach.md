# Szukanie pliku w pakietach

Czytając artykuły spotykamy się z sytuacją, kiedy trzeba zainstalować jakiś pakiet. Najczęściej podawana jest nazwa pakietu dla debian/ubuntu i fedory. Jeśli korzystamy z innej dystrybucji, to możemy spróbować wyszukać pakiet, na podstawie pliku, który powinien zawierać. Może to być np. plik nagłówkowy, wykonywalny czy też biblioteka.

```
Fedora = "yum provides '*/file'"
Debian/Ubuntu = "apt-file search file"
openSUSE = "zypper se --file-list file"
Slackware = "slackpkg file-search file"
ArchLinux = "pkgfile -si '*/file'"
```

Aby wyszukać pakiety w openSUSE, które zawierają w nazwie pliku 'php.h' wywołujemy polecenie:

```
zypper se --file-list php.h

....
S | Nazwa | Podsumowanie | Typ 
---+--------------+---------------------------------------------------------------------------+-------
i+ | php5-devel | Include files of PHP5 | pakiet
i+ | php53v-devel | Include files of php53 | pakiet
i+ | php54v-devel | Include files of php54v | pakiet
i+ | php55v-devel | Include files of PHP56 | pakiet
i+ | php56v-devel | Include files of PHP56 | pakiet
i+ | php70v-devel | Include files of PHP7 | pakiet
i+ | php71v-devel | Include files of PHP7.1 | pakiet
i+ | vagrant | Vagrant is a tool for building and distributing development environments. | pakiet

```
