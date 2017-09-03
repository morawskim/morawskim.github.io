Pakiet rpm - sprawdzenie uprawnień plików
=========================================

Kiedy budujemy pakiety RPM, chcemy sprawdzić właściciela i uprawnienia do plików. Możemy to szybko wykonać za pomocą polecenia:

``` bash
rpm -ql susepaste-qt | xargs ls -la
-rwxr-xr-x 1 root root 103198 09-15 16:09 /usr/bin/susepaste-qt
-rw-r--r-- 1 root root    133 09-15 16:09 /usr/share/applications/susepaste-qt.desktop
-rw-r--r-- 1 root root    219 09-15 15:11 /usr/share/kde4/services/ServiceMenus/susepaste-qt_paste.desktop
```