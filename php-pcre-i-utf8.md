# php - pcre i utf8

Aby sprawdzić, czy biblioteka PCRE obsługuje utf8 wywołujemy poniższy kod PHP

```
php > var_dump(@preg_match('/\pL/u', 'a'));
int(1)
```
Jeśli dostaniemy `1` oznacza to, że biblioteka pcre posiada wsparcie dla utf8.

## Wyłączenie obsługi utf8 w bibliotece pcre

Uruchamiamy php w trybie interaktywnym `php -a`. W innym oknie konsoli uzysujemy identyfikator tego procesu.
```
ps -ef | grep php                                                                                                                                  
root      1472     1  0 09:50 ?        00:00:00 php-fpm: master process (/etc/php7/fpm/php-fpm.conf)                                                 
wwwrun    1629  1472  0 09:50 ?        00:00:00 php-fpm: pool www
wwwrun    1630  1472  0 09:50 ?        00:00:00 php-fpm: pool www
marcin   27117 26445  0 10:50 pts/3    00:00:00 php -a
marcin   28198 27496  0 10:51 pts/4    00:00:00 grep --color=auto php
```

Mając identyfikator procesu `27117` sprawdzamy otwarte pliki procesu. Filtrujemy listę tylko do linii zawierających ciąg `pcre`.

```
lsof -p 27117 2> /dev/null | grep pcre
php     27117 marcin  mem    REG    8,2   575808  265401 /usr/lib64/libpcre.so.1.2.9
```

Sprawdzamy jaki pakiet dostarcza plik `/usr/lib64/libpcre.so.1.2.9`.

```
rpm -qf /usr/lib64/libpcre.so.1.2.9
libpcre1-8.41-lp150.4.15.x86_64
```

Pobieramy pakiet źródłowy `libpcre1` i w pliku z rozszerzeniem `spec` sprawdzamy czy ustawione są flagi:

```
--enable-utf8 \
--enable-unicode-properties
```

Ja za komentowałem te flagi i skompilowałem bibliotekę.
Jeśli biblioteka nie będzie skompilowana z obsługą utf8 to w PHP dostaniemy ostrzeżenie:
```
php > var_dump(preg_match('/\pL/u', 'a'));
PHP Warning:  preg_match(): Compilation failed: this version of PCRE is compiled without UTF support at offset 0 in php shell code on line 1
bool(false)
```

## pcretest

Jeśli mamy zainstalowany pakiet `pcre-tools`, to wykorzystując program `pcretest` możemy sprawdzić, czy biblioteka `pcre` została skompilowana z obsługą utf8.


### wsparcie dla UTF-8 i/lub UTF-16 i/lub UTF-32
Wartość `1` oznacza włączone wsparcie. `0` brak wsparcia.
```
pcretest -C utf
0
```

### wsparcie dla Unicode property
Wartość `1` oznacza włączone wsparcie. `0` brak wsparcia.
```
pcretest -C ucp
1
```

