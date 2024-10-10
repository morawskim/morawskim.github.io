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

## XML XXE

W PHP domyślnie wyłączona jest opcja zastępowania encji, co zwiększa bezpieczeństwo przed atakami XML XXE.
Możemy wyłączyć tą opcję ustawiając flagę [LIBXML_NOENT](https://www.php.net/manual/en/libxml.constants.php#constant.libxml-noent).
W dokumentacji PHP mamy informację, że włączenie tej opcji naraża nas na ataki XML XXE
> Enabling entity substitution may facilitate XML External Entity (XXE) attacks.

Przykładowy plik XML, który odczytuje dane z pliku `/etc/passwd`.
```
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE foo [
<!ENTITY x SYSTEM "file:///etc/passwd" >
]>
<root>
    <foo>&x;</foo>
</root>
```

Przykładowy plik PHP podatny na XML XXE:
```
<?php

$xmlFile = file_get_contents('php://stdin');
$xml = simplexml_load_string($xmlFile, options: LIBXML_NOENT);
print_r($xml->foo);
```
