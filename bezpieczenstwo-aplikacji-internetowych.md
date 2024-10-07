# Bezpieczeństwo aplikacji internetowych

Bezpieczeństwo informacyjne opiera się na trójkącie CIA:
* poufność (ang. confidentiality)
* integralność (ang. integrity)
* dostępność (ang. availability)

Często przytacza się ponadto wymgów zapewnienia:
* niezaprzeczalności (ang. non-repudiation)
* rozliczalności (ang. accountability)

## Porady

* Aplikacja powinna regenerować identyfikator sesji przy każdej zmianie poziomu uprawnień.

* Warto rozważyć zmianę nazwy identyfikatora sesji na bardziej generyczną np. sessionid

* Ciasteczko identyfikatora sesji powinno mieć ustawione flagi HttpOnly i Secure

* Implementując mechanizm Remember me (zapamiętaj mnie) w oparciu o ciasteczko powiniśmy generować nowe ciasteczko "zapamiętaj mnie"

* Pierwszą możliwą do wykorzystania techniką obejścia weryfikacji rozszerzenia wgrywanego pliku jest zastosowanie techniki Null Byte Injection.
Ten sposób ekspoitacji polega na dodaniu do nazwy plików takich ciągów znaków jak %00 lub \x00 (np. shell.php%00.txt).
Interpretery języków skryptowych mogą w takich przypadkach zakończyć przetwarzanie ciągu znaków po napotkaniu ciągu reprezentującego null byte.
Dzięki temu na serwerze utworzony zostanie plik z zamierzonym przez atakującym rozszerzeniem.
