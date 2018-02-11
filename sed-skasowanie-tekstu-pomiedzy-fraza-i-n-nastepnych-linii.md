# Sed - skasowanie tekstu pomiędzy frazą i n następnych linii

``` bash
sed  -e '/.*download.*/,+2d' yadm/Vagrantfile
```

W moim przypadku spwoodowało to usunięcie następujących lini:
```
-    rpm --import http://download.opensuse.org/repositories/systemsmanagement:/puppet/openSUSE_Leap_42.3/repodata/repomd.xml.key
-    zypper addrepo -n 'Systemsmanagement Puppet' http://download.opensuse.org/repositories/systemsmanagement:/puppet/openSUSE_Leap_42.3/ systemsmanag
-
```
