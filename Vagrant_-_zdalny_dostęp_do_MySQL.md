Vagrant - zdalny dostęp do MySQL
================================

Vagrant pozwala współdzielić środowisko developerskie między programistami. Czasem z Vagranta mogą także korzystać testerzy. Tworzą oni dane i zgłaszają jakieś problemy. Ponieważ posiadają inne dane, trudniej jest znaleźć przyczynę błędu. Można jednak utworzyć tunel między maszyną vagranta testera, a naszym linuxem.

1. Na komputerze testera odpalamy standardowo

``` bash
vagrant up
```

Kiedy maszyna się uruchomi, logujemy się do niej przez ssh

``` bash
vagrant ssh
```

Tworzymy zdalny tunel do naszego linuxa

``` bash
ssh NAZWA_UZYTKOWNIKA@NASZ_ADRES_IP -fN -R 3307:127.0.0.1:3306
```

Musimy mieć serwer sshd, a także włączoną funkcję tworzenia tuneli. Dodatkowo maszyna testera musi widzieć naszą maszynę - muszą dochodzić pingi. Najlepiej gdyby była to sieć lokalna.

Na naszym linuxie możemy już połączyć się z bazą na maszynie vagranata testera.

``` bash
mysql -uroot -proot -h127.0.0.1 -P3307
```

``` bash
    MySQL [(none)]> show databases;
    +--------------------+
    | Database           |
    +--------------------+
    | information_schema |
    | mysql              |
    | performance_schema |
    | scotchbox          |
    +--------------------+
    4 rows in set (0.00 sec)
```